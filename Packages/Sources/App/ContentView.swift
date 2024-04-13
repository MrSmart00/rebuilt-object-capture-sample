//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI
import Capture
import Common

@MainActor
public struct ContentView: View {
    let model: CapturingModel = .instance

    public init() { }

    public var body: some View {
        VStack {
            if model.isReadyToCapture {
                CaptureView(model: model)
            } else {
                CircularProgressView()
            }
        }
    }
}
