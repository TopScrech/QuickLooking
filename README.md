# QuickLooking

Swift package that takes the pain out of implementing Quick Look previews

## Platforms
- iOS 13+
- macOS 11+

## Installation
Add `QuickLooking` to your Swift Package dependencies and import it where needed

```swift
import QuickLooking
```

## Usage

### iOS
Present `QuickLookView` with a file URL

```swift
import SwiftUI
import QuickLooking

struct ContentView: View {
    @State private var showPreview = false

    let fileURL: URL

    var body: some View {
        Button("Preview") {
            showPreview = true
        }
        .sheet(isPresented: $showPreview) {
            QuickLookView(fileURL)
        }
    }
}
```

### macOS
Use `.quickLookPreview` with a binding and URL

```swift
import SwiftUI
import QuickLooking

struct ContentView: View {
    @State private var showPreview = false

    let fileURL: URL

    var body: some View {
        Button("Preview") {
            showPreview = true
        }
        .quickLookPreview($showPreview, url: fileURL)
    }
}
```

Optional parameter on macOS:
- `blur`: adds a blur overlay in the preview panel when `true`
