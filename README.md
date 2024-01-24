# Popup
A popup in SwiftUI than can be dismissed when a click or a tap occurs outside of its view. It behaves similarly to SwiftUI's [popover](https://developer.apple.com/documentation/swiftui/view/popover(item:attachmentanchor:arrowedge:content:)) but it uses a SwiftUI View rather than an NSPopover or a UIViewController.

> Note:
> - The popup is subjected to SwiftUI's display ordering. (Later views in the view tree have higher zIndexes).
> - The dismiss click or tap is not subjected to SwiftUI's display ordering. (The click or tap could occur anywhere outside the view.)
> - The dismiss click or tap is performed simultaneously with other gestures.

## Usage
Present a popover when a given condition is true:
```swift
import SwiftUI
import Popup

struct PopoverExample: View {
    @State private var isShowingPopover = false

    var body: some View {
        Button("Show Popover") {
            self.isShowingPopover = true
        }
        .popover(isPresented: $isShowingPopover) {
            Text("Popover Content")
                .padding()
        }
    }
}
```

Present a popover using the given item as a data source for the popover’s content:
```swift
import SwiftUI
import Popup

struct PopoverExample: View {
    @State private var popover: PopoverModel?

    var body: some View {
        Button("Show Popover") {
            popover = PopoverModel(message: "Custom Message")
        }
        .popover(item: $popover) { detail in
            Text("\(detail.message)")
                .padding()
        }
    }
}

struct PopoverModel: Identifiable {
    var id: String { message }
    let message: String
}
```

## Installation
To use Popup in a SwiftPM project:

1. Add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/kuglee/Popup", branch: "main"),
```

2. Add `Popup` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
    ...
    .product(name: "Popup", package: "Popup"),
]),
```

3. Add `import Popup` in your source code.