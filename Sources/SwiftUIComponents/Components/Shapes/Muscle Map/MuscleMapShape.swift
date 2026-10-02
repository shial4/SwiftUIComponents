import SwiftUI

public struct MuscleMapVectorPath {
    public struct Builder {
        fileprivate var elements: [Element] = []

        public mutating func move(to point: CGPoint) {
            elements.append(.move(point))
        }

        public mutating func addLine(to point: CGPoint) {
            elements.append(.line(point))
        }

        public mutating func addCurve(to point: CGPoint, control1: CGPoint, control2: CGPoint) {
            elements.append(.curve(point, control1, control2))
        }

        public mutating func closeSubpath() {
            elements.append(.close)
        }
    }

    fileprivate enum Element {
        case move(CGPoint)
        case line(CGPoint)
        case curve(CGPoint, CGPoint, CGPoint)
        case close
    }

    fileprivate let elements: [Element]

    public init(_ build: (inout Builder) -> Void) {
        var builder = Builder()
        build(&builder)
        elements = builder.elements
    }

    fileprivate var swiftUIPath: Path {
        Path { path in
            for element in elements {
                switch element {
                case .move(let point):
                    path.move(to: point)
                case .line(let point):
                    path.addLine(to: point)
                case .curve(let point, let control1, let control2):
                    path.addCurve(to: point, control1: control1, control2: control2)
                case .close:
                    path.closeSubpath()
                }
            }
        }
    }

    fileprivate func flattenedPoints(transform: (CGPoint) -> CGPoint) -> [CGPoint] {
        var points: [CGPoint] = []
        var current = CGPoint.zero
        var start = CGPoint.zero

        for element in elements {
            switch element {
            case .move(let point):
                current = point
                start = point
                points.append(transform(point))
            case .line(let point):
                current = point
                points.append(transform(point))
            case .curve(let point, let control1, let control2):
                let origin = current
                for step in 1...24 {
                    let t = Double(step) / 24.0
                    let inverse = 1.0 - t
                    let sample = CGPoint(
                        x: inverse * inverse * inverse * origin.x
                            + 3.0 * inverse * inverse * t * control1.x
                            + 3.0 * inverse * t * t * control2.x
                            + t * t * t * point.x,
                        y: inverse * inverse * inverse * origin.y
                            + 3.0 * inverse * inverse * t * control1.y
                            + 3.0 * inverse * t * t * control2.y
                            + t * t * t * point.y
                    )
                    points.append(transform(sample))
                }
                current = point
            case .close:
                if points.last != transform(start) {
                    points.append(transform(start))
                }
                current = start
            }
        }

        return points
    }
}

struct MuscleMapHitRegion {
    let polygons: [[CGPoint]]

    func contains(_ point: CGPoint) -> Bool {
        polygons.contains { polygonContains(point, polygon: $0) }
    }

    func distance(to point: CGPoint) -> Double {
        polygons.reduce(Double.greatestFiniteMagnitude) { closest, polygon in
            min(closest, polygonDistance(point, polygon: polygon))
        }
    }

    private func polygonContains(_ point: CGPoint, polygon: [CGPoint]) -> Bool {
        guard polygon.count >= 3 else { return false }

        var inside = false
        var previous = polygon[polygon.count - 1]
        for current in polygon {
            if segmentDistance(point, from: previous, to: current) <= 0.75 {
                return true
            }

            let crossesVerticalRange = (current.y > point.y) != (previous.y > point.y)
            if crossesVerticalRange {
                let intersectionX = (previous.x - current.x) * (point.y - current.y)
                    / (previous.y - current.y) + current.x
                if point.x < intersectionX {
                    inside.toggle()
                }
            }
            previous = current
        }
        return inside
    }

    private func polygonDistance(_ point: CGPoint, polygon: [CGPoint]) -> Double {
        guard !polygon.isEmpty else { return Double.greatestFiniteMagnitude }

        var closest = Double.greatestFiniteMagnitude
        var previous = polygon[polygon.count - 1]
        for current in polygon {
            closest = min(closest, segmentDistance(point, from: previous, to: current))
            previous = current
        }
        return closest
    }

    private func segmentDistance(_ point: CGPoint, from start: CGPoint, to end: CGPoint) -> Double {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let lengthSquared = dx * dx + dy * dy
        guard lengthSquared > 0 else {
            let pointDX = point.x - start.x
            let pointDY = point.y - start.y
            return (pointDX * pointDX + pointDY * pointDY).squareRoot()
        }

        let projection = max(0.0, min(1.0, ((point.x - start.x) * dx + (point.y - start.y) * dy) / lengthSquared))
        let projectedX = start.x + projection * dx
        let projectedY = start.y + projection * dy
        let pointDX = point.x - projectedX
        let pointDY = point.y - projectedY
        return (pointDX * pointDX + pointDY * pointDY).squareRoot()
    }
}

public protocol MuscleMapShape: Shape {
    nonisolated var translationX: Double { get }
    nonisolated func paths(width: Double, height: Double) -> [MuscleMapVectorPath]
}

extension MuscleMapShape {
    nonisolated public func path(in rect: CGRect) -> Path {
        guard rect.width.isFinite, rect.height.isFinite, rect.width > 0, rect.height > 0 else { return Path() }

        let translationXComparison = (translationX.isFinite && abs(translationX) >= 0.01)
        return path(
            width: rect.size.width / 10.0,
            height: rect.size.height / 10.0
        )
        .applying(CGAffineTransform(scaleX: 1.0, y: -1.0))
        .applying(CGAffineTransform(
            translationX: rect.minX + (translationXComparison ? rect.size.width / translationX : 0.0),
            y: rect.maxY
        ))
    }
    
    nonisolated public func contains(point: CGPoint, in rect: CGRect) -> Bool {
        hitRegion(in: rect).contains(point)
    }

    nonisolated func hitRegion(in rect: CGRect) -> MuscleMapHitRegion {
        let translation = (translationX.isFinite && abs(translationX) >= 0.01) ? rect.size.width / translationX : 0.0
        let vectors = paths(
            width: rect.size.width / 10.0,
            height: rect.size.height / 10.0
        )
        return MuscleMapHitRegion(polygons: vectors.map { vector in
            vector.flattenedPoints { point in
                CGPoint(x: rect.minX + point.x + translation, y: rect.maxY - point.y)
            }
        })
    }
    
    nonisolated public func path(width: Double, height: Double) -> Path {
        Path { path in
            paths(width: width, height: height).forEach {
                path.addPath($0.swiftUIPath)
            }
        }
    }
}

public extension MuscleMapShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: Double = 1
    ) -> some View {
        ZStack {
            self.fill(fillStyle)
            self.stroke(strokeStyle, lineWidth: lineWidth)
        }
    }

    @ViewBuilder
    func fill(_ style: MuscleMap.Style?) -> some View {
        if let style {
            ZStack {
                if style.gradientColors.count > 1 {
                    switch style.gradientKind {
                    case .linear:
                        self.fill(LinearGradient(colors: style.gradientColors,
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                    case .radial:
                        self.fill(RadialGradient(colors: style.gradientColors, center: .center,
                                                 startRadius: 0, endRadius: style.gradientRadius))
                    }
                } else {
                    self.fill(style.fillColor)
                }
                self.stroke(style.strokeColor, lineWidth: style.lineWidth)
            }
        }
    }
}
