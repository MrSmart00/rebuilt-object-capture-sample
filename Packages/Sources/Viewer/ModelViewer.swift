//
//  ModelViewer.swift
//
//
//  Created by 日野森寛也 on 2024/04/14.
//

import ARKit
import QuickLook
import SwiftUI
import UIKit
import os

public struct ModelViewer: View {
    @Environment(\.dismiss) private var dismiss
    let url: URL
    @State var dismissTrigger = false

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        ARQuickLookController(modelFile: url, dismissTrigger: $dismissTrigger)
            .onChange(of: dismissTrigger) {
                dismiss()
            }
    }
}

private struct ARQuickLookController: UIViewControllerRepresentable {
    static let logger = Logger(subsystem: "Sandbox", category: .init(describing: ARQuickLookController.self))
    let modelFile: URL
    @Binding var dismissTrigger: Bool
    
    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
        let controller = QLPreviewControllerWrapper()
        controller.qlvc.dataSource = context.coordinator
        controller.qlvc.delegate = context.coordinator
        return controller
    }

    func makeCoordinator() -> ARQuickLookController.Coordinator {
        return Coordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}

    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: ARQuickLookController

        init(parent: ARQuickLookController) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }

        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            ARQuickLookController.logger.log("Exiting ARQL ...")
            parent.dismissTrigger = true
        }
    }
}

private class QLPreviewControllerWrapper: UIViewController {
    let qlvc = QLPreviewController()
    var qlPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !qlPresented {
            present(qlvc, animated: false, completion: nil)
            qlPresented = true
        }
    }
}
