import SwiftUI
import SwiftUIComponents

struct LabelExampleView: View {
    @State var target = 50

    var body: some View {
        let amount = String(format: "%.2f", Double(target) / 4)

        Form {
            Section("Start from zero") {
                CountingLabel(to: "Score: \(target)", interval: 0.02)
            }
            Section("Count down and up") {
                CountingLabel(from: "Down 100, up 0", to: "Down \(100 - target), up \(target)", interval: 0.02)
            }
            Section("Decimal formats and repeated numbers") {
                CountingLabel(from: "Paid 0.00, saved 0.00", to: "Paid \(amount), saved \(amount)",
                              interval: 0.01, format: ["%0.2f", "%0.2f"])
            }
            Section("Percentage") {
                CountingLabel(to: "Complete: \(target).0%", interval: 0.01, format: ["%0.1f"])
            }
            Stepper("Target: \(target)", value: $target, in: 0...100, step: 10)
            Text("Changing the target restarts every label. Reduced Motion displays the final values immediately.")
        }
    }
}
