import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Shape geometry")
struct ShapeTests {
    @Test("Hit-region bounds retain inclusive edge tolerance")
    func hitRegionEdges() {
        let region = MuscleMapHitRegion(polygons: [[
            CGPoint(x: 0, y: 0), CGPoint(x: 10, y: 0),
            CGPoint(x: 10, y: 10), CGPoint(x: 0, y: 10)
        ]])
        for point in [CGPoint(x: -0.75, y: 5), CGPoint(x: 10.75, y: 5),
                      CGPoint(x: 5, y: -0.75), CGPoint(x: 5, y: 10.75)] {
            #expect(region.contains(point))
        }
        #expect(!region.contains(CGPoint(x: 10.751, y: 5)))
        #expect(region.distance(to: CGPoint(x: 13, y: 5)) == 3)
    }

    @MainActor @Test("Cached muscle drawing and hit geometry match the original vectors")
    func cachedMuscles() {
        let shapes: [any MuscleMapShape] = [
            MuscleMap.Front.Abdominals(translationX: 5),
            MuscleMap.Front.Biceps(translationX: 5),
            MuscleMap.Front.Calves(translationX: 5),
            MuscleMap.Front.Contour(translationX: 5),
            MuscleMap.Front.Deltoid(translationX: 5),
            MuscleMap.Front.ExternalOblique(translationX: 5),
            MuscleMap.Front.Forearms(translationX: 5),
            MuscleMap.Front.Hands(translationX: 5),
            MuscleMap.Front.Head(translationX: 5),
            MuscleMap.Front.Hips(translationX: 5),
            MuscleMap.Front.Neck(translationX: 5),
            MuscleMap.Front.PectoralisMajor(translationX: 5),
            MuscleMap.Front.Quadriceps(translationX: 5),
            MuscleMap.Front.TibiaAndFoot(translationX: 5),
            MuscleMap.Front.TibialisAnterior(translationX: 5),
            MuscleMap.Front.Trapezius(translationX: 5),
            MuscleMap.Back.Calves(translationX: 5),
            MuscleMap.Back.Contour(translationX: 5),
            MuscleMap.Back.Deltoid(translationX: 5),
            MuscleMap.Back.Foot(translationX: 5),
            MuscleMap.Back.Forearms(translationX: 5),
            MuscleMap.Back.Gluteus(translationX: 5),
            MuscleMap.Back.Hamstrings(translationX: 5),
            MuscleMap.Back.Hands(translationX: 5),
            MuscleMap.Back.Head(translationX: 5),
            MuscleMap.Back.Infraspinatus(translationX: 5),
            MuscleMap.Back.LatissimusDorsi(translationX: 5),
            MuscleMap.Back.LowerBack(translationX: 5),
            MuscleMap.Back.TeresMajor(translationX: 5),
            MuscleMap.Back.Thighs(translationX: 5),
            MuscleMap.Back.Trapezius(translationX: 5),
            MuscleMap.Back.Triceps(translationX: 5)
        ]
        let rect = CGRect(x: 30, y: 50, width: 320, height: 210)
        for shape in shapes {
            let original = UncachedMuscleShape(shape: shape)
            let actual = shape.path(in: rect).boundingRect
            let expected = original.path(in: rect).boundingRect
            #expect(abs(actual.minX - expected.minX) < 0.001)
            #expect(abs(actual.minY - expected.minY) < 0.001)
            #expect(abs(actual.width - expected.width) < 0.001)
            #expect(abs(actual.height - expected.height) < 0.001)
            let polygons = shape.hitRegion(in: rect).polygons
            let reference = original.hitRegion(in: rect).polygons
            #expect(polygons.count == reference.count)
            for (points, expectedPoints) in zip(polygons, reference) {
                #expect(points.count == expectedPoints.count)
                #expect(zip(points, expectedPoints).allSatisfy { hypot($0.x - $1.x, $0.y - $1.y) < 0.000001 })
            }
            for x in stride(from: 30.3, to: 400, by: 35) {
                for y in stride(from: 50.7, to: 270, by: 35) {
                    let point = CGPoint(x: x, y: y)
                    #expect(shape.contains(point: point, in: rect) == original.contains(point: point, in: rect))
                }
            }
        }
    }

    @MainActor @Test("Filled checkbox uses an even-odd cutout without masking")
    func checkboxCutout() {
        let rect = CGRect(x: 10, y: 20, width: 40, height: 40)
        let path = FilledCheckbox().path(in: rect)
        #expect(path.contains(CGPoint(x: 15, y: 35), eoFill: true))
        #expect(!path.contains(CGPoint(x: 30, y: 45), eoFill: true))
    }

    @MainActor @Test("General shapes honor nonzero rectangle origins")
    func origins() {
        let rect = CGRect(x: 30, y: 50, width: 100, height: 100)
        let origin = CGRect(origin: .zero, size: rect.size)
        let shapes: [any Shape] = [Arrow(), Chevron(), Star(), Tick(), Triangle(), XMark(), Plus(), Minus(), RoundedCorner(radius: 10)]
        for shape in shapes {
            let moved = shape.path(in: rect).boundingRect
            let expected = shape.path(in: origin).boundingRect.offsetBy(dx: rect.minX, dy: rect.minY)
            #expect(abs(moved.minX - expected.minX) < 0.001)
            #expect(abs(moved.minY - expected.minY) < 0.001)
            #expect(abs(moved.width - expected.width) < 0.001)
            #expect(abs(moved.height - expected.height) < 0.001)
        }
    }

    @MainActor @Test("Invalid star counts produce empty paths", arguments: [-5, 0, 1, Int.max])
    func invalidStars(points: Int) {
        #expect(Star(points: points).path(in: CGRect(x: 0, y: 0, width: 50, height: 50)).isEmpty)
    }

    @MainActor @Test("Selected corners round without affecting other corners")
    func corners() {
        let rect = CGRect(x: 20, y: 30, width: 100, height: 100)
        let path = RoundedCorner(radius: 30, corners: [.topLeft]).path(in: rect)
        #expect(!path.contains(CGPoint(x: 21, y: 31)))
        #expect(path.contains(CGPoint(x: 119, y: 31)))
        #expect(path.contains(CGPoint(x: 21, y: 129)))
        #expect(RoundedCorner(radius: -2).path(in: rect).boundingRect == rect)
    }

    @MainActor @Test("Muscle drawing and hit regions use the same coordinate transform")
    func muscleOrigins() {
        let shape = MuscleMap.Front.Biceps(translationX: 5)
        let origin = CGRect(x: 0, y: 0, width: 300, height: 300)
        let moved = origin.offsetBy(dx: 40, dy: 70)
        let actual = shape.path(in: moved).boundingRect
        let expected = shape.path(in: origin).boundingRect.offsetBy(dx: 40, dy: 70)
        #expect(abs(actual.minX - expected.minX) < 0.001)
        #expect(abs(actual.minY - expected.minY) < 0.001)
        #expect(abs(actual.width - expected.width) < 0.001)
        #expect(abs(actual.height - expected.height) < 0.001)
        let region = shape.hitRegion(in: origin)
        let point = region.polygons[0][0]
        #expect(shape.contains(point: point, in: origin))
        #expect(shape.contains(point: CGPoint(x: point.x + 40, y: point.y + 70), in: moved))
    }
}

// A client-defined shape forwards the original size-dependent vector contract.
private struct UncachedMuscleShape: MuscleMapShape {
    let shape: any MuscleMapShape
    nonisolated var translationX: Double { shape.translationX }
    nonisolated func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
        shape.paths(width: width, height: height)
    }
}
