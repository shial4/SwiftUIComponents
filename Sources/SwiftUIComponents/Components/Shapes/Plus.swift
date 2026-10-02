import SwiftUI

public struct Plus: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let lineThickness: CGFloat = min(rect.width, rect.height) * 0.25
        let horizontalRect = CGRect(x: rect.minX, y: rect.minY + (rect.height - lineThickness) / 2, width: rect.width, height: lineThickness)
        let verticalRect = CGRect(x: rect.minX + (rect.width - lineThickness) / 2, y: rect.minY, width: lineThickness, height: rect.height)
        
        path.addRect(horizontalRect)
        path.addRect(verticalRect)
        
        return path
    }
}
