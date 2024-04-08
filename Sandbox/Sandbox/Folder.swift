//
//  Folder.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import Foundation

struct Folder {
    
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
        var scansFolder: URL {
            let documentsFolder = try! FileManager
                .default
                .url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: false
                )
            return documentsFolder
                .appendingPathComponent("Scans/", isDirectory: true)
        }

        let capturePath = scansFolder.path
        var isDir: ObjCBool = false
        guard !FileManager.default.fileExists(atPath: scansFolder.path, isDirectory: &isDir) else {
            print("File already exists at \(scansFolder)")
            return scansFolder
        }
        do {
            try FileManager.default.createDirectory(
                atPath: capturePath,
                withIntermediateDirectories: true
            )
        } catch {
            print("Failed to create capturepath=\"\(capturePath)\" error=\(String(describing: error))")
            return nil
        }
        print("Creating capture path: \"\(String(describing: scansFolder))\"")
        return scansFolder
    }
    
    static func createDirectoryRecursively(_ outputDir: URL) {
        guard outputDir.isFileURL else {
            return
        }
        let expandedPath = outputDir.path
        var isDirectory: ObjCBool = false
        let fileManager = FileManager()
        guard !fileManager.fileExists(atPath: outputDir.path, isDirectory: &isDirectory) else {
            print("File already exists at \(expandedPath)")
            return
        }

        print("Creating dir recursively: \"\(expandedPath)\"")

        let result: ()? = try? fileManager.createDirectory(
            atPath: expandedPath,
            withIntermediateDirectories: true
        )

        guard result != nil else {
            return
        }

        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: expandedPath, isDirectory: &isDir) && isDir.boolValue else {
            print("Dir \"\(expandedPath)\" doesn't exist after creation!")
            return
        }

        print("... success creating dir.")
    }
    
}
