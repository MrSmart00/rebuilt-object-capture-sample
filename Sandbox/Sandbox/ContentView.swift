//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI
import RealityKit

@MainActor
struct ContentView: View {
    @State var model: Model

    var body: some View {
        VStack {
            if model.state == .capturing {
                ObjectCaptureView(session: model.session)
            } else {
                Text("Loading...")
            }
        }
        .ignoresSafeArea()
    }
}
