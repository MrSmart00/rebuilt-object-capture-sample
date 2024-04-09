//
//  Model.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation
import SwiftUI
import RealityKit

@Observable
@MainActor
class Model {
    let session: ObjectCaptureSession
    var state: State? {
        didSet {
            guard state != oldValue else {
                return
            }
            perform(with: state)
        }
    }
    
    init() {
        session = .init()
        state = .ready
    }
    
    func perform(with state: State?) {
        switch state {
        case .ready:
            print(state)
            startNewCapture()
        case .capturing:
            print(state)
        case .none:
            print(state)
        }
    }
    
    func startNewCapture() {
        if !ObjectCaptureSession.isSupported {
            preconditionFailure("ObjectCaptureSession is not supported on this device!")
        }
        let folder = Folder()
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = folder.snapshotsFolder
        configuration.isOverCaptureEnabled = true
        session.start(
            imagesDirectory: folder.imagesFolder,
            configuration: configuration
        )

        if case let .failed(error) = session.state {
            print("Got error starting session! \(String(describing: error))")
        } else {
            state = .capturing
        }
    }
}

extension Model {
    enum State {
        case ready
        case capturing
    }
}
