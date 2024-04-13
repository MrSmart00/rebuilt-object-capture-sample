//
//  FileOpenOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/13.
//

import SwiftUI

public struct FileOpenOverlayView: View {
    let handler: @Sendable () async -> Void
    
    public init(handler: @escaping @Sendable () async -> Void) {
        self.handler = handler
    }

    public var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Button(
                    action: {
                        Task { await handler() }
                    },
                    label: {
                        Image(systemName: "folder")
                    })
                .buttonStyle(CircleButtonStyle())
                .padding(.leading, 20)
                Spacer()
            }
        }
    }
}

#Preview {
    FileOpenOverlayView { }
}
