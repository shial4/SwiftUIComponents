import SwiftUI

public enum RectCorner : Sendable {
    case topLeft, topRight, bottomLeft, bottomRight, allCorners
}

public extension View {
    func cornerRadius(_ radius: Double, corners: RectCorner...) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: Set(corners)))
    }
}

// Credits: https://stackoverflow.com/a/56763282
public struct RoundedCorner: Shape {
    public var radius: Double = .infinity
    public var corners: Set<RectCorner> = [.allCorners]
    
    public init(radius: Double, corners: Set<RectCorner>) {
        self.radius = radius
        self.corners = corners
    }
    
    private var tl: Double {
        corners.intersection([RectCorner.topLeft, RectCorner.allCorners]).isEmpty
        ? 0 : radius
    }
    private var tr: Double {
        corners.intersection([RectCorner.topRight, RectCorner.allCorners]).isEmpty
        ? 0 : radius
    }
    private var bl: Double {
        corners.intersection([RectCorner.bottomLeft, RectCorner.allCorners]).isEmpty
        ? 0 : radius
    }
    private var br: Double {
        corners.intersection([RectCorner.bottomRight, RectCorner.allCorners]).isEmpty
        ? 0 : radius
    }
        
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: tl, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()
        
        return path
    }
}
