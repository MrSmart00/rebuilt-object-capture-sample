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
    let model: Model = .instance

    public init() { }

    public var body: some View {
        VStack {
            CaptureView(model: model)
        }
        .alert(isPresented: .init(get: {
            model.state == .failed
        }, set: { _ in }), content: {
            Alert(
                title: .init("Something Error!!!!"),
                message: .init("please re-install the app."),
                dismissButton: .destructive(.init("OK"))
            )
        })
    }
}
