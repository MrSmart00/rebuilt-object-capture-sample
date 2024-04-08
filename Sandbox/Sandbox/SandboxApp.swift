//
//  SandboxApp.swift
//  Sandbox
//
//  Created by 日野森寛也 on 2024/04/08.
//

import SwiftUI

@main
@MainActor
struct SandboxApp: App {
    let model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
