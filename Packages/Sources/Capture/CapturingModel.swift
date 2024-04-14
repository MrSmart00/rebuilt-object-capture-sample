//
//  CapturingModel.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation
import SwiftUI
import RealityKit
import os
import Common
import Folder

@Observable
@MainActor
public class CapturingModel {
    @ObservationIgnored private let logger = Logger(subsystem: "Sandbox", category: .init(describing: CapturingModel.self))
    @ObservationIgnored public static let instance: CapturingModel = .init()
    @ObservationIgnored private var folder: Folder
    @ObservationIgnored private var orbit: Orbit = .orbit1
    @ObservationIgnored private var tasks: [ Task<Void, Never> ] = []
    @ObservationIgnored private var scanPassState: ScanPassState?

    enum ScanPassState {
        case nonFlippable
        case flippable
        case single
    }
    
    var objectCaptureSession: ObjectCaptureSession {
        willSet {
            detachListeners()
        }
        didSet {
            attachListeners()
        }
    }

    public var isReadyToCapture = false
    public var isReadyToReconstruction = false
    
    var isShowOverlay: Bool {
        objectCaptureSession.cameraTracking == .normal
    }
    
    var state: CaptureModelState? {
        didSet {
            guard state != oldValue else {
                return
            }
            perform(with: state)
        }
    }
    
    init() {
        folder = .init()
        objectCaptureSession = .init()
        attachListeners()
        state = .ready
    }
    
    deinit {
        Task {
            await detachListeners()
        }
    }

    private func perform(with state: CaptureModelState?) {
        switch state {
        case .ready:
            startNewCapture()
        case .restart:
            reset()
        case .completad:
            isReadyToReconstruction = true
        default:
            break
        }
    }
    
    private func attachListeners() {
        logger.debug("Attaching listeners...")
        let session = self.objectCaptureSession
        
        tasks.append(Task { [weak self] in
            for await newState in session.cameraTrackingUpdates {
                self?.logger.debug("Task got async state change to (cameraTrackingUpdates): \(String(describing: newState))")
                if case let .limited(reason) = newState, reason != .initializing {
                    if reason == .initializing {
                        self?.isReadyToCapture = false
                    } else {
                        self?.isReadyToCapture = true
                    }
                }
            }
        })

        tasks.append(Task { [weak self] in
            for await newState in session.userCompletedScanPassUpdates {
                if newState {
                    self?.objectCaptureSession.pause()
                    switch self?.scanPassState {
                    case .nonFlippable where self?.orbit != .max:
                        self?.beginNewScanPass()
                    case .flippable where self?.orbit != .max:
                        self?.beginNewScanPassAfterFlip()
                    case _ where self?.orbit == .max:
                        self?.finishCapture()
                    default:
                        self?.state = .finish
                    }
                }
            }
        })

        tasks.append(Task<Void, Never> { [weak self] in
            for await newState in session.stateUpdates {
                self?.logger.debug("Task got async state change to: \(String(describing: newState))")
                self?.onStateChanged(newState: newState)
            }
            self?.logger.log("^^^ Got nil from stateUpdates iterator!  Ending observation task...")
        })
    }
    
    private func detachListeners() {
        logger.debug("Detaching listeners...")
        for task in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }

    private func onStateChanged(newState: ObjectCaptureSession.CaptureState) {
        logger.info("ObjectCaptureSession switched to state: \(String(describing: newState))")
        if case .completed = newState {
            logger.log("ObjectCaptureSession moved to .completed state.  Switch app model to reconstruction...")
            state = .completad
        } else if case let .failed(error) = newState {
            logger.error("ObjectCaptureSession moved to error state \(String(describing: error))...")
            if case ObjectCaptureSession.Error.cancelled = error {
                state = .restart
            } else {
                state = .failed
            }
        }
    }

    func startDetection() {
        if !objectCaptureSession.startDetecting() {
            self.state = .failed
        } else {
            self.state = .detecting
        }
    }
    
    func startCapture() {
        objectCaptureSession.startCapturing()
        self.state = .capturing
    }
    
    func beginNewScanPass() {
        scanPassState = .nonFlippable
        if orbit != .max {
            if objectCaptureSession.isPaused {
                objectCaptureSession.resume()
            }
            objectCaptureSession.beginNewScanPass()
            state = .capturing
            orbit = orbit.next()
        } else {
            finishCapture()
        }
    }
    
    func beginNewScanPassAfterFlip() {
        scanPassState = .flippable
        if orbit != .max {
            if objectCaptureSession.isPaused {
                objectCaptureSession.resume()
            }
            objectCaptureSession.beginNewScanPassAfterFlip()
            state = .capturing
            orbit = orbit.next()
        } else {
            finishCapture()
        }
    }
    
    func finishCapture() {
        scanPassState = .single
        objectCaptureSession.finish()
    }
    
    func cancel() {
        objectCaptureSession.cancel()
    }
    
    public func reset() {
        logger.info("reset() called...")
        folder.resetFolder(with: folder.imagesFolder)
        folder.resetFolder(with: folder.snapshotsFolder)
        objectCaptureSession = .init()
        state = .ready
    }

    private func startNewCapture() {
        logger.log("startNewCapture() called...")
        if !ObjectCaptureSession.isSupported {
            preconditionFailure("ObjectCaptureSession is not supported on this device!")
        }
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = folder.snapshotsFolder
        configuration.isOverCaptureEnabled = true
        logger.log("Enabling overcapture...")
        folder.resetFolder(with: folder.imagesFolder)
        folder.resetFolder(with: folder.snapshotsFolder)
        objectCaptureSession.start(
            imagesDirectory: folder.imagesFolder,
            configuration: configuration
        )

        if case let .failed(error) = objectCaptureSession.state {
            logger.error("Got error starting session! \(String(describing: error))")
            state = .failed
        } else {
            state = .start
        }
    }
}

