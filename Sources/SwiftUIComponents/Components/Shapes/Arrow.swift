import SwiftUI

/// A shape representing an arrow.
public struct Arrow: Shape {
    public init() {}
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: rect.height * 0.3))
            path.addLine(to: CGPoint(x: 0, y: rect.height * 0.7))
            path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.6))
            path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.8))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
            path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.2 ))
            path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.4 ))
            path.closeSubpath()
        }
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Arrow().stroke(Color.white)
                Arrow().fill(Color.white)
            }
            HStack {
                Arrow()
                    .stroke(Color.white)
                    .rotationEffect(Angle(degrees: 180), anchor: .center)
                Arrow()
                    .fill(Color.white)
                    .rotationEffect(Angle(degrees: 180), anchor: .center)
            }
        }
    }
}

