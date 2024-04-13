//
//  CompletedOverlayView.swift
//  
//
//  Created by 日野森寛也 on 2024/04/13.
//

import SwiftUI

public struct CompletedOverlayView: View {
    let handler: @Sendable () async -> Void
    
    public init(handler: @escaping @Sendable () async -> Void) {
        self.handler = handler
    }

    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button(action: {
                    Task { await handler() }
                }, label: {
                    Text("Finish")
                })
                .buttonStyle(CapsuleButtonStyle())
            }
            Text("Capture Success 🎉")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .padding(20)
                .background(Color.orange)
                .cornerRadius(10)
        }
    }
}

#Preview {
    CompletedOverlayView(handler: {  })
}
