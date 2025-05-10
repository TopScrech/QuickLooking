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
        self.blur = blur
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
        
        if let contentView = panel.contentView {
            for subview in contentView.subviews {
                if let blurView = subview as? NSVisualEffectView {
                    blurView.removeFromSuperview()
                }
            }
            
            if blur {
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
        url: URL?,
        blur: Bool = false
    ) -> some View {
        modifier(
            QuickLookPreviewModifier(isPresented, url: url, blur: blur)
        )
    }
}
#endif
