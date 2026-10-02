import SwiftUI

/// A shape representing a star.
public struct Star: Shape {
    /// The number of points of the star.
    public var points: Int

    public var animatableData: Int {
        get { return points }
        set { points = newValue }
    }

    /// Creates a star shape with the specified number of points.
    /// - Parameter points: The number of points of the star. Default value is 5.
    public init(points: Int = 5) {
        self.points = points
    }

    public func path(in rect: CGRect) -> Path {
        guard points >= 2, points <= 1024 else { return Path() }
        // centre of the containing rect
        var center = CGPoint(x: rect.midX, y: rect.midY)
        // Adjust center down for odd number of sides less than 8
        if points%2 == 1 && points < 8 {
            center = CGPoint(x: center.x, y: rect.minY + rect.height / 2 * ((Double(points) * (-0.04)) + 1.3))
        }

        // radius of a circle that will fit in the rect
        let outerRadius = Double(min(rect.width,rect.height)) / 2.0
        let innerRadius = outerRadius * 0.4
        let offsetAngle = (Double.pi / Double(points)) + Double.pi / 2.0

        let path = Path { path in
            for index in 0..<(points * 2) {
                let angle = Double.pi / Double(points) * Double(index) + offsetAngle
                let radius = index.isMultiple(of: 2) ? outerRadius : innerRadius
                let point = Self.toPoint(length: radius, angle: angle)
                let vertex = CGPoint(x: point.x + center.x, y: point.y + center.y)
                if index == 0 { path.move(to: vertex) } else { path.addLine(to: vertex) }
            }
            path.closeSubpath()
        }
        return path
    }

    nonisolated private static func toPoint(length: Double, angle: Double) -> CGPoint {
        return CGPoint(x: length * cos(angle), y: length * sin(angle))
    }
}

#if !os(Android)
struct Star_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Star().stroke(Color.white)
                Star().fill(Color.white)
            }
            HStack {
                Star(points: 7).stroke(Color.white)
                Star(points: 7).fill(Color.white)
            }
        }
    }
}
#endif
