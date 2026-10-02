import SwiftUI
import SwiftUIComponents

struct RatingExampleView: View {
    @State var rating = 3.5
    @State var spacing = 8.0
    var body: some View {
        Form {
            Text("Select a star, or use the slider for fractional ratings.")
            RatingView(rating: $rating, spacing: spacing).foregroundStyle(.orange).frame(height: 48)
            Text("Rating: \(rating, specifier: "%.1f") / 5")
            Slider(value: $rating, in: 0...5, step: 0.1) { Text("Rating") }
            Slider(value: $spacing, in: 0...20) { Text("Star spacing") }
            Section("Read-only display") {
                RatingView(rating: .constant(4.25)).disabled(true).foregroundStyle(.purple).frame(height: 32)
            }
        }
    }
}
