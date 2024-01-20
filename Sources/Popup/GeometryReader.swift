import SwiftUI

extension View {
  @MainActor func geomertyReader(perform action: @escaping (GeometryProxy) -> Void)
    -> some View
  { GeometryReader { geometry in Color.clear.onAppear { action(geometry) } } }

  // from https://stackoverflow.com/a/66822461/14351818
  @MainActor func onGeometryFrameChange(
    in coordinateSpace: CoordinateSpace = .global,
    perform action: @escaping (CGRect) -> Void
  ) -> some View {
    self.background(
      GeometryReader {
        let frame = $0.frame(in: coordinateSpace)

        Color.clear.preference(key: ContentFrameReaderPreferenceKey.self, value: frame)
          .onPreferenceChange(ContentFrameReaderPreferenceKey.self) { action($0) }
      }
    )
  }
}

struct ContentFrameReaderPreferenceKey: PreferenceKey {
  typealias Value = CGRect

  static var defaultValue: Value = Value()

  static func reduce(value: inout Value, nextValue: () -> Value) { value = nextValue() }
}
