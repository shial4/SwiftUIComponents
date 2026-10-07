import SwiftUI

nonisolated public struct MuscleMapVectorPath: Sendable {
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

    fileprivate enum Element: Sendable {
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

    fileprivate func append(to path: inout Path, transform: (CGPoint) -> CGPoint) {
        for element in elements {
            switch element {
            case .move(let point):
                path.move(to: transform(point))
            case .line(let point):
                path.addLine(to: transform(point))
            case .curve(let point, let control1, let control2):
                path.addCurve(to: transform(point), control1: transform(control1), control2: transform(control2))
            case .close:
                path.closeSubpath()
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

nonisolated struct MuscleMapHitRegion {
    private static let edgeTolerance = 0.75
    let polygons: [[CGPoint]]
    private let bounds: [CGRect]

    init(polygons: [[CGPoint]], bounds: [CGRect]? = nil) {
        self.polygons = polygons
        self.bounds = bounds ?? polygons.map(Self.bounds)
    }

    static func bounds(of polygon: [CGPoint]) -> CGRect {
        guard let first = polygon.first else { return .null }
        var minX = first.x, maxX = first.x, minY = first.y, maxY = first.y
        for point in polygon.dropFirst() {
            minX = min(minX, point.x)
            maxX = max(maxX, point.x)
            minY = min(minY, point.y)
            maxY = max(maxY, point.y)
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    func contains(_ point: CGPoint) -> Bool {
        zip(polygons, bounds).contains { polygon, bounds in
            point.x >= bounds.minX - Self.edgeTolerance && point.x <= bounds.maxX + Self.edgeTolerance
                && point.y >= bounds.minY - Self.edgeTolerance && point.y <= bounds.maxY + Self.edgeTolerance
                && polygonContains(point, polygon: polygon)
        }
    }

    /// Only polygons that can fall within `maximum` need an edge walk.
    func distance(to point: CGPoint, maximum: Double = .greatestFiniteMagnitude) -> Double {
        zip(polygons, bounds).reduce(Double.greatestFiniteMagnitude) { closest, item in
            let (polygon, bounds) = item
            let dx = max(bounds.minX - point.x, point.x - bounds.maxX, 0)
            let dy = max(bounds.minY - point.y, point.y - bounds.maxY, 0)
            guard hypot(dx, dy) <= min(closest, maximum) else { return closest }
            return min(closest, polygonDistance(point, polygon: polygon))
        }
    }

    private func polygonContains(_ point: CGPoint, polygon: [CGPoint]) -> Bool {
        guard polygon.count >= 3 else { return false }

        var inside = false
        var previous = polygon[polygon.count - 1]
        for current in polygon {
            if segmentDistanceSquared(point, from: previous, to: current) <= Self.edgeTolerance * Self.edgeTolerance {
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
            closest = min(closest, segmentDistanceSquared(point, from: previous, to: current))
            previous = current
        }
        return closest.squareRoot()
    }

    private func segmentDistanceSquared(_ point: CGPoint, from start: CGPoint, to end: CGPoint) -> Double {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let lengthSquared = dx * dx + dy * dy
        guard lengthSquared > 0 else {
            let pointDX = point.x - start.x
            let pointDY = point.y - start.y
            return pointDX * pointDX + pointDY * pointDY
        }

        let projection = max(0.0, min(1.0, ((point.x - start.x) * dx + (point.y - start.y) * dy) / lengthSquared))
        let projectedX = start.x + projection * dx
        let projectedY = start.y + projection * dy
        let pointDX = point.x - projectedX
        let pointDY = point.y - projectedY
        return pointDX * pointDX + pointDY * pointDY
    }
}

/// Built-in vectors are immutable. Flatten their curves once, then scale the
/// points for drawing and hit testing. Custom MuscleMapShape implementations
/// keep their existing size-dependent paths contract.
nonisolated struct MuscleMapGeometry: Sendable {
    let vectors: [MuscleMapVectorPath]
    let polygons: [[CGPoint]]
    let bounds: [CGRect]

    init(_ vectors: [MuscleMapVectorPath]) {
        self.vectors = vectors
        self.polygons = vectors.map { $0.flattenedPoints { $0 } }
        self.bounds = polygons.map(MuscleMapHitRegion.bounds)
    }
}

protocol CachedMuscleMapShape: MuscleMapShape {
    nonisolated static var geometry: MuscleMapGeometry { get }
}

public protocol MuscleMapShape: Shape {
    nonisolated var translationX: Double { get }
    nonisolated func paths(width: Double, height: Double) -> [MuscleMapVectorPath]
}

extension MuscleMapShape {
    nonisolated public func path(in rect: CGRect) -> Path {
        guard rect.width.isFinite, rect.height.isFinite, rect.width > 0, rect.height > 0 else { return Path() }

        let translation = (translationX.isFinite && abs(translationX) >= 0.01) ? rect.width / translationX : 0
        let cached = (self as? any CachedMuscleMapShape).map { type(of: $0).geometry }
        let width = cached == nil ? 1 : rect.width / 10
        let height = cached == nil ? 1 : rect.height / 10
        let vectors = cached?.vectors ?? paths(width: rect.width / 10, height: rect.height / 10)
        return Path { path in
            for vector in vectors {
                vector.append(to: &path) { point in
                    CGPoint(x: rect.minX + point.x * width + translation, y: rect.maxY - point.y * height)
                }
            }
        }
    }
    
    nonisolated public func contains(point: CGPoint, in rect: CGRect) -> Bool {
        hitRegion(in: rect).contains(point)
    }

    nonisolated func hitRegion(in rect: CGRect) -> MuscleMapHitRegion {
        guard rect.width.isFinite, rect.height.isFinite, rect.width > 0, rect.height > 0 else {
            return MuscleMapHitRegion(polygons: [])
        }
        let translation = (translationX.isFinite && abs(translationX) >= 0.01) ? rect.size.width / translationX : 0.0
        if let cached = self as? any CachedMuscleMapShape {
            let geometry = type(of: cached).geometry
            let width = rect.width / 10, height = rect.height / 10
            let polygons = geometry.polygons.map { polygon in
                polygon.map { point in
                    CGPoint(x: rect.minX + point.x * width + translation, y: rect.maxY - point.y * height)
                }
            }
            let bounds = geometry.bounds.map { bounds in
                CGRect(x: rect.minX + bounds.minX * width + translation,
                       y: rect.maxY - bounds.maxY * height,
                       width: bounds.width * width, height: bounds.height * height)
            }
            return MuscleMapHitRegion(polygons: polygons, bounds: bounds)
        }
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
            for vector in paths(width: width, height: height) {
                vector.append(to: &path) { $0 }
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
                if style.lineWidth > 0 {
                    self.stroke(style.strokeColor, lineWidth: style.lineWidth)
                }
            }
        }
    }
}
