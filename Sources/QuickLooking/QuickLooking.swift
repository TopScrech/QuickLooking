// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import QuickLook

@available(iOS 13, *)
public struct QuickLookView: UIViewControllerRepresentable {
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

@available(iOS 13, *)
public final class Coordinator: NSObject, QLPreviewControllerDataSource {
    private var parent: QuickLookView
    
    init(_ parent: QuickLookView) {
        self.parent = parent
    }
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        parent.url as QLPreviewItem
    }
}
