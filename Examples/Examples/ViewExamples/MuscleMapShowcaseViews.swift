import SwiftUI
import SwiftUIComponents

enum MuscleAppearance: String, CaseIterable, Identifiable {
    case fill = "Solid fill", stroke = "Stroke only", linear = "Linear gradient"
    case radial = "Radial gradient", border = "Fill and border"
    var id: Self { self }
    var style: MuscleMap.Style {
        switch self {
        case .fill: .init(fillColor: .blue.opacity(0.65))
        case .stroke: .init(fillColor: .clear, strokeColor: .blue, lineWidth: 1.25)
        case .linear: .init(gradientColors: [.cyan, .blue, .purple])
        case .radial: .init(gradientColors: [.yellow, .orange, .red], gradientKind: .radial, gradientRadius: 150)
        case .border: .init(gradientColors: [.mint, .teal], strokeColor: .primary.opacity(0.7), lineWidth: 1)
        }
    }
    var code: String {
        switch self {
        case .fill: "MuscleMap.Style(fillColor: .blue.opacity(0.65))"
        case .stroke: "MuscleMap.Style(fillColor: .clear,\n    strokeColor: .blue, lineWidth: 1.25)"
        case .linear: "MuscleMap.Style(gradientColors: [.cyan, .blue, .purple])"
        case .radial: "MuscleMap.Style(gradientColors: [.yellow, .orange, .red],\n    gradientKind: .radial, gradientRadius: 150)"
        case .border: "MuscleMap.Style(gradientColors: [.mint, .teal],\n    strokeColor: .primary.opacity(0.7), lineWidth: 1)"
        }
    }
    var shapeModifiers: String {
        switch self {
        case .fill: ".fill(.blue.opacity(0.65))"
        case .stroke: ".stroke(.blue, lineWidth: 1.25)"
        case .linear: ".fill(LinearGradient(colors: [.cyan, .blue, .purple],\n    startPoint: .topLeading, endPoint: .bottomTrailing))"
        case .radial: ".fill(RadialGradient(colors: [.yellow, .orange, .red],\n    center: .center, startRadius: 0, endRadius: 150))"
        case .border: ".fill(LinearGradient(colors: [.mint, .teal],\n    startPoint: .topLeading, endPoint: .bottomTrailing))\n.overlay(shape.stroke(.primary.opacity(0.7), lineWidth: 1))"
        }
    }
}

enum MuscleRegionSample: String, CaseIterable, Identifiable {
    case front = "Front only", back = "Back only", both = "Both sides"
    case upper = "Upper body", lower = "Lower body", single = "Only biceps"
    var id: Self { self }
    var visibility: MuscleMap.Visibility {
        switch self { case .front, .single: .front; case .back: .back; default: .both }
    }
    // Example groupings belong to the app. Structure stays a neutral library identity.
    static let upperStructures: Set<MuscleMap.Structure> = [
        .neck, .trapezius, .deltoid, .pectoralisMajor, .externalOblique, .abdominals,
        .biceps, .forearms, .hands, .infraspinatus, .teresMajor, .triceps, .latissimusDorsi, .lowerBack,
    ]
    static let lowerStructures: Set<MuscleMap.Structure> = [
        .hips, .quadriceps, .calves, .tibialisAnterior, .tibiaAndFoot, .gluteus, .thighs, .hamstrings,
    ]
    func includes(_ structure: MuscleMap.Structure) -> Bool {
        switch self {
        case .upper: Self.upperStructures.contains(structure)
        case .lower: Self.lowerStructures.contains(structure)
        case .single: structure == .biceps
        default: structure != .contour
        }
    }
}

