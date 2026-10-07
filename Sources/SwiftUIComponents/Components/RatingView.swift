import SwiftUI

/// A five-star rating, including fractional display and accessible whole-star input.
public struct RatingView: View {
    @Binding public var rating: Double
    public var spacing: Double

    public init(rating: Binding<Double>, spacing: Double = 2) {
        self._rating = rating
        self.spacing = spacing
    }

    static func fraction(_ rating: Double, forStar index: Int) -> Double {
        guard rating.isFinite else { return 0 }
        return min(1, max(0, rating - Double(index)))
    }

    public var body: some View {
        GeometryReader { geometry in
            let layout = RatingLayout(size: geometry.size, spacing: spacing)
            HStack(spacing: layout.spacing) {
                ForEach(0..<5, id: \.self) { index in
                    Button {
                        let selected = Double(index + 1)
                        if rating != selected { rating = selected }
                    } label: {
                        Star().stroke(.foreground)
                            .overlay {
                                // A trimmed stroke reveals the fill using the same native
                                // animation path as Progress, including on Skip Fuse.
                                Path {
                                    $0.move(to: CGPoint(x: 0, y: layout.side / 2))
                                    $0.addLine(to: CGPoint(x: layout.side, y: layout.side / 2))
                                }
                                .trim(from: 0, to: Self.fraction(rating, forStar: index))
                                .stroke(.foreground, lineWidth: layout.side)
                                .clipShape(Star())
                            }
                            .frame(width: layout.side, height: layout.side)
                            .componentHitArea(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(index + 1) of 5 stars")
                    .accessibilityAddTraits(Int(min(5, max(0, rating.isFinite ? rating : 0))) == index + 1 ? .isSelected : .componentEmpty)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(idealWidth: 168, idealHeight: 32)
        .componentAccessibilityChildren(.contain)
        .accessibilityValue("\(rating.isFinite ? min(5, max(0, rating)) : 0) of 5")
    }
}

/// Measure the container once and give every star the same square bounds.
struct RatingLayout: Equatable, Sendable {
    let side: Double
    let spacing: Double

    init(size: CGSize, spacing: Double) {
        let width = size.width.isFinite ? max(0, size.width) : 0
        let height = size.height.isFinite ? max(0, size.height) : 0
        self.spacing = min(width / 4, spacing.isFinite ? max(0, spacing) : 2)
        self.side = min(height, max(0, (width - self.spacing * 4) / 5))
    }
}
