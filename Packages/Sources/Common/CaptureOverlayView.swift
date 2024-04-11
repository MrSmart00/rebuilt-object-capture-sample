//
//  CaptureOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI

public struct CaptureOverlayView: View {
    let isCancelButtonDisabled: Bool
    let isCenterButtonDisabled: Bool
    private var centerHandler: @Sendable () async -> Void
    private var cancelHandler: @Sendable () async -> Void
    
    public init(
        isCancelButtonDisabled: Bool,
        isCenterButtonDisabled: Bool,
        centerHandler: @escaping @Sendable () async -> Void,
        cancelHandler: @escaping @Sendable () async -> Void
    ) {
        self.isCancelButtonDisabled = isCancelButtonDisabled
        self.isCenterButtonDisabled = isCenterButtonDisabled
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
                        .padding()
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .padding(.leading, 20)
                .disabled(isCancelButtonDisabled ? true : false)
                Spacer()
            }
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                CenterButton(centerHandler)
                    .disabled(isCenterButtonDisabled ? true : false)
                Spacer()
            }
        }
    }
}

private struct CenterButton: View {
    private var handler: @Sendable () async -> Void
    
    init(_ handler: @escaping @Sendable () async -> Void) {
        self.handler = handler
    }

    var body: some View {
        Button(
            action: {
                Task {
                    await handler()
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
    }
}

#Preview {
    CaptureOverlayView(
        isCancelButtonDisabled: false,
        isCenterButtonDisabled: false,
        centerHandler: { },
        cancelHandler: { }
    )
}
