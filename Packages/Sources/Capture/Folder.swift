//
//  Folder.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation
import os

struct Folder {
    static let logger = Logger(subsystem: "Sandbox", category: "Folder")

    let rootScanFolder: URL
    let imagesFolder: URL
    let snapshotsFolder: URL
    let modelsFolder: URL
    
    init() {
        let newFolder = Self.createNewScanDirectory()!
        rootScanFolder = newFolder

        imagesFolder = newFolder.appendingPathComponent("Images/")
        Self.createDirectoryRecursively(imagesFolder)

        snapshotsFolder = newFolder.appendingPathComponent("Snapshots/")
        Self.createDirectoryRecursively(snapshotsFolder)

        modelsFolder = newFolder.appendingPathComponent("Models/")
        Self.createDirectoryRecursively(modelsFolder)
    }
    
    static func createNewScanDirectory() -> URL? {
        let rootScansFolder: URL? = {
            guard let documentsFolder = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ) else {
                return nil
            }
            return documentsFolder.appendingPathComponent("Scans/", isDirectory: true)
        }()
        
        guard let capturesFolder = rootScansFolder else {
            logger.error("Can't get user document dir!")
            return nil
        }

        let formatter = ISO8601DateFormatter()
        let timestamp = formatter.string(from: Date())
        let newCaptureDir = capturesFolder
            .appendingPathComponent(timestamp, isDirectory: true)

        logger.log("Creating capture path: \"\(String(describing: newCaptureDir))\"")
        let capturePath = newCaptureDir.path
        do {
            try FileManager.default.createDirectory(atPath: capturePath,
                                                    withIntermediateDirectories: true)
        } catch {
            logger.error("Failed to create capturepath=\"\(capturePath)\" error=\(String(describing: error))")
            return nil
        }
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: capturePath, isDirectory: &isDir)
        guard exists && isDir.boolValue else {
            return nil
        }

        return newCaptureDir
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
