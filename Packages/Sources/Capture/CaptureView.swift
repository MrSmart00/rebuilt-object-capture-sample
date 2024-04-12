//
//  CaptureView.swift
//
//
//  Created by 日野森寛也 on 2024/04/09.
//

import SwiftUI
import RealityKit
import Common

public struct CaptureView: View {
    @State var model: Model
    
    public init(model: Model) {
        self.model = model
    }

    public var body: some View {
        ZStack {
            ObjectCaptureView(session: model.objectCaptureSession)
                .ignoresSafeArea()
                .id(model.objectCaptureSession.id)
            if model.isShowOverlay {
                switch model.state {
                case .start:
                    ReadyingOverlayView(centerHandler: { await model.start() })
                case .detecting:
                    DetectingOverlayView(centerHandler: { await model.start() }, cancelHandler: { await model.cancel() })
                case .capturing:
                    CapturingOverlayView(cancelHandler: { await model.cancel() })
                default:
                    EmptyView()
                }
            }
        }
    }
}
