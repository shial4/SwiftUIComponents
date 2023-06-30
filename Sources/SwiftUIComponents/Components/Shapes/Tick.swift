import SwiftUI

/**
 A custom shape that represents a tick mark.
 
 The `Tick` shape is used to draw a tick mark with a specified thickness.
 
 ## Overview
 The `Tick` shape draws a tick mark with two lines forming an angled shape. It is commonly used to indicate selection or completion status.
 
 ### Example Usage:
 ```swift
 Tick(thickness: 0.125)
     .stroke(Color.black, lineWidth: 2)
 ```
 
 ### Remark:
 The `Tick` shape is created by providing the thickness property.
 
 - Note: The `Tick` shape draws a tick mark with the specified thickness. The shape is defined using two lines that form an angled shape.
 
 */
public struct Tick: Shape {       
    public let thickness: Double
    
    /**
     Initializes a `Tick` shape with the specified thickness.
     
     - Parameter thickness: The thickness of the tick mark.
     
     - Returns: A `Tick` shape with the specified thickness.
     */
    public init(thickness: Double = 0.125) {
        self.thickness = thickness
    }
    
    public func path(in rect: CGRect) -> Path {
        let offset: Double = min(rect.size.width, rect.size.height) * thickness
        return Path { path in 
            path.move(to: CGPoint(x: rect.minX, 
                                  y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.midX / 1.5, 
                                     y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.midX / 1.5, 
                                     y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.maxX, 
                                     y: rect.minY))
            // Reverse path
            path.addLine(to: CGPoint(x: rect.maxX - offset, 
                                     y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.midX / 1.5, 
                                     y: rect.maxY - offset))
            
            path.addLine(to: CGPoint(x: rect.minX + offset, 
                                     y: rect.midY))
            path.closeSubpath()
        }
    }
}

struct Tick_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Tick().stroke(Color.white)
            Tick().fill(Color.white)
            Tick().stroke(Color.white, 
                          style: StrokeStyle(lineWidth: 2, 
                                             lineCap: .round, 
                                             lineJoin: .round))
            Tick().stroke(Color.white)
                .frame(width: 66, height: 66)
            Tick().fill(Color.white)
                .frame(width: 66, height: 66)
            
        }
    }
}
