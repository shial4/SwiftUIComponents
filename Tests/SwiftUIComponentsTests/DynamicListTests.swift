import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("DynamicList sizing and boundaries")
struct DynamicListTests {
    @Test("Uniform cells have constant-time sizing, including large lists")
    func uniformLengths() {
        let lengths = DynamicListLengths(count: 1_000_000, length: 25)
        #expect(lengths.count == 1_000_000)
        #expect(lengths.total == 25_000_000)
        #expect(lengths[999_999] == 25)
    }

    @Test("Variable lengths retain order and total")
    func variableLengths() {
        let lengths = DynamicListLengths([30, 60, 15])
        #expect(lengths.count == 3)
        #expect(lengths.total == 105)
        #expect((0..<3).map { lengths[$0] } == [30, 60, 15])
    }

    @Test("Empty, negative and nonfinite dimensions are safe")
    func invalidLengths() {
        #expect(DynamicListLengths(count: -5, length: 20).count == 0)
        #expect(DynamicListLengths([]).total == 0)
        let lengths = DynamicListLengths([20, -1, .nan, .infinity, 0])
        #expect(lengths.total == 20)
        #expect((0..<lengths.count).map { lengths[$0] } == [20, 0, 0, 0, 0])
        #expect(DynamicListLengths(count: 2, length: .greatestFiniteMagnitude).count == 0)
        #expect(DynamicListLengths([.greatestFiniteMagnitude, .greatestFiniteMagnitude]).count == 0)
    }

    @Test("Offsets clamp to content bounds", arguments: [(100.0, 0.0), (-50.0, -50.0), (-1000.0, -300.0), (Double.nan, 0.0), (Double.infinity, 0.0)])
    func clamping(offset: Double, expected: Double) {
        let lengths = DynamicListLengths(count: 10, length: 50)
        #expect(lengths.clampedOffset(offset, viewport: 200) == expected)
    }

    @Test("Content shorter than the viewport stays at the leading edge")
    func shortContent() {
        #expect(DynamicListLengths([20, 30]).clampedOffset(-80, viewport: 100) == 0)
        #expect(DynamicListLengths([]).clampedOffset(-80, viewport: 100) == 0)
        #expect(DynamicListLengths([50]).clampedOffset(-80, viewport: .nan) == -50)
    }

    @Test("Axes can be inverted")
    func orientation() {
        #expect(Orientation.horizontal.not() == .vertical)
        #expect(Orientation.vertical.not() == .horizontal)
    }
}