struct MuscleMapStylesExampleView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = min(220, max(0, proxy.size.width - 72))
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Anatomy, in your visual language.").font(.title2.bold())
                    Text("Solid color, outlines, gradients and borders. Return a Style for each named region; combine them in any way your screen needs.")
                        .foregroundStyle(.secondary)
                    ForEach(MuscleAppearance.allCases) { appearance in
                        ExampleCard(appearance.rawValue) {
                            MuscleMap(size: size)
                                .onStyleRequest { $0 == .contour ? .clear() : appearance.style }
                                .frame(maxWidth: .infinity).frame(height: 220)
                            ExampleCode(code: appearance.code)
                            NavigationLink("Open " + appearance.rawValue, value: ContentView.Demo.muscleAppearance(appearance))
                        }
                    }
                }.padding()
            }
        }
    }
}

struct MuscleMapRegionsExampleView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = min(120, max(0, (proxy.size.width - 44) / 2 - 24))
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose your view.").font(.title2.bold())
                    Text("Front, back, both, upper body, lower body or one muscle.")
                        .foregroundStyle(.secondary)
                    ForEach(0..<3, id: \.self) { row in
                        HStack(alignment: .top, spacing: 12) {
                            regionCard(MuscleRegionSample.allCases[row * 2], size: size)
                            regionCard(MuscleRegionSample.allCases[row * 2 + 1], size: size)
                        }
                    }
                    ExampleCode(code: "MuscleMap(size: 280, visibility: .front)\n    .onStyleRequest { region in\n        region == .biceps\n            ? .init(fillColor: .orange) : .clear()\n    }")
                    Text("Upper/lower group membership belongs to your app. Returning .clear() hides a region; it does not disable hit testing.")
                        .font(.caption).foregroundStyle(.secondary)
                }.padding()
            }
        }
    }

    private func regionCard(_ sample: MuscleRegionSample, size: Double) -> some View {
        VStack(spacing: 10) {
            MuscleMap(size: size, visibility: sample.visibility)
                .onStyleRequest { structure in
                    sample.includes(structure)
                        ? MuscleMap.Style(gradientColors: [.cyan, .blue], strokeColor: .blue.opacity(0.7), lineWidth: 0.5)
                        : .clear()
                }
                .frame(maxWidth: .infinity).frame(height: 120)
            Text(sample.rawValue).font(.subheadline.bold())
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue.opacity(0.15), lineWidth: 1))
    }
}

struct MuscleMapDragExampleView: View {
    @State var painted: Set<MuscleMap.Structure> = []
    @State var erase = false
    @State var lastTouched = "None"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Paint a workout.").font(.title2.bold())
                Text("Tap a region or drag across the front of the body. The same hit-testing API can drive workout selection, recovery scores or your own editor.")
                    .foregroundStyle(.secondary)
                Picker("Brush", selection: $erase) {
                    Text("Paint").tag(false); Text("Erase").tag(true)
                }.pickerStyle(.segmented)
                GeometryReader { proxy in
                    interactiveFront(size: min(proxy.size.width, 320))
                        .frame(maxWidth: .infinity)
                }.frame(height: 320)
                Text("Painted regions: \(painted.count)").font(.headline)
                Text("Last region: " + lastTouched).font(.callout).foregroundStyle(.secondary)
                Text(painted.map(\.displayName).sorted().joined(separator: ", "))
                Button("Clear painted regions") { painted.removeAll(); lastTouched = "None" }
                    .buttonStyle(.bordered)
                ExampleCode(code: "let front = MuscleMap.Front(translationX: 5)\n    .onStructureSelect { selected.insert($0) }\n\nfront.gesture(DragGesture(minimumDistance: 0)\n    .onChanged { value in\n        front.handleTap(location: value.location,\n            in: CGRect(x: 0, y: 0, width: size, height: size))\n    })")
            }.padding()
        }
    }

    private func interactiveFront(size: Double) -> some View {
        let front = MuscleMap.Front(translationX: 5)
            .onStyleRequest { structure in
                if structure == .contour { return .clear() }
                return .init(fillColor: .gray.opacity(0.15),
                             gradientColors: painted.contains(structure) ? [.orange, .red] : [],
                             strokeColor: .primary.opacity(0.35), lineWidth: 0.5)
            }
            .onStructureSelect { paint($0) }
        return front
            .frame(width: size, height: size)
            .background(Color.secondary.opacity(0.04), in: RoundedRectangle(cornerRadius: 20))
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    front.handleTap(location: value.location,
                                    in: CGRect(x: 0, y: 0, width: size, height: size))
                })
            .accessibilityLabel("Drag to paint muscle regions")
    }

    private func paint(_ structure: MuscleMap.Structure) {
        guard structure != .contour else { return }
        if lastTouched != structure.displayName { lastTouched = structure.displayName }
        if erase {
            if painted.contains(structure) { painted.remove(structure) }
        } else if !painted.contains(structure) { painted.insert(structure) }
    }
}

