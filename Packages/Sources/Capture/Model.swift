//
//  Model.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation
import SwiftUI
import RealityKit
import os

@Observable
@MainActor
public class Model {
    private let logger = Logger(subsystem: "exam", category: "Model")
    public static let instance: Model = .init()

    private let folder = Folder()
    var objectCaptureSession: ObjectCaptureSession {
        willSet {
            detachListeners()
        }
        didSet {
            guard objectCaptureSession != nil else { return }
            attachListeners()
        }
    }

    var isCancelButtonDisabled: Bool {
        objectCaptureSession.state == .ready || objectCaptureSession.state == .initializing
    }
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
    
    private var photogrammetrySession: PhotogrammetrySession?
    
    public var state: State? {
        didSet {
            guard state != oldValue else {
                return
            }
            perform(with: state)
        }
    }
    
    init() {
        objectCaptureSession = .init()
        attachListeners()
        state = .ready
    }
    
    private func perform(with state: State?) {
        switch state {
        case .ready:
            startNewCapture()
        case .restart:
            reset()
        case .capturing, .prepareToReconstruct, .reconstructing, .failed, .none:
            print(state)
        }
    }
    
    private var tasks: [ Task<Void, Never> ] = []

    @MainActor
    private func attachListeners() {
        logger.debug("Attaching listeners...")
        let session = self.objectCaptureSession
        
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
            state = .prepareToReconstruct
        } else if case let .failed(error) = newState {
            logger.error("ObjectCaptureSession moved to error state \(String(describing: error))...")
            if case ObjectCaptureSession.Error.cancelled = error {
                state = .restart
            } else {
                state = .failed
            }
        }
    }

    func start() {
        logger.debug("startDetecting() called.")
        let state = objectCaptureSession.state
        if case .ready = state {
            if !objectCaptureSession.startDetecting() {
                self.state = .failed
            }
        } else if case .detecting = state {
            objectCaptureSession.startCapturing()
        }
    }
    
    func cancel() {
        objectCaptureSession.cancel()
    }
    
    private func startReconstruction() throws {
        logger.debug("startReconstruction() called.")

        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = folder.snapshotsFolder
        photogrammetrySession = try PhotogrammetrySession(
            input: folder.imagesFolder,
            configuration: configuration
        )

        state = .reconstructing
    }

    private func reset() {
        logger.info("reset() called...")
        photogrammetrySession = nil
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
        objectCaptureSession.start(
            imagesDirectory: folder.imagesFolder,
            configuration: configuration
        )

        if case let .failed(error) = objectCaptureSession.state {
            logger.error("Got error starting session! \(String(describing: error))")
            state = .failed
        } else {
            state = .capturing
        }
    }
}

extension Model {
    public enum State {
        case ready
        case capturing
        case prepareToReconstruct
        case restart
        case reconstructing
        case failed
    }
}
