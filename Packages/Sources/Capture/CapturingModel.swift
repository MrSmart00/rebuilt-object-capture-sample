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
    private let logger = Logger(subsystem: "Sandbox", category: .init(describing: CapturingModel.self))
    public static let instance: CapturingModel = .init()

    private var folder: Folder
    
    var objectCaptureSession: ObjectCaptureSession {
        willSet {
            detachListeners()
        }
        didSet {
            attachListeners()
        }
    }

    var isCancelButtonDisabled: Bool {
        objectCaptureSession.state == .ready || objectCaptureSession.state == .initializing
    }
    public var isReadyToCapture = false
    
    var isShowOverlay: Bool {
        (!objectCaptureSession.isPaused && objectCaptureSession.cameraTracking == .normal)
    }
    var isCapturingStarted: Bool {
        switch objectCaptureSession.state {
            case .initializing, .ready, .detecting:
                return false
            default:
                return true
        }
    }
    
    var state: CaptureModelState? {
        didSet {
            guard state != oldValue else {
                return
            }
            perform(with: state)
        }
    }
    
    private var tasks: [ Task<Void, Never> ] = []

    typealias Feedback = ObjectCaptureSession.Feedback

    init() {
        folder = .init()
        objectCaptureSession = .init()
        attachListeners()
        state = .ready
    }
    
    private func perform(with state: CaptureModelState?) {
        switch state {
        case .ready:
            startNewCapture()
        case .restart:
            reset()
        case .start, .detecting, .capturing, .completad, .failed, .none:
            print(state)
        }
    }
    
    @MainActor
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
                    self?.state = .completad
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

    @MainActor
    func startDetection() {
        if !objectCaptureSession.startDetecting() {
            self.state = .failed
        } else {
            self.state = .detecting
        }
    }
    
    @MainActor
    func startCapture() {
        objectCaptureSession.startCapturing()
        self.state = .capturing
    }
    
    @MainActor
    func cancel() {
        objectCaptureSession.cancel()
    }
    
    private func reset() {
        logger.info("reset() called...")
        folder = .init()
        objectCaptureSession = .init()
        state = .ready
    }

    @MainActor
    private func startNewCapture() {
        logger.log("startNewCapture() called...")
        if !ObjectCaptureSession.isSupported {
            preconditionFailure("ObjectCaptureSession is not supported on this device!")
        }
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = folder.snapshotsFolder
        configuration.isOverCaptureEnabled = true
        logger.log("Enabling overcapture...")
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

