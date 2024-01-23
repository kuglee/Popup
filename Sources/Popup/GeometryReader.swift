import SwiftUI

extension View {
  func onGeometrySizeChange(perform action: @escaping (CGSize) -> Void) -> some View {
    self.background(
      GeometryReader {
        let size = $0.frame(in: .global).size

        Color.clear.task(id: size) { @MainActor [size] in action(size) }
      }
    )
  }
}
