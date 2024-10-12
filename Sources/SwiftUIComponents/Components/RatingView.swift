import SwiftUI

/// A customizable rating view with stars for user input.
public struct RatingView: View {
    @Binding public var rating: Double
    public var spacing: Double = 2
    
    private var progress: Double {
        max(min(rating / 5.0, 5), 0)
    }
    
    /// Initializes the RatingView with the specified rating.
    ///
    /// - Parameter rating: A binding to a double value representing the user's rating.
    /// - Parameter spacing: The spacing between the stars.
    public init(rating: Binding<Double>, spacing: Double = 2) {
        self._rating = rating
    }
    
    public var body: some View {
        let result = ZStack {
            starsView(isFill: false)
            starsView()
                .mask {
                    GeometryReader { proxy in
                        Rectangle()
                            .fill(ForegroundStyle.foreground)
                            .frame(width: proxy.size.width * progress, alignment: Alignment.leading)
                    }
                }
        }
        return result
    }
    
    private func starsView(isFill: Bool = true) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { i in
                Group {
                    if isFill {
                        Star()
                            .fill(ForegroundStyle.foreground)
                    } else {
                        Star()
                            .stroke(ForegroundStyle.foreground)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { rating = Double(i + 1) }
            }
            .aspectRatio(1, contentMode: ContentMode.fit)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RatingView(rating: .constant(0.3)).foregroundColor(Color.blue)
            RatingView(rating: .constant(1.3)).foregroundStyle(Color.red)
            RatingView(rating: .constant(2.3))
            RatingView(rating: .constant(3.3))
            RatingView(rating: .constant(4.3))
            RatingView(rating: .constant(5.5))
            
        }.frame(height: 44 * 5)
    }
}
