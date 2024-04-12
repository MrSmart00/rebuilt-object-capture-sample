//
//  CaptureOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI

public struct DetectingOverlayView: View {
    let centerHandler: @Sendable () async -> Void
    let cancelHandler: @Sendable () async -> Void

    public init(
        centerHandler: @escaping @Sendable () async -> Void,
        cancelHandler: @escaping @Sendable () async -> Void
    ) {
        self.centerHandler = centerHandler
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
            HStack(alignment: .bottom) {
                Spacer()
                Button(
                    action: {
                        Task { await centerHandler() }
                    },
                    label: {
                        Text("Capturing")
                    })
                .buttonStyle(CapsuleButtonStyle())
                Spacer()
            }
        }
    }
}

#Preview {
    DetectingOverlayView(
        centerHandler: { },
        cancelHandler: { }
    )
}
