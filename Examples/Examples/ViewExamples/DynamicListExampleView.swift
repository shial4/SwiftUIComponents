import SwiftUI
import SwiftUIComponents

struct DynamicListExampleView: View {
    @State var scrollToIndex: Int?
    @State var visibleIndex: Int?
    @State var orientation = Orientation.horizontal
    @State var count = 30
    @State var sizing = Sizing.automatic
    @State var expanded = false
    @State var selected: Int?

    enum Sizing { case automatic, uniform, variable }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("SwiftUI sizes cells from their content. Show more content to see the list adjust automatically.")
                Picker("Axis", selection: $orientation) {
                    Text("Horizontal").tag(Orientation.horizontal)
                    Text("Vertical").tag(Orientation.vertical)
                }.pickerStyle(.segmented)
                Picker("Cell sizing", selection: $sizing) {
                    Text("Automatic").tag(Sizing.automatic)
                    Text("Uniform").tag(Sizing.uniform)
                    Text("Variable").tag(Sizing.variable)
                }.pickerStyle(.segmented)
                Toggle("Show more cell content", isOn: $expanded).disabled(sizing != .automatic)
                Stepper("Cells: \(count)", value: $count, in: 0...10_000, step: 10)
                Button("Use 10,000 cells") { count = 10_000 }
                Group {
                    switch sizing {
                    case .automatic:
                        DynamicList(scrollToIndex: $scrollToIndex, orientation: orientation,
                                    numberOfItems: count) { cell($0) }
                            .onVisibleCellChange { visibleIndex = $0 }
                    case .variable:
                        DynamicList(scrollToIndex: $scrollToIndex, orientation: orientation,
                                    itemLengths: (0..<count).map { 64 + Double($0 % 4) * 24 }) { cell($0) }
                            .onVisibleCellChange { visibleIndex = $0 }
                    case .uniform:
                        DynamicList(scrollToIndex: $scrollToIndex, orientation: orientation,
                                    numberOfItems: count, itemLength: 88) { cell($0) }
                            .onVisibleCellChange { visibleIndex = $0 }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                Text(visibleIndex.map { "Visible cell: \($0)" } ?? "No visible cell")
                    .font(.system(.body, design: .monospaced))
                Text(selected.map { "Selected cell: \($0)" } ?? "Select a cell")
                HStack {
                    Button("Start") { withAnimation { scrollToIndex = 0 } }
                    Button("Advance 3 cells") { withAnimation { scrollToIndex = min(count - 1, (visibleIndex ?? 0) + 3) } }
                    Button("Middle") { withAnimation { scrollToIndex = count / 2 } }
                    Button("End") { withAnimation { scrollToIndex = count - 1 } }
                }
            }.padding()
        }
    }

    private func cell(_ index: Int) -> some View {
        Button { selected = index } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(index)").font(.system(.title2, design: .monospaced))
                Text(index == selected ? "Selected" : ["Cell", "More content", "A longer description"][index % 3])
                    .font(.caption)
                if sizing == .automatic {
                    ForEach(0..<(index % 3), id: \.self) { detail in
                        Text("Detail \(detail + 1)").font(.caption)
                    }
                    if expanded {
                        Text("Additional cell content").font(.caption)
                        Text("The cell grows to fit.").font(.caption)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: orientation == .vertical ? .infinity : nil)
            .background(index == selected ? Color.orange.opacity(0.35) : Color.blue.opacity(0.15),
                        in: RoundedRectangle(cornerRadius: 10))
            .padding(4)
        }.buttonStyle(.plain)
        .accessibilityIdentifier("dynamic-list-cell-\(index)")
    }
}
