import SwiftUI

/// Places a capsule label centered over a corner of the original view.
public struct Badge: ViewModifier {
    public var label: String
    public var color: Color
    public var alignment: Alignment
    @State var labelSize: CGSize = .zero

    public init(label: String, color: Color = .green, alignment: Alignment = .topTrailing) {
        self.label = label
        self.color = color
        self.alignment = alignment
    }

    private var normalizedAlignment: Alignment {
        switch alignment {
        case .bottomLeading, .bottomTrailing, .topTrailing, .topLeading: alignment
        default: .topTrailing
        }
    }

    public func body(content: Content) -> some View {
        content.overlay(alignment: normalizedAlignment) {
            Text(label)
                .lineLimit(1)
                .padding(.horizontal, 7)
                .padding(.vertical, 2)
                .background(color, in: Capsule())
                .fixedSize()
                .size(onChange: $labelSize)
                .offset(x: (normalizedAlignment == .topLeading || normalizedAlignment == .bottomLeading) ? -labelSize.width / 2 : labelSize.width / 2,
                        y: (normalizedAlignment == .topLeading || normalizedAlignment == .topTrailing) ? -labelSize.height / 2 : labelSize.height / 2)
        }
    }

    static func countLabel<T: BinaryInteger>(_ count: T, maximum: T) -> String {
        count > maximum ? "\(maximum)+" : "\(count)"
    }
}

public extension View {
    func badge<T: BinaryInteger>(count: T, max: T = 99, color: Color = .green,
                                 alignment: Alignment = .topTrailing) -> some View {
        modifier(Badge(label: Badge.countLabel(count, maximum: max), color: color, alignment: alignment))
    }

    func badge(label: String, color: Color = .green, alignment: Alignment = .topTrailing) -> some View {
        modifier(Badge(label: label, color: color, alignment: alignment))
    }
}
