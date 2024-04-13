//
//  CircularProgressView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI

public struct CircularProgressView: View {
    @Environment(\.colorScheme) private var colorScheme

    public init() { }

    public var body: some View {
        ZStack {
            VStack {
                Text("Now Prepearing...")
                    .padding(.top, 100)
            }
            VStack {
                Spacer()
                ZStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? .black : .white))
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    Group {
        CircularProgressView()
        CircularProgressView()
            .environment(\.colorScheme, .dark)
            .background(.black)
    }
}
