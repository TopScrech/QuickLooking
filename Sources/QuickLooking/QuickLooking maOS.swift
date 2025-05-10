#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 11, *)
private struct QuickLookPreviewModifier: ViewModifier {
    private let url: URL?
    @Binding private var isPresented: Bool
    
    init(_ isPresented: Binding<Bool>, url: URL?) {
        _isPresented = isPresented
        self.url = url
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                if isPresented {
                    if let url {
                        showQuickLook(for: url)
                    }
                    
                    isPresented = false
                }
            }
    }
    
    private func showQuickLook(for url: URL) {
        guard let panel = QLPreviewPanel.shared() else {
            return
        }
        
        let controller = QuickLookPreviewController(url)
        panel.dataSource = controller
        panel.delegate = controller
        panel.updateController()
        panel.makeKeyAndOrderFront(nil)
    }
    
    private final class QuickLookPreviewController: NSObject, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
        let url: URL
        
        init(_ url: URL) {
            self.url = url
        }
        
        func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
            1
        }
        
        func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem {
            url as QLPreviewItem
        }
    }
}

@available(macOS 11, *)
public extension View {
    func quickLookPreview(_ isPresented: Binding<Bool>, url: URL?) -> some View {
        modifier(QuickLookPreviewModifier(isPresented, url: url))
    }
}
#endif
