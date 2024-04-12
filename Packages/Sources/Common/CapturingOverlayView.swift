//
//  CapturingOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/12.
//

import SwiftUI

public struct CapturingOverlayView: View {
    let cancelHandler: @Sendable () async -> Void
    
    public init(cancelHandler: @escaping @Sendable () async -> Void) {
        self.cancelHandler = cancelHandler
    }

    public var body: some View {
        VStack {
            HStack {
                Button {
                    Task { await cancelHandler() }
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(CircleButtonStyle())
                .padding(.leading, 20)
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    CapturingOverlayView(cancelHandler: { })
}
