import SwiftUI

public struct JoystickView: View {
    @Binding public var translation: CGPoint
    @State private var dragPosition: CGPoint? = nil

    private var gripColor: Color = .white
    private var accetColor: Color = .black
    
    public init(translation: Binding<CGPoint>) {
        self._translation = translation
    }

    public var body: some View {
        GeometryReader { proxy in
            Circle()
                .strokeBorder(accetColor.opacity(0.4))
                .background(Circle().fill(accetColor.opacity(0.2)))
                .overlay(
                    Circle()
                        .strokeBorder(accetColor)
                        .background(Circle().fill(gripColor))
                        .scaleEffect(0.5)
                        .position(dragPosition ?? CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY))
                ).gesture(
                    DragGesture(coordinateSpace: .local)
                        .onChanged { value in
                            let center = CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                            let location = CGPoint(x: center.x + value.translation.width, y: center.y + value.translation.height)
                            let radius = min(proxy.size.width, proxy.size.height) / 4
                            if let intersection = lineCircleIntersection(line: LWLine(start: center, end: location),
                                                                         circle: LWCircle(center: center, radius: radius)).first {
                                dragPosition = intersection
                            } else {
                                dragPosition = location
                            }
                            let translation = CGPoint(
                                x: location.x - center.x,
                                y: location.y - center.y
                            )
                            self.translation = translation
                        }
                        .onEnded { value in
                            dragPosition = nil
                            translation = .zero
                        }
                )
        }
    }
    
    typealias LWLine = (start: CGPoint, end: CGPoint)
    typealias LWCircle = (center: CGPoint, radius: CGFloat)
    func lineCircleIntersection(line: LWLine, circle: LWCircle, isSegment: Bool = true) -> [CGPoint] {
        var result: [CGPoint] = []
        let angle = atan2(line.end.y - line.start.y, line.end.x - line.start.x)
        var at = CGAffineTransform(rotationAngle: angle)
            .inverted()
            .translatedBy(x: -circle.center.x, y: -circle.center.y)
        let p1 = line.start.applying(at)
        let p2 = line.end.applying(at)
        let minX = min(p1.x, p2.x), maxX = max(p1.x, p2.x)
        let y = p1.y
        at = at.inverted()
        
        func addPoint(x: CGFloat, y: CGFloat) {
            if !isSegment || (x <= maxX && x >= minX) {
                result.append(CGPoint(x: x, y: y).applying(at))
            }
        }
        
        if y == circle.radius || y == -circle.radius {
            addPoint(x: 0, y: y)
        } else if y < circle.radius && y > -circle.radius {
            let x = (circle.radius * circle.radius - y * y).squareRoot()
            addPoint(x: -x, y: y)
            addPoint(x: x, y: y)
        }
        return result
    }
}

// MARK: - View Modifiers
public extension JoystickView {
    func gripColor(_ color: Color) -> Self {
        var view = self
        view.gripColor = color
        return view
    }
    
    func accetColor(_ color: Color) -> Self {
        var view = self
        view.accetColor = color
        return view
    }
}

// MARK: - Previews
struct JoystickView_Previews: PreviewProvider {
    static var previews: some View {
        JoystickView(translation: .constant(.zero))
            .frame(width: 180, height: 180)
    }
}
