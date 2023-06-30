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
        // centre of the containing rect
        var center = CGPoint(x: rect.width/2.0, y: rect.height/2.0)
        // Adjust center down for odd number of sides less than 8
        if points%2 == 1 && points < 8 {
            center = CGPoint(x: center.x, y: center.y * ((Double(points) * (-0.04)) + 1.3))
        }
        
        // radius of a circle that will fit in the rect
        let outerRadius = Double(min(rect.width,rect.height)) / 2.0
        let innerRadius = outerRadius * 0.4
        let offsetAngle = (Double.pi / Double(points)) + Double.pi / 2.0
        
        var vertices: [CGPoint] = []
        for i in 0 ..< points {
            // Calculate the angle in Radians
            let angle1 = (2.0 * Double.pi/Double(points)) * Double(i)  + offsetAngle
            let outerPoint = toPoint(length: outerRadius, angle: angle1)
            vertices.append(CGPoint(x: outerPoint.x + center.x, y: outerPoint.y + center.y))
            
            let angle2 = (2.0 * Double.pi/Double(points)) * (Double(i) + 0.5)  + offsetAngle
            let innerPoint = toPoint(length: (innerRadius),
                                       angle: (angle2))
            vertices.append(CGPoint(x: innerPoint.x + center.x, y: innerPoint.y + center.y))
        }
        
        let path = Path() { path in
            for (n, pt) in vertices.enumerated() {
                n == 0 ? path.move(to: pt) : path.addLine(to: pt)
            }
            path.closeSubpath()
        }
        return path
    }
    
    private func toPoint(length: Double, angle: Double) -> CGPoint {
        return CGPoint(x: length * cos(angle), y: length * sin(angle))
    }
}

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

