import SwiftUI

public enum RectCorner: Sendable {
    case topLeft, topRight, bottomLeft, bottomRight, allCorners
}

public extension View {
    func cornerRadius(_ radius: Double, corners: RectCorner...) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: Set(corners)))
    }
}

/// Selectively rounded corners, implemented using SwiftUI's native shape.
public struct RoundedCorner: Shape {
    public var radius: Double
    public var corners: Set<RectCorner>
    public var animatableData: Double {
        get { radius }
        set { radius = newValue }
    }

    public init(radius: Double = .infinity, corners: Set<RectCorner> = [.allCorners]) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let radius = radius.isNaN ? 0 : max(0, min(radius, min(rect.width, rect.height) / 2))
        func value(_ corner: RectCorner) -> Double {
            corners.contains(.allCorners) || corners.contains(corner) ? radius : 0
        }
        return UnevenRoundedRectangle(
            topLeadingRadius: value(.topLeft), bottomLeadingRadius: value(.bottomLeft),
            bottomTrailingRadius: value(.bottomRight), topTrailingRadius: value(.topRight),
            style: .circular
        ).path(in: rect)
    }
}
