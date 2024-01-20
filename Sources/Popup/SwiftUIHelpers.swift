import SwiftUI

extension View {
  func applying<V: View>(@ViewBuilder _ builder: @escaping (Self) -> V) -> some View {
    builder(self)
  }
}
