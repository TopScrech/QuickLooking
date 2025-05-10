#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 11, *)
private struct QuickLookPreviewModifier: ViewModifier {
    let url: URL
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                if isPresented {
                    showQuickLook()
                    isPresented = false
                }
            }
    }
    
    private func showQuickLook() {
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
    func quickLookPreview(_ url: URL, isPresented: Binding<Bool>) -> some View {
        modifier(QuickLookPreviewModifier(url: url, isPresented: isPresented))
    }
}
#endif
