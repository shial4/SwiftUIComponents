import SwiftUI
import SwiftUIComponents

struct MuscleMapExampleView: View {
    @State var visibility = MuscleMap.Visibility.both
    @State var selected: Set<MuscleMap.Structure> = [.biceps, .quadriceps]
    @State var interactive = true
    @State var gradient = MuscleMap.GradientKind.linear
    @State var outline = true
    @State var query = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Build your next workout.").font(.title2.bold())
                Text("Tap a region to add or remove it from your selection. Your screen owns the state; the map supplies scalable anatomy and typed region callbacks.")
                    .foregroundStyle(.secondary)
                Picker("Visible side", selection: $visibility) {
                    Text("Front").tag(MuscleMap.Visibility.front)
                    Text("Back").tag(MuscleMap.Visibility.back)
                    Text("Both").tag(MuscleMap.Visibility.both)
                }.pickerStyle(.segmented)
                Toggle("Enable map selection", isOn: $interactive)
                Toggle("Show region outlines", isOn: $outline)
                Picker("Highlight gradient", selection: $gradient) {
                    Text("Linear").tag(MuscleMap.GradientKind.linear)
                    Text("Radial").tag(MuscleMap.GradientKind.radial)
                }
                GeometryReader { proxy in
                    MuscleMap(size: min(proxy.size.width, proxy.size.height), visibility: visibility,
                              userInteractionEnabled: interactive)
                        .onStyleRequest { structure in
                            if structure == .contour { return .clear() }
                            return MuscleMap.Style(
                                fillColor: .gray.opacity(0.18),
                                gradientColors: selected.contains(structure) ? [.orange, .red] : [],
                                gradientKind: gradient, gradientRadius: 160,
                                strokeColor: outline ? .primary.opacity(0.5) : .clear,
                                lineWidth: outline ? 0.75 : 0
                            )
                        }
                        .onStructureSelect { toggle($0) }
                        .frame(maxWidth: .infinity)
                }.frame(height: 360)
                Text("Selected: " + selected.map(\.displayName).sorted().joined(separator: ", "))
                    .font(.callout)
                Button("Clear selection") { selected.removeAll() }
                ExampleCard("Explore Muscle Map") {
                    NavigationLink("Fills, strokes, gradients and borders", value: ContentView.Demo.muscleStyles)
                    NavigationLink("Front, back, upper, lower and one muscle", value: ContentView.Demo.muscleRegions)
                    NavigationLink("Tap and drag integration", value: ContentView.Demo.muscleDrag)
                    NavigationLink("Every front-side shape", value: ContentView.Demo.frontAtlas)
                    NavigationLink("Every back-side shape", value: ContentView.Demo.backAtlas)
                }
                SearchBar(text: $query, prompt: "Find a region by name")
                // Also provides keyboard and VoiceOver access to every region.
                ForEach(MuscleMap.Structure.allCases.filter {
                    query.isEmpty || $0.displayName.localizedCaseInsensitiveContains(query) || $0.has(target: query)
                }, id: \.self) { structure in
                    Toggle(structure.displayName.capitalized, isOn: Binding(
                        get: { selected.contains(structure) },
                        set: { if $0 { selected.insert(structure) } else { selected.remove(structure) } }
                    ))
                }
                GroupBox("Use individual shapes") {
                    HStack {
                        MuscleShapePreview(sample: .frontBiceps, appearance: .border)
                        MuscleShapePreview(sample: .backLatissimusDorsi)
                    }.frame(height: 120)
                }
            }.padding()
        }
    }

    private func toggle(_ structure: MuscleMap.Structure) {
        if selected.contains(structure) { selected.remove(structure) } else { selected.insert(structure) }
    }
}
