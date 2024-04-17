//
//  DocumentBrowser.swift
//
//
//  Created by 日野森寛也 on 2024/04/13.
//

import SwiftUI
import UniformTypeIdentifiers

public struct DocumentBrowser: UIViewControllerRepresentable {
    let startingDir: URL
    @Binding var selectedItem: URL?
    
    public init(startingDir: URL, selectedItem: Binding<URL?>) {
        self.startingDir = startingDir
        self._selectedItem = selectedItem
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        controller.directoryURL = startingDir
        controller.delegate = context.coordinator
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: UIDocumentPickerViewController,
        context: Context) {}
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentBrowser
        
        init(_ parent: DocumentBrowser) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedItem = urls.first
        }
    }
}


#Preview {
    DocumentBrowser(startingDir: .init(string: "")!, selectedItem: .constant(nil))
}
