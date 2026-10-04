import Foundation
import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Component behavior")
struct ComponentLogicTests {
    @Test("Repeated numbers are replaced independently")
    func repeatedNumbers() {
        let counter = CountingText(from: "1 and 8", to: "10 and 10")
        #expect(counter.text(at: 1) == "2 and 9")
        #expect(counter.text(at: counter.frameCount) == "10 and 10")
    }

    @Test("Short formats and mismatched inputs remain safe")
    func mismatchedInputs() {
        let counter = CountingText(from: "0 and 0", to: "2 and 3", formats: ["%0.2f"])
        #expect(counter.text(at: counter.frameCount) == "2 and 3")
        #expect(CountingText(from: "1", to: "2 and 3").initialText == "2 and 3")
        #expect(CountingText(from: nil, to: "Text only").initialText == "Text only")
    }

    @Test("Signed decimals, Unicode and zero-based counting")
    func decimals() {
        let counter = CountingText(from: nil, to: "Łódź: -0.25 and +0.25", formats: ["%0.2f", "%0.2f"])
        #expect(counter.initialText == "Łódź: 0.00 and 0.00")
        #expect(counter.text(at: 1) == "Łódź: -0.01 and 0.01")
        #expect(counter.text(at: -1) == counter.initialText)
        #expect(counter.text(at: 500) == counter.target)
    }

    @Test("Unsafe printf formats fall back to numeric formatting", arguments: ["%s", "%@", "%n", "%999999f", "%0.99f", "hello"])
    func unsafeFormats(format: String) {
        let counter = CountingText(from: nil, to: "2", formats: [format])
        #expect(counter.initialText == "0")
        #expect(counter.text(at: 1) == "1")
    }

    @Test("Large counts finish in bounded time")
    func boundedCounting() {
        let counter = CountingText(from: "0", to: "1000000000")
        #expect(counter.frameCount == 120)
        #expect(counter.text(at: 120) == counter.target)
        #expect(CountingText(from: "10", to: "5").text(at: 1) == "9")
    }

    @MainActor @Test("Ratings show fractional stars and preserve supplied spacing")
    func ratings() {
        let rating = RatingView(rating: .constant(2.25), spacing: 12)
        #expect(rating.spacing == 12)
        #expect(RatingView.fraction(2.25, forStar: 0) == 1)
        #expect(RatingView.fraction(2.25, forStar: 2) == 0.25)
        #expect(RatingView.fraction(2.25, forStar: 3) == 0)
        #expect(RatingView.fraction(-2, forStar: 0) == 0)
        #expect(RatingView.fraction(99, forStar: 4) == 1)
        #expect(RatingView.fraction(.nan, forStar: 0) == 0)
    }

    @Test("Five rating cells stay square and inside compact bounds", arguments: [
        (320.0, 48.0, 8.0), (100.0, 32.0, 2.0), (12.0, 8.0, 20.0),
        (0.0, 32.0, 2.0), (320.0, 0.0, 2.0), (320.0, 48.0, -2.0)
    ])
    func ratingBounds(width: Double, height: Double, spacing: Double) {
        let layout = RatingLayout(size: CGSize(width: width, height: height), spacing: spacing)
        #expect(layout.side >= 0 && layout.side <= height)
        #expect(layout.side * 5 + layout.spacing * 4 <= width + 0.001)
        if width == 320 && height == 48 { #expect(layout.side == 48) }
    }

    @Test("Invalid rating dimensions cannot generate invalid frames")
    func invalidRatingBounds() {
        let layout = RatingLayout(size: CGSize(width: Double.infinity, height: Double.nan), spacing: .nan)
        #expect(layout.side == 0)
        #expect(layout.spacing == 0)
    }

    @MainActor @Test("Progress clamps invalid and out-of-range values", arguments: [(-1.0, 0.0), (0.5, 0.5), (2.0, 1.0), (Double.infinity, 0.0)])
    func progress(input: Double, expected: Double) {
        #expect(SwiftUIComponents.Progress<Circle>.normalized(input) == expected)
    }

    @MainActor @Test("Badge counts preserve full integer width")
    func badge() {
        #expect(Badge.countLabel(UInt.max, maximum: UInt.max) == String(UInt.max))
        #expect(Badge.countLabel(100, maximum: 99) == "99+")
        #expect(Badge.countLabel(99, maximum: 99) == "99")
    }

    @MainActor @Test("Joystick clamps the grip radially")
    func joystick() {
        #expect(JoystickView.constrained(CGPoint(x: 3, y: 4), radius: 10) == CGPoint(x: 3, y: 4))
        #expect(JoystickView.constrained(CGPoint(x: 30, y: 40), radius: 10) == CGPoint(x: 6, y: 8))
        #expect(JoystickView.constrained(CGPoint(x: CGFloat.nan, y: 0), radius: 10) == .zero)
        #expect(JoystickView.constrained(.zero, radius: 0) == .zero)
    }

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

    @MainActor @Test("Key-path bindings read and write their owner")
    func keyPathBinding() {
        let owner = BindingOwner()
        let binding = Binding(for: \BindingOwner.value, on: owner)
        #expect(binding.wrappedValue == 1)
        binding.wrappedValue = 4
        #expect(owner.value == 4)
        owner.value = 8
        #expect(binding.wrappedValue == 8)
        binding.wrappedValue = 8
        #expect(owner.updates == 2, "Writing the current value does not invalidate its owner")
    }
}

@MainActor private final class BindingOwner {
    var updates = 0
    var value = 1 { didSet { updates += 1 } }
}
