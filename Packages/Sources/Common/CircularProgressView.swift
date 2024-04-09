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
}

#Preview {
    Group {
        CircularProgressView()
        CircularProgressView()
            .environment(\.colorScheme, .dark)
            .background(.black)
    }
}
