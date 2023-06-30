import SwiftUI
import SwiftUIComponents

struct SliderExampleView: View {
    @State var minValue: Double = 0
    @State var maxValue: Double = 10
    @State var value: Double = 0
    
    var body: some View {
        NavigationView {
            Text("To be done")
        }
    }
}

struct SliderExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SliderExampleView()
    }
}
