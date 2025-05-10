#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 11, *)
private struct QuickLookPreviewModifier: ViewModifier {
    @Binding private var isPresented: Bool
    @Binding private var blur: Bool
    private let url: URL?
    
    init(_ isPresented: Binding<Bool>, blur: Binding<Bool>, url: URL?) {
        _isPresented = isPresented
        _blur = blur
        self.url = url
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _ in
                if isPresented {
                    if let url {
                        showQuickLook(url)
                    }
                    
                    isPresented = false
                }
            }
    }
    
    private func showQuickLook(_ url: URL) {
        guard let panel = QLPreviewPanel.shared() else {
            return
        }
        
        let controller = QuickLookPreviewController(url)
        panel.dataSource = controller
        panel.delegate = controller
        panel.updateController()
        panel.makeKeyAndOrderFront(nil)
        
        if blur {
            if let contentView = panel.contentView {
                let blurView = NSVisualEffectView()
                blurView.blendingMode = .withinWindow
                blurView.material = .hudWindow
                blurView.state = .active
                blurView.translatesAutoresizingMaskIntoConstraints = false
                
                contentView.addSubview(blurView, positioned: .above, relativeTo: nil)
                
                NSLayoutConstraint.activate([
                    blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            }
        }
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
        blur: Binding<Bool> = .constant(false),
        url: URL?
    ) -> some View {
        modifier(QuickLookPreviewModifier(isPresented, blur: blur, url: url))
    }
}
#endif
