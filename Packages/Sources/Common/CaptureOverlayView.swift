//
//  CaptureOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI

public struct CaptureOverlayView: View {
    private var centerHandler: @Sendable () async -> Void
    
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
                        Task {
                            await centerHandler()
                        }
                    },
                    label: {
                        Text("continue")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 20)
                            .background(.blue)
                            .clipShape(Capsule())
                    })

                Spacer()
            }
        }
    }
}

#Preview {
    CaptureOverlayView(centerHandler: { })
}
