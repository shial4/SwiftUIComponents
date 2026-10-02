import SwiftUI

public struct Minus: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let lineThickness: CGFloat = min(rect.width, rect.height) * 0.25
        let horizontalRect = CGRect(x: rect.minX, y: rect.minY + (rect.height - lineThickness) / 2, width: rect.width, height: lineThickness)
        
        path.addRect(horizontalRect)
        
        return path
    }
}
