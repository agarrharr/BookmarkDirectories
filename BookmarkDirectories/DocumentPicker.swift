//
//  DocumentPicker.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 8/20/21.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @EnvironmentObject private var bookmarkController: BookmarkController
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker =
            UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.bookmarkController.addBookmark(for: urls[0])
        }
    }
}
