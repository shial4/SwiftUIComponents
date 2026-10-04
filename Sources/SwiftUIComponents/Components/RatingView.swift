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
                                Star().fill(.foreground)
                                    .clipShape(RatingFillClip(fraction: Self.fraction(rating, forStar: index)))
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

/// Shapes receive their bounds directly from layout, so each star needs no size reader.
private struct RatingFillClip: Shape {
    var fraction: Double
    var animatableData: Double {
        get { fraction }
        set { fraction = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path(CGRect(x: rect.minX, y: rect.minY, width: rect.width * fraction, height: rect.height))
    }
}
