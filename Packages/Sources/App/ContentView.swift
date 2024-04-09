//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI
import Capture

@MainActor
public struct ContentView: View {
    let model: Model = .instance

    public init() { }

    public var body: some View {
        VStack {
            if model.state == .capturing {
                CaptureView(model: model)
            } else {
                Text("Loading...")
            }
        }
        .ignoresSafeArea()
    }
}
