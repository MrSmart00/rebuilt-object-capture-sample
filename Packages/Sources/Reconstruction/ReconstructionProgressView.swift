//
//  ReconstructionProgressView.swift
//
//
//  Created by 日野森寛也 on 2024/04/14.
//

import SwiftUI
import Common

public struct ReconstructionProgressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    let model: ReconstructionModel
    
    public init(model: ReconstructionModel) {
        self.model = model
    }

    public var body: some View {
        ZStack {
            CircularProgressView()
            VStack {
                Spacer()
                Text(model.progress, format: .percent.precision(.fractionLength(0)))
                    .bold()
                    .monospacedDigit()
            }
        }
        .onAppear(perform: {
            Task { @MainActor in
                try await model.start()
            }
        })
        .onChange(of: model.isCompleted) {
            dismiss()
        }
    }
}

#Preview {
    ReconstructionProgressView(model: .init())
}
