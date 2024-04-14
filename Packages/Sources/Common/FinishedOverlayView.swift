//
//  FinishedOverlayView.swift
//
//
//  Created by 日野森寛也 on 2024/04/14.
//

import SwiftUI

public struct FinishedOverlayView: View {
    let topButtonHandler: @Sendable () async -> Void
    let middleButtonHandler: @Sendable () async -> Void
    let bottomButtonHandler: @Sendable () async -> Void

    public init(
        topButtonHandler: @escaping @Sendable () async -> Void,
        middleButtonHandler: @escaping @Sendable () async -> Void,
        bottomButtonHandler: @escaping @Sendable () async -> Void
    ) {
        self.topButtonHandler = topButtonHandler
        self.middleButtonHandler = middleButtonHandler
        self.bottomButtonHandler = bottomButtonHandler
    }

    public var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Do you want to finish the capture section?")
                    .font(.title.bold())
                    .padding(.bottom, 20)
                HStack {
                    Text("Apple recommends capturing")
                    Text("3")
                        .font(.headline)
                    Text("times.")
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            Button(action: {
                Task { await topButtonHandler() }
            }, label: {
                Text("3 Times(Non Flippable)")
            })
            .buttonStyle(FinishedOverlayButtonStyle())

            Button(action: {
                Task { await middleButtonHandler() }
            }, label: {
                Text("3 Times")
            })
            .buttonStyle(FinishedOverlayButtonStyle())

            Button(action: {
                Task { await bottomButtonHandler() }
            }, label: {
                Text("Finish")
            })
            .buttonStyle(FinishedOverlayButtonStyle())
        }
        .padding(20)
    }
}

struct FinishedOverlayButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(20)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    FinishedOverlayView(
        topButtonHandler: {},
        middleButtonHandler: {},
        bottomButtonHandler: {}
    )
}
