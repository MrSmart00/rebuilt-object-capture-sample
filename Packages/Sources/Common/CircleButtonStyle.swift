//
//  CircleButtonStyle.swift
//  
//
//  Created by 日野森寛也 on 2024/04/12.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .symbolRenderingMode(.monochrome)
            .frame(width: 44, height: 44)
            .background(.ultraThinMaterial)
            .foregroundStyle(.blue)
            .clipShape(Circle())
    }
}
