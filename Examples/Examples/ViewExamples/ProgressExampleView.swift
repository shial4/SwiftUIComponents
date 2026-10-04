import SwiftUI
import SwiftUIComponents

struct ProgressExampleView: View {
    @State var progress = 0.35
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(verbatim: progress.formatted(.percent.precision(.fractionLength(0)))).font(.title)
                Slider(value: $progress, in: 0...1) { Text("Progress") }
                HStack(spacing: 24) {
                    Progress(progress: $progress, content: Circle(), lineWidth: 8)
                    Progress(progress: $progress, content: Star())
                    Progress(progress: $progress, content: RoundedRectangle(cornerRadius: 12),
                             style: StrokeStyle(lineWidth: 5, lineCap: .round, dash: [6, 3]))
                }.frame(height: 96).foregroundStyle(.blue).backgroundStyle(.gray.opacity(0.2))
                Progress(progress: $progress, content: Rectangle(), lineWidth: 4)
                    .frame(height: 4).foregroundStyle(.purple).backgroundStyle(.gray.opacity(0.2))
                Button("Animate to completion") { withAnimation(.easeInOut(duration: 1)) { progress = 1 } }
                Button("Reset") { progress = 0 }
            }.padding(24)
        }
    }
}
