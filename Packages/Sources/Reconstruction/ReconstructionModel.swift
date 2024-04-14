//
//  ReconstructionModel.swift
//
//
//  Created by 日野森寛也 on 2024/04/14.
//

import Foundation
import Folder
import os
import RealityKit

@Observable
@MainActor
public class ReconstructionModel {
    private let logger = Logger(subsystem: "Sandbox", category: .init(describing: ReconstructionModel.self))

    private var photogrammetrySession: PhotogrammetrySession? {
        willSet {
            detachListeners()
        }
        didSet {
            attachListeners()
        }
    }
    
    public static let instance: ReconstructionModel = .init()
    
    var progress: Float = 0
    
    var isCompleted = false
    
    private var tasks: [ Task<Void, any Error> ] = []
    
    public init() { }

    @MainActor
    func start() async throws {
        logger.debug("startReconstruction() called.")

        var configuration = PhotogrammetrySession.Configuration()
        let folder = Folder()
        configuration.checkpointDirectory = folder.snapshotsFolder
        photogrammetrySession = try PhotogrammetrySession(
            input: folder.imagesFolder,
            configuration: configuration
        )
        let formatter = ISO8601DateFormatter()
        let timestamp = formatter.string(from: .now)
        let outputURL = folder.modelsFolder.appendingPathComponent(timestamp + ".usdz")
        try photogrammetrySession?.process(requests: [.modelFile(url: outputURL)])
    }
    
    @MainActor
    private func attachListeners() {
        guard let photogrammetrySession else { return }
        logger.log("Attaching listeners...")
        tasks.append(Task { [weak self] in
            for try await output in photogrammetrySession.outputs {
                self?.logger.log("PhotogrammetrySession got async output change to: \(String(describing: output))")
                switch output {
                case .requestProgress(let request, fractionComplete: let fractionComplete):
                    if case .modelFile = request {
                        self?.progress = Float(fractionComplete)
                    }
                case .requestComplete(let request, _):
                    switch request {
                        case .modelFile(_, _, _):
                            self?.logger.log("RequestComplete: .modelFile")
                        case .modelEntity(_, _), .bounds, .poses, .pointCloud:
                            // Not supported yet
                            break
                        @unknown default:
                            self?.logger.warning("Received an output for an unknown request: \(String(describing: request))")
                    }
                case .requestError, .processingCancelled:
                    self?.isCompleted = true
                case .processingComplete:
                    self?.isCompleted = true
                default:
                    break
                }
            }
        })
    }
    
    private func detachListeners() {
        logger.debug("Detaching listeners...")
        for task in tasks {
            task.cancel()
        }
        tasks.removeAll()
    }
}
