import SwiftUI

extension View {
  @MainActor func anchorReader(
    anchor: Anchor<CGRect>.Source,
    perform action: @escaping (CGRect?) -> Void
  ) -> some View {
    self.anchorPreference(key: AnchorReaderAnchorKey.self, value: anchor) { $0 }
      .backgroundPreferenceValue(AnchorReaderAnchorKey.self) { anchor in
        Color.clear.geomertyReader {
          let rect: CGRect? = if let anchor { $0[anchor] } else { nil }

          action(rect)
        }
      }
  }
}

struct AnchorReaderAnchorKey: PreferenceKey {
  typealias Value = Anchor<CGRect>?

  static var defaultValue: Value = nil

  static func reduce(value: inout Value, nextValue: () -> Value) { value = nextValue() }
}
