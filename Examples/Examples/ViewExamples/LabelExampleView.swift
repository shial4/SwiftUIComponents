import SwiftUI
import SwiftUIComponents

struct LabelExampleView: View {
    var body: some View {
        NavigationView {
            VStack {
                CountingLabel(to: "11 and second number in same string -22")
                CountingLabel(from: "down 11.0 up 7", to: "down 5.0 up 11", interval: 0.2)
                CountingLabel(from: "down 11.0 up 7", to: "down 5.0 up 11", format: ["%0.2f", "%0.0f"])
            }
        }
    }
}

struct LabelExampleView_Previews: PreviewProvider {
    static var previews: some View {
        LabelExampleView()
    }
}