struct MuscleAppearanceExampleView: View {
    let appearance: MuscleAppearance
    @State var visibility = MuscleMap.Visibility.both
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Style a complete map, then override individual regions to reflect your own data.")
                    .foregroundStyle(.secondary)
                ExampleCard(appearance.rawValue) {
                    GeometryReader { proxy in
                        MuscleMap(size: min(proxy.size.width, 300), visibility: visibility)
                            .onStyleRequest { $0 == .contour ? .clear() : appearance.style }
                            .frame(maxWidth: .infinity)
                    }.frame(height: 300)
                }
                Picker("Visible side", selection: $visibility) {
                    Text("Front").tag(MuscleMap.Visibility.front)
                    Text("Back").tag(MuscleMap.Visibility.back)
                    Text("Both").tag(MuscleMap.Visibility.both)
                }.pickerStyle(.segmented)
                ExampleCode(code: "MuscleMap(size: 300, visibility: .both)\n    .onStyleRequest { region in\n        region == .contour ? .clear() :\n            " + appearance.code + "\n    }")
            }.padding()
        }
    }
}

struct MuscleSideExampleView: View {
    let front: Bool
    @State var selected: MuscleMap.Structure?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Use a side view directly when your own screen owns positioning and interaction.")
                    .foregroundStyle(.secondary)
                ExampleCard(front ? "Standalone Front" : "Standalone Back") {
                    GeometryReader { proxy in
                        side(size: min(proxy.size.width, 300)).frame(maxWidth: .infinity)
                            .accessibilityLabel(front ? "Standalone front muscle map" : "Standalone back muscle map")
                    }.frame(height: 300)
                }
                Text("Selected region: " + (selected?.displayName ?? "None"))
                ExampleCode(code: front
                    ? "MuscleMap.Front(translationX: 5)\n    .onStyleRequest { style(for: $0) }\n    .onStructureSelect { selected = $0 }"
                    : "MuscleMap.Back(translationX: -5.2)\n    .onStyleRequest { style(for: $0) }\n    .onStructureSelect { selected = $0 }")
                Text("Side views report selections when you call handleTap(location:in:). Attach your own tap or drag gesture using the same local bounds as the rendered side.")
                    .font(.caption).foregroundStyle(.secondary)
            }.padding()
        }
    }
    @ViewBuilder private func side(size: Double) -> some View {
        if front {
            let view = MuscleMap.Front(translationX: 5, structureSelect: { selected = $0 }, styleRequest: style)
            view.frame(width: size, height: size)
                .onTapGesture(coordinateSpace: .local) {
                    view.handleTap(location: $0, in: CGRect(x: 0, y: 0, width: size, height: size))
                }
        } else {
            let view = MuscleMap.Back(translationX: -5.2, structureSelect: { selected = $0 }, styleRequest: style)
            view.frame(width: size, height: size)
                .onTapGesture(coordinateSpace: .local) {
                    view.handleTap(location: $0, in: CGRect(x: 0, y: 0, width: size, height: size))
                }
        }
    }
    private func style(_ structure: MuscleMap.Structure) -> MuscleMap.Style? {
        if structure == .contour { return .clear() }
        return .init(fillColor: .gray.opacity(0.18),
                     gradientColors: selected == structure ? [.orange, .red] : [.cyan, .blue],
                     strokeColor: .primary.opacity(0.35), lineWidth: 0.5)
    }
}
