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
        HStack(spacing: spacing.isFinite ? max(0, spacing) : 2) {
            ForEach(0..<5, id: \.self) { index in
                Button { rating = Double(index + 1) } label: {
                    Star().stroke(.foreground)
                        .overlay {
                            Star().fill(.foreground)
                                .mask(alignment: .leading) {
                                    RatingFillMask(fraction: Self.fraction(rating, forStar: index))
                                }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .componentHitArea(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(index + 1) of 5 stars")
                .accessibilityAddTraits(Int(min(5, max(0, rating.isFinite ? rating : 0))) == index + 1 ? .isSelected : .componentEmpty)
            }
        }
        .componentAccessibilityChildren(.contain)
        .accessibilityValue("\(rating.isFinite ? min(5, max(0, rating)) : 0) of 5")
    }
}

/// Shapes receive their bounds directly from layout, so each star needs no size reader.
private struct RatingFillMask: Shape {
    var fraction: Double
    var animatableData: Double {
        get { fraction }
        set { fraction = newValue }
    }
    func path(in rect: CGRect) -> Path {
        Path(CGRect(x: rect.minX, y: rect.minY, width: rect.width * fraction, height: rect.height))
    }
}
