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

@MainActor
public struct ContentView: View {
    @State var isOpenFileView = false
    let model: CapturingModel = .instance
    let folder = Folder()

    public init() { }

    public var body: some View {
        VStack {
            if model.isReadyToCapture {
                CaptureView(model: model)
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
            DocumentBrowser(startingDir: folder.rootScanFolder)
        }
    }
}
