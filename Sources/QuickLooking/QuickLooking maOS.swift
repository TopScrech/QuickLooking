#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 11, *)
private struct QuickLookPreviewModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let url: URL?
    private let blur: Bool
    
    init(_ isPresented: Binding<Bool>, url: URL?, blur: Bool) {
        _isPresented = isPresented
        self.url = url
        self.blur = blur
    }
    
    func body(content: Content) -> some View {
        content
            .blur(radius: blur ? 10 : 0)
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
    func quickLookPreview(
        _ isPresented: Binding<Bool>,
        url: URL?,
        blur: Bool = false
    ) -> some View {
        modifier(QuickLookPreviewModifier(isPresented, url: url, blur: blur))
    }
}
#endif
