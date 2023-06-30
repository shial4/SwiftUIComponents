import SwiftUI

/// A shape representing a chevron.
public struct Chevron: Shape {   
    /// The thickness of the chevron as a fraction of the minimum dimension of the containing rect.
    public let thickness: Double
    
    /// Creates a chevron shape with the specified thickness.
    /// - Parameter thickness: The thickness of the chevron as a fraction of the minimum dimension of the containing rect. Default value is 0.25.
    public init(thickness: Double = 0.25) {
        self.thickness = thickness
    }
    
    public func path(in rect: CGRect) -> Path {
        let offset: Double = min(rect.size.width, rect.size.height) * thickness
        
        return Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.minX - offset, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX - offset, y: rect.minY))
            
            path.closeSubpath()
        }
    }
}

struct Chevron_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Chevron().stroke(Color.white)
                Chevron().fill(Color.white)
            }.frame(width: 32, height: 64)
        }
    }
}
