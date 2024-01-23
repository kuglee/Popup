import SwiftUI

/// An attachment anchor for a popup.
public enum PopupAttachmentAnchor {
  /// The anchor point for the popup relative to the source's frame.
  case rect(Source)

  /// The anchor point for the popup expressed as a unit point  that
  /// describes possible alignments relative to a SwiftUI view.
  case point(UnitPoint)

  public enum Source {
    /// Returns a source rect defined by `r` in the current view.
    case rect(_ r: CGRect)

    /// A source rect defined as the entire bounding rect of the current
    /// view.
    case bounds
  }
}
