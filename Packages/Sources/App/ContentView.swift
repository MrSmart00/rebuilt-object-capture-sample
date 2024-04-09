//
//  ContentView.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI
import RealityKit

@MainActor
public struct ContentView: View {
    @State var model: Model = .instance

    public init() { }

    public var body: some View {
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

extension Model {
    static let instance: Model = .init()
}
