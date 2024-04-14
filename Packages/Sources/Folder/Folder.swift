//
//  Folder.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation
import os

@MainActor
public struct Folder {
    static let logger = Logger(subsystem: "Sandbox", category: "Folder")

    public let rootScanFolder: URL = {
        let documentsFolder = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return documentsFolder.appendingPathComponent("Scans/", isDirectory: true)
    }()
    
    public let imagesFolder: URL
    public let snapshotsFolder: URL
    public let modelsFolder: URL
    
    public init() {
        let newFolder = Self.createNewScanDirectory(rootScanFolder)!

        imagesFolder = newFolder.appendingPathComponent("Images/")
        Self.createDirectoryRecursively(imagesFolder)

        snapshotsFolder = newFolder.appendingPathComponent("Snapshots/")
        Self.createDirectoryRecursively(snapshotsFolder)

        modelsFolder = newFolder.appendingPathComponent("Models/")
        Self.createDirectoryRecursively(modelsFolder)
    }
    
    public func resetFolder(with url: URL) {
        let fileManager = FileManager()
        try? fileManager.removeItem(at: url)
    }
    
    static func createNewScanDirectory(_ root: URL) -> URL? {
        logger.log("Creating capture path: \"\(String(describing: root))\"")
        let capturePath = root.path
        do {
            try FileManager.default.createDirectory(
                atPath: capturePath,
                withIntermediateDirectories: true
            )
        } catch {
            logger.error("Failed to create capturepath=\"\(capturePath)\" error=\(String(describing: error))")
            return nil
        }
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: capturePath, isDirectory: &isDir)
        guard exists && isDir.boolValue else {
            return nil
        }
        return root
    }

    static func createDirectoryRecursively(_ outputDir: URL) {
        guard outputDir.isFileURL else {
            return
        }
        let expandedPath = outputDir.path
        var isDirectory: ObjCBool = false
        let fileManager = FileManager()
        guard !fileManager.fileExists(atPath: outputDir.path, isDirectory: &isDirectory) else {
            logger.warning("File already exists at \(expandedPath)")
            return
        }

        logger.log("Creating dir recursively: \"\(expandedPath)\"")

        let result: ()? = try? fileManager.createDirectory(
            atPath: expandedPath,
            withIntermediateDirectories: true
        )

        guard result != nil else {
            return
        }

        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: expandedPath, isDirectory: &isDir) && isDir.boolValue else {
            logger.warning("Dir \"\(expandedPath)\" doesn't exist after creation!")
            return
        }

        logger.log("... success creating dir.")
    }
    
}
