//
//  CaptureView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI
import RealityKit

public struct CaptureView: View {
    @State var model: Model
    
    public init(model: Model) {
        self.model = model
    }

    public var body: some View {
        ObjectCaptureView(session: model.session)
    }
}
