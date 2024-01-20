import OnTapOutsideGesture
import SwiftUI

extension View {
  /// Presents a popup using the given item as a data source for the
  /// popup's content.
  ///
  /// Use this method when you need to present a popup with content
  /// from a custom data source. The example below uses data in
  /// the `PopupModel` structure to populate the view in the `content`
  /// closure that the popup displays to the user:
  ///
  ///     struct PopupExample: View {
  ///         @State private var popup: PopupModel?
  ///
  ///         var body: some View {
  ///             Button("Show Popup") {
  ///                 popup = PopupModel(message: "Custom Message")
  ///             }
  ///             .popup(item: $popup) { detail in
  ///                 Text("\(detail.message)")
  ///                     .padding()
  ///             }
  ///         }
  ///     }
  ///
  ///     struct PopupModel: Identifiable {
  ///         var id: String { message }
  ///         let message: String
  ///     }
  ///
  /// - Parameters:
  ///   - item: A binding to an optional source of truth for the popup.
  ///     When `item` is non-`nil`, the system passes the contents to
  ///     the modifier's closure. You use this content to populate the fields
  ///     of a popup that you create that the system displays to the user.
  ///     If `item` changes, the system dismisses the currently presented
  ///     popup and replaces it with a new popup using the same process.
  ///   - attachmentAnchor: The positioning anchor that defines the
  ///     attachment point of the popup. The default is
  ///     ``Anchor/Source/bounds``.
  ///   - attachmentEdge: The edge of the `attachmentAnchor` that defines
  ///     the location of the popover. The default is ``Edge/top``.
  ///   - alignment: The alignment that the modifier uses to position the
  ///     implicit popup relative to the `attachmentAnchor`. The default
  ///     is ``Alignment/center``.
  ///   - edgeOffset: The distance of the poppver from the `attachmentEdge`.
  ///   - content: A closure returning the content of the popup.
  public func popup<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
    attachmentEdge: Edge = .top,
    edgeOffset: CGFloat = 12,
    alignment: Alignment = .top,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    self.modifier(
      PopupViewModifier(
        item: item,
        attachmentAnchor: attachmentAnchor,
        attachmentEdge: attachmentEdge,
        edgeOffset: edgeOffset,
        alignment: alignment,
        content: content
      )
    )
  }
}

struct PopupViewModifier<Item: Identifiable, PopupContent: View>: ViewModifier {
  var item: Binding<Item?>
  let attachmentAnchor: PopoverAttachmentAnchor
  let attachmentEdge: Edge
  let edgeOffset: CGFloat
  let alignment: Alignment
  @ViewBuilder let overlayContent: (Item) -> PopupContent

  @State var anchorValue: CGRect? = nil
  @State var contentFrame: CGRect = .zero
  @State var overlayFrame: CGRect = .zero

  init(
    item: Binding<Item?>,
    attachmentAnchor: PopoverAttachmentAnchor,
    attachmentEdge: Edge,
    edgeOffset: CGFloat,
    alignment: Alignment,
    @ViewBuilder content: @escaping (Item) -> PopupContent
  ) {
    self.item = item
    self.attachmentAnchor = attachmentAnchor
    self.attachmentEdge = attachmentEdge
    self.edgeOffset = edgeOffset
    self.alignment = alignment
    self.overlayContent = content
  }

  func body(content: Content) -> some View {
    content.onGeometryFrameChange { self.contentFrame = $0 }
      .overlay {
        self.item.wrappedValue.map { itemValue in
          Group {
            self.overlayContent(itemValue).contentShape(.rect).fixedSize()
              .onTapOutsideGesture { self.item.wrappedValue = nil }
              .onGeometryFrameChange { self.overlayFrame = $0 }.position(self.overlayPosition)
              .offset(self.overlayOffset)
            Button("") { self.item.wrappedValue = nil }.keyboardShortcut(.escape, modifiers: [])
              .hidden().accessibility(hidden: true).keyboardShortcut("h", modifiers: [])
          }
        }
      }
      .applying {
        if case let .rect(source) = self.attachmentAnchor {
          $0.anchorReader(anchor: source) { self.anchorValue = $0 }
        } else {
          $0
        }
      }
  }

  var overlayPosition: CGPoint {
    switch self.attachmentAnchor {
    case .rect:
      if let anchorValue {
        anchorValue.origin + anchorValue.size * self.anchorAttachmentEdgeMultiplier
          - self.overlayFrame.size
      } else {
        .zero
      }
    case let .point(unitPoint): self.getPointInView(unitPoint: unitPoint)
    @unknown default: .zero
    }
  }

  var overlayOffset: CGSize {
    self.overlayFrame.size / 2 * self.offsetAttachmentEdgeMultiplier + self.overlayEdgeOffset
  }

  func getPointInView(unitPoint: UnitPoint) -> CGPoint { unitPoint * self.contentFrame.size }

  var anchorAttachmentEdgeMultiplier: CGSize {
    switch self.attachmentEdge {
    case .top: CGSize(width: 0.5, height: 0)
    case .bottom: CGSize(width: 0.5, height: 1)
    case .leading: CGSize(width: 0, height: 0.5)
    case .trailing: CGSize(width: 1, height: 0.5)
    }
  }

  var offsetAttachmentEdgeMultiplier: CGSize {
    switch self.alignment {
    case .topLeading: CGSize(width: -1, height: -1)
    case .top: CGSize(width: 0, height: -1)
    case .topTrailing: CGSize(width: 1, height: -1)
    case .bottomLeading: CGSize(width: -1, height: 1)
    case .bottom: CGSize(width: 0, height: 1)
    case .bottomTrailing: CGSize(width: 1, height: 1)
    case .leading: CGSize(width: -1, height: 0)
    case .trailing: CGSize(width: 1, height: 0)
    case .center: CGSize.zero
    default: CGSize.zero
    }
  }

  var overlayEdgeOffset: CGSize {
    switch self.attachmentEdge {
    case .top: CGSize(width: 0, height: -self.edgeOffset)
    case .bottom: CGSize(width: 0, height: self.edgeOffset)
    case .leading: CGSize(width: -self.edgeOffset, height: 0)
    case .trailing: CGSize(width: self.edgeOffset, height: 0)
    }
  }
}
