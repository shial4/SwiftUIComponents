import SwiftUI
import SwiftUIComponents

struct LabelExampleView: View {
    @State var target = 11
    var body: some View {
        Form {
            Section("Start from zero") {
                CountingLabel(to: "Score: \(target)", interval: 0.03)
            }
            Section("Count down and up") {
                CountingLabel(from: "Down 11, up 7", to: "Down 5, up 11", interval: 0.1)
            }
            Section("Decimal formats and repeated numbers") {
                CountingLabel(from: "Paid 0.00, saved 0.00", to: "Paid 1.25, saved 1.25",
                              interval: 0.02, format: ["%0.2f", "%0.2f"])
            }
            Stepper("Target: \(target)", value: $target, in: -100...100)
            Text("Changing the target restarts counting. Reduced Motion displays the final value immediately.")
        }
    }
}
