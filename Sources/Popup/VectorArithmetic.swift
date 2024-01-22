import SwiftUI

extension CGPoint {
  static func + (_ lhs: Self, _ rhs: CGSize) -> Self {
    Self(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
  }

  static func - (_ lhs: Self, _ rhs: CGSize) -> Self {
    Self(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
  }
}

extension UnitPoint {
  static func * (_ lhs: Self, _ rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
  }

  static func * (_ lhs: Self, _ rhs: CGSize) -> CGSize {
    CGSize(width: lhs.x * rhs.width, height: lhs.y * rhs.height)
  }
}

extension CGSize {
  static func + (_ lhs: Self, _ rhs: Self) -> Self {
    Self(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
  }

  static func - (_ lhs: Self, _ rhs: Self) -> Self {
    Self(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
  }

  static func * (_ lhs: Self, _ rhs: Self) -> Self {
    Self(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
  }

  static func / (_ lhs: Self, _ rhs: Self) -> Self {
    Self(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
  }

  static func * (_ lhs: Self, _ rhs: CGFloat) -> Self {
    Self(width: lhs.width * rhs, height: lhs.height * rhs)
  }

  static func / (_ lhs: Self, _ rhs: CGFloat) -> Self {
    Self(width: lhs.width / rhs, height: lhs.height / rhs)
  }
}
