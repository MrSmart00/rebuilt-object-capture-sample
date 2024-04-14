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
        Coordinator($selectedItem)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentBrowser>) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        controller.directoryURL = startingDir
        controller.delegate = context.coordinator
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: UIDocumentPickerViewController,
        context: UIViewControllerRepresentableContext<DocumentBrowser>) {}
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var selectedItem: URL?
        
        init(_ selectedItem: Binding<URL?>) {
            self._selectedItem = selectedItem
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            selectedItem = urls.first
        }
    }
}


#Preview {
    DocumentBrowser(startingDir: .init(string: "")!, selectedItem: .constant(nil))
}
