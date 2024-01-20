# Popup
A popup in SwiftUI than can be dismissed when a click or a tap occurs outside of its view. It behaves similarly to SwiftUI's [popover](https://developer.apple.com/documentation/swiftui/view/popover(item:attachmentanchor:arrowedge:content:)) but it uses a SwiftUI View rather than an NSPopover or a UIViewController.

> Note:
> - The popup is subjected to SwiftUI's display ordering. (Later views in the view tree have higher zIndexes).
> - The dismiss click or tap is not subjected to SwiftUI's display ordering. (The click or tap could occur anywhere outside the view.)
> - The dismiss click or tap is performed simultaneously with other gestures.
