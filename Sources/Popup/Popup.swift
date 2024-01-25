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
  ///     ``PopupAttachmentAnchor/Source/bounds``.
  ///   - attachmentEdge: The edge of the `attachmentAnchor` that defines
  ///     the location of the popover. The default is ``Edge/top``.
  ///   - alignment: The alignment that the modifier uses to position the
  ///     implicit popup relative to the `attachmentAnchor`. When
  ///    `alignment` is nil, the value gets derived from the `attachmentEdge`.
  ///   - edgeOffset: The distance of the poppver from the `attachmentEdge`.
  ///   - tapOutsideToDismiss: Whether the popup should be dismissed when a
  ///     tap occurs outside the view.
  ///   - content: A closure returning the content of the popup.
  public func popup<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    attachmentAnchor: PopupAttachmentAnchor = .rect(.bounds),
    attachmentEdge: Edge = .top,
    edgeOffset: CGFloat = 12,
    alignment: Alignment? = nil,
    tapOutsideToDismiss: Bool = true,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    self.modifier(
      PopupViewModifier(
        item: item,
        attachmentAnchor: attachmentAnchor,
        attachmentEdge: attachmentEdge,
        edgeOffset: edgeOffset,
        alignment: alignment,
        tapOutsideToDismiss: tapOutsideToDismiss,
        content: content
      )
    )
  }

  /// Presents a popup using the given item as a data source for the
  /// popup's content.
  ///
  /// Use this method when you need to present a popup with content
  /// from a custom data source. The example below uses data in
  /// the `PopupModel` structure to populate the view in the `content`
  /// closure that the popup displays to the user:
  ///
  ///     struct PopoverExample: View {
  ///         @State private var isShowingPopover = false
  ///
  ///         var body: some View {
  ///             Button("Show Popover") {
  ///                 self.isShowingPopover = true
  ///             }
  ///             .popover(isPresented: $isShowingPopover) {
  ///                 Text("Popover Content")
  ///                     .padding()
  ///             }
  ///         }
  ///     }
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether
  ///     to present the popover content that you return from the modifier's
  ///     `content` closure.
  ///   - attachmentAnchor: The positioning anchor that defines the
  ///     attachment point of the popup. The default is
  ///     ``PopupAttachmentAnchor/Source/bounds``.
  ///   - attachmentEdge: The edge of the `attachmentAnchor` that defines
  ///     the location of the popover. The default is ``Edge/top``.
  ///   - alignment: The alignment that the modifier uses to position the
  ///     implicit popup relative to the `attachmentAnchor`. When
  ///    `alignment` is nil, the value gets derived from the `attachmentEdge`.
  ///   - edgeOffset: The distance of the poppver from the `attachmentEdge`.
  ///   - tapOutsideToDismiss: Whether the popup should be dismissed when a
  ///     tap occurs outside the view.
  ///   - content: A closure returning the content of the popup.
  public func popup<Content: View>(
    isPresented: Binding<Bool>,
    attachmentAnchor: PopupAttachmentAnchor = .rect(.bounds),
    attachmentEdge: Edge = .top,
    edgeOffset: CGFloat = 12,
    alignment: Alignment? = nil,
    tapOutsideToDismiss: Bool = true,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.modifier(
      PopupViewModifier(
        isPresented: isPresented,
        attachmentAnchor: attachmentAnchor,
        attachmentEdge: attachmentEdge,
        edgeOffset: edgeOffset,
        alignment: alignment,
        tapOutsideToDismiss: tapOutsideToDismiss,
        content: content
      )
    )
  }
}

struct PopupViewModifier<PopupContent: View>: ViewModifier {
  let attachmentAnchor: PopupAttachmentAnchor
  let attachmentEdge: Edge
  let edgeOffset: CGFloat
  let alignment: Alignment?
  let tapOutsideToDismiss: Bool
  let onDismiss: () -> Void
  @ViewBuilder let overlayContent: () -> PopupContent?

  @State var contentSize: CGSize = .zero
  @State var overlaySize: CGSize = .zero

  init<Item: Identifiable>(
    item: Binding<Item?>,
    attachmentAnchor: PopupAttachmentAnchor,
    attachmentEdge: Edge,
    edgeOffset: CGFloat,
    alignment: Alignment?,
    tapOutsideToDismiss: Bool,
    @ViewBuilder content: @escaping (Item) -> PopupContent
  ) {
    self.attachmentAnchor = attachmentAnchor
    self.attachmentEdge = attachmentEdge
    self.edgeOffset = edgeOffset
    self.alignment = alignment
    self.tapOutsideToDismiss = tapOutsideToDismiss
    self.overlayContent = { item.wrappedValue.map { content($0) } }
    self.onDismiss = { item.wrappedValue = nil }
  }

  init(
    isPresented: Binding<Bool>,
    attachmentAnchor: PopupAttachmentAnchor,
    attachmentEdge: Edge,
    edgeOffset: CGFloat,
    alignment: Alignment?,
    tapOutsideToDismiss: Bool,
    @ViewBuilder content: @escaping () -> PopupContent
  ) {
    self.attachmentAnchor = attachmentAnchor
    self.attachmentEdge = attachmentEdge
    self.edgeOffset = edgeOffset
    self.alignment = alignment
    self.tapOutsideToDismiss = tapOutsideToDismiss
    self.overlayContent = { isPresented.wrappedValue ? content() : nil }
    self.onDismiss = { isPresented.wrappedValue = false }
  }

  func body(content: Content) -> some View {
    content.onGeometrySizeChange { self.contentSize = $0 }
      .overlay {
        Group {
          self.overlayContent().contentShape(.rect).fixedSize()
            .applying {
              if self.tapOutsideToDismiss {
                $0.onTapOutsideGesture { self.onDismiss() }
              } else {
                $0
              }
            }
            .onGeometrySizeChange { self.overlaySize = $0 }.position(self.overlayPosition)
            .offset(self.overlayOffset)
          Button("") { self.onDismiss() }.keyboardShortcut(.escape, modifiers: []).hidden()
            .accessibility(hidden: true)
        }
      }
  }

  var overlayPosition: CGPoint {
    switch self.attachmentAnchor {
    case let .rect(.rect(rect)): rect.origin + self.anchorAttachmentEdgeMultiplier * rect.size
    case .rect(.bounds): CGPoint.zero + self.anchorAttachmentEdgeMultiplier * self.contentSize
    case let .point(unitPoint): self.getPointInView(unitPoint: unitPoint)
    }
  }

  var overlayOffset: CGSize {
    self.overlaySize / 2 * self.offsetAttachmentEdgeMultiplier + self.overlayEdgeOffset
  }

  func getPointInView(unitPoint: UnitPoint) -> CGPoint { unitPoint * self.contentSize }

  var anchorAttachmentEdgeMultiplier: UnitPoint {
    switch self.attachmentEdge {
    case .top: .top
    case .bottom: .bottom
    case .leading: .leading
    case .trailing: .trailing
    }
  }

  var offsetAttachmentEdgeMultiplier: CGSize {
    if let alignment {
      switch alignment {
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
    } else {
      switch self.attachmentEdge {
      case .top: CGSize(width: 0, height: -1)
      case .bottom: CGSize(width: 0, height: 1)
      case .leading: CGSize(width: -1, height: 0)
      case .trailing: CGSize(width: 1, height: 0)
      }
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
