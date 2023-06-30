import SwiftUI

/// A customizable rating view with stars for user input.
public struct RatingView: View {
    @Binding public var rating: Double
    public var spacing: CGFloat = 2
    
    private var progress: Double {
        max(min(rating / 5.0, 5), 0)
    }
    
    /// Initializes the RatingView with the specified rating.
    ///
    /// - Parameter rating: A binding to a double value representing the user's rating.
    /// - Parameter spacing: The spacing between the stars.
    public init(rating: Binding<Double>, spacing: CGFloat = 2) {
        self._rating = rating
    }
    
    public var body: some View {
        ZStack {
            starsView(isFill: false)
            starsView().mask {
                GeometryReader { proxy in
                    Rectangle()
                        .fill(.foreground)
                        .frame(width: proxy.size.width * progress, alignment: .leading)
                }
            }
        }
    }
    
    private func starsView(isFill: Bool = true) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { i in
                Group {
                    if isFill {
                        Star()
                            .fill(.foreground)
                    } else {
                        Star()
                            .stroke(.foreground)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { rating = Double(i + 1) }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RatingView(rating: .constant(0.3)).foregroundColor(.blue)
            RatingView(rating: .constant(1.3)).foregroundStyle(.red)
            RatingView(rating: .constant(2.3))
            RatingView(rating: .constant(3.3))
            RatingView(rating: .constant(4.3))
            RatingView(rating: .constant(5.5))
            
        }.frame(height: 44 * 5)
    }
}
