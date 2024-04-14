//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI
import Capture
import Common
import FileBrowser
import Folder
import Reconstruction

@MainActor
public struct ContentView: View {
    @State var isOpenFileView = false
    @State var selectedItemURL: URL?
    @State var isReconstruction = false
    let captureModel: CapturingModel = .instance
    let folder = Folder()

    public init() { }

    public var body: some View {
        VStack {
            if captureModel.isReadyToCapture {
                CaptureView(model: captureModel)
            } else {
                CircularProgressView()
            }
        }
        .overlay {
            FileOpenOverlayView { @MainActor in
                isOpenFileView = true
            }
        }
        .sheet(isPresented: $isOpenFileView) {
            DocumentBrowser(startingDir: folder.rootScanFolder, selectedItem: $selectedItemURL)
        }
        .onChange(of: captureModel.isReadyToReconstruction == true, {
            isReconstruction = true
        })
        .sheet(isPresented: $isReconstruction, onDismiss: {
            captureModel.reset()
        }, content: {
            ReconstructionProgressView(model: .instance)
        })
        .onChange(of: selectedItemURL) {
            print(selectedItemURL)
        }
    }
}
