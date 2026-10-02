import SwiftUI
import SwiftUIComponents

struct CheckboxExampleView: View {
    @State var checked = true
    var body: some View {
        Form {
            Section("Interactive: shared binding") {
                Checkbox(label: "Filled checkbox", checked: $checked).frame(height: 32).foregroundStyle(.blue)
                Checkbox(label: "Outlined checkbox", checked: $checked).stroked().frame(height: 32).foregroundStyle(.orange)
                Text(checked ? "Checked" : "Unchecked")
            }
            Section("Read-only and disabled variants") {
                Checkbox(checked: checked).frame(width: 32, height: 32)
                Checkbox(label: "Disabled", checked: $checked).disabled(true).frame(height: 32)
                Checkbox(label: "Unchecked indicator", checked: false).frame(height: 32)
            }
        }
    }
}
