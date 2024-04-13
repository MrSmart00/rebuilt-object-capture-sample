//
//  CapsuleButtonStyle.swift
//  
//
//  Created by 日野森寛也 on 2024/04/12.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .frame(height: 44)
            .background(.blue)
            .foregroundColor(.white)
            .font(.body.bold())
            .clipShape(Capsule())
    }
}
