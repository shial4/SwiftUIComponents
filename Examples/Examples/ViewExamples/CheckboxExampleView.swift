import SwiftUI
import SwiftUIComponents

struct CheckboxExampleView: View {
    @State var isChecked = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Checkbox(checked: isChecked)
                    .stroked()
                    .frame(height: 32)
                    .onTapGesture { isChecked.toggle() }
                Checkbox(label: isChecked ? "checked" : "unchecked", checked: isChecked)
                    .frame(height: 32)
                    .onTapGesture { withAnimation(.linear) { 
                        isChecked.toggle()
                    } }
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            ).padding()
        }
    }
}

struct CheckboxExampleView_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxExampleView()
    }
}
