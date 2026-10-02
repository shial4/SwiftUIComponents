import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Shape geometry")
struct ShapeTests {
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
