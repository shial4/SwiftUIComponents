import SwiftUI
import SwiftUIComponents

struct BadgeExampleView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(label: "Hey", alignment: .bottomLeading)
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(label: "1", alignment: .bottomTrailing)
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(label: "99", alignment: .topLeading)
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(label: "99+", alignment: .topTrailing)
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(count: 999, alignment: .center)
                Rectangle().fill(Color.blue).frame(width: 40, height: 40)
                    .badge(count: 56, alignment: .topLeading)
            }
        }
    }
}

struct BadgeExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeExampleView()
    }
}
