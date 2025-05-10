#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 10.15, *)
private struct QuickLookPreviewModifier: ViewModifier {
    let url: URL
    @State private var isPanelVisible = false

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                isPanelVisible = true
                showQuickLook()
            }
    }

    private func showQuickLook() {
        guard let panel = QLPreviewPanel.shared() else { return }
        panel.dataSource = QuickLookPreviewController(url)
        panel.delegate = QuickLookPreviewController(url)
        panel.updateController()
        panel.makeKeyAndOrderFront(nil)
    }

    private class QuickLookPreviewController: NSObject, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
        let url: URL

        init(_ url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int { 1 }

        func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem {
            url as QLPreviewItem
        }
    }
}

@available(macOS 10.15, *)
public extension View {
    func quickLookPreview(_ url: URL) -> some View {
        modifier(QuickLookPreviewModifier(url: url))
    }
}
#endif
