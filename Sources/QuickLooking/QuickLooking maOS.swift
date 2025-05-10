#if os(macOS)
import SwiftUI
import QuickLookUI

@available(macOS 10.5, *)
public struct QuickLookView: NSViewControllerRepresentable {
    let url: URL
    
    public init(_ url: URL) {
        self.url = url
    }
    
    public func makeNSViewController(context: Context) -> QuickLookHostingController {
        QuickLookHostingController(url)
    }
    
    public func updateNSViewController(_ nsViewController: QuickLookHostingController, context: Context) {}
}

@available(macOS 10.5, *)
public final class QuickLookHostingController: NSViewController, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear() {
        super.viewDidAppear()
        QLPreviewPanel.shared()?.updateController()
        QLPreviewPanel.shared()?.makeKeyAndOrderFront(nil)
    }
    
    public override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        true
    }
    
    public override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = self
        panel.delegate = self
    }
    
    public override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = nil
        panel.delegate = nil
    }
    
    public func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        1
    }
    
    public func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem {
        url as QLPreviewItem
    }
}
#endif
