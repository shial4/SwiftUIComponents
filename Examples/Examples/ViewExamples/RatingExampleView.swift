import SwiftUI
import SwiftUIComponents

struct RatingExampleView: View {
    @State var rating = 4.5
    
    var body: some View {
        NavigationView {
            RatingView(rating: $rating)
                .frame(height: 44)
        }
    }
}

struct RatingExampleView_Previews: PreviewProvider {
    static var previews: some View {
        RatingExampleView()
    }
}
