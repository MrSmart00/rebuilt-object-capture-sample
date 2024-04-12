//
//  ReadyingOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/12.
//

import SwiftUI

public struct ReadyingOverlayView: View {
    let centerHandler: @Sendable () async -> Void
    
    public init(centerHandler: @escaping @Sendable () async -> Void) {
        self.centerHandler = centerHandler
    }

    public var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Button(
                    action: {
                        Task { await centerHandler() }
                    },
                    label: {
                        Text("Detecting")
                    })
                .buttonStyle(CapsuleButtonStyle())

                Spacer()
            }
        }
    }
}

#Preview {
    ReadyingOverlayView(centerHandler: { })
}
