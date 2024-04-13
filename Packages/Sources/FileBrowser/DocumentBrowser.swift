//
//  DocumentBrowser.swift
//
//
//  Created by 日野森寛也 on 2024/04/13.
//

import SwiftUI
import UniformTypeIdentifiers
import os

public struct DocumentBrowser: UIViewControllerRepresentable {
    let startingDir: URL

    public init(startingDir: URL) {
        self.startingDir = startingDir
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentBrowser>) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        controller.directoryURL = startingDir
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: UIDocumentPickerViewController,
        context: UIViewControllerRepresentableContext<DocumentBrowser>) {}
}

#Preview {
    DocumentBrowser(startingDir: .init(string: "")!)
}
