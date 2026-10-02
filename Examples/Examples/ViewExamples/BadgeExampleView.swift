import SwiftUI
import SwiftUIComponents

struct BadgeExampleView: View {
    @State var count = 5
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Stepper("Count: \(count)", value: $count, in: 0...150)
                Text("Inbox").padding().background(.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                    .badge(count: count, max: 99, color: .orange)
                HStack(spacing: 64) {
                    sample.badge(label: "Top left", color: .purple, alignment: .topLeading)
                    sample.badge(label: "Top right", alignment: .topTrailing)
                }
                HStack(spacing: 64) {
                    sample.badge(label: "Bottom left", alignment: .bottomLeading)
                    sample.badge(label: "Bottom right", color: .orange, alignment: .bottomTrailing)
                }
                Text("Unsigned counts also work").padding().badge(count: UInt.max, max: UInt(999))
            }.padding(32)
        }
    }
    private var sample: some View { RoundedRectangle(cornerRadius: 12).fill(.blue.opacity(0.2)).frame(width: 80, height: 80) }
}
