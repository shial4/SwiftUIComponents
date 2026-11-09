import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

extension ComponentLogicTests {
    @Test("Frame transforms interpolate translation, rotation and scale")
    func frameInterpolation() {
        var start = FrameModifier(offset: .zero, rotation: .zero, scale: CGSize(width: 1, height: 1), anchor: .center)
        let end = FrameModifier(offset: CGSize(width: 20, height: 40), rotation: .degrees(90), scale: CGSize(width: 3, height: 5), anchor: .center)
        var halfway = end.animatableData - start.animatableData
        halfway.scale(by: 0.5)
        start.animatableData += halfway
        #expect(start.offset == CGSize(width: 10, height: 20))
        #expect(abs(start.rotation.degrees - 45) < 0.001)
        #expect(start.scale == CGSize(width: 2, height: 3))
    }

}
