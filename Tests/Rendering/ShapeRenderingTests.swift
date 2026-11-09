import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

extension ShapeTests {
    @MainActor @Test("Triangle outlines join the closing corner instead of leaving two butt caps")
    func triangleStrokeJoin() {
        let path = Triangle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(path.contains(CGPoint(x: 50, y: 50)))
        #expect(path.strokedPath(StrokeStyle(lineWidth: 20, lineJoin: .miter))
            .contains(CGPoint(x: -5, y: 105)))
    }

    @Test("Continuous shape dimensions interpolate through the Shape contract")
    func continuousShapeAnimation() {
        func midpoint<S: Shape>(_ start: S, _ end: S) -> S {
            var result = start
            var change = end.animatableData - start.animatableData
            change.scale(by: 0.5)
            result.animatableData += change
            return result
        }

        #expect(abs(midpoint(Chevron(thickness: 0.1), Chevron(thickness: 0.4)).thickness - 0.25) < 0.000001)
        #expect(abs(midpoint(Tick(thickness: 0.1), Tick(thickness: 0.4)).thickness - 0.25) < 0.000001)
        let corner = midpoint(RoundedCorner(radius: 0, corners: [.topLeft]),
                              RoundedCorner(radius: 40, corners: [.topLeft]))
        #expect(corner.radius == 20)
        #expect(corner.corners == [.topLeft])
    }

}
