import SwiftUI
import SwiftUIComponents

enum ModifierSample: String, CaseIterable, Identifiable {
    case reverseMask = "Reverse Mask", corners = "Corner Radius", size = "Size Observation"
    case frame = "Frame Observation", conditional = "Conditional Modifier", composed = "Composed Modifier"
    case transform = "FrameModifier", transition = "Transform Transition", stack = "StackView"
    var id: Self { self }
    var detail: String {
        switch self {
        case .reverseMask: "Cut a vector shape out of a card, image or gradient."
        case .corners: "Round selected corners for a distinctive card or chat bubble."
        case .size: "Observe the actual rendered size with a binding or callback."
        case .frame: "Observe a view's global position as layout and scrolling change."
        case .conditional: "Apply a transform when your own condition is true."
        case .composed: "Compose a reusable group of modifiers with a view builder."
        case .transform: "Offset, rotate and scale a view around a chosen anchor."
        case .transition: "Animate a view between two rectangles as it enters or leaves."
        case .stack: "Switch a stack between horizontal and vertical layouts."
        }
    }
    var code: String {
        switch self {
        case .reverseMask: "Rectangle().fill(.purple)\n    .reverseMask { Star().frame(width: 80, height: 80) }"
        case .corners: "Text(\"Hello\").padding(24)\n    .background(.blue.opacity(0.2))\n    .cornerRadius(24, corners: .topLeft, .bottomRight)"
        case .size: "Text(title).padding()\n    .size(onChange: $measuredSize)"
        case .frame: "Text(title).padding()\n    .frame(onChange: $measuredFrame)"
        case .conditional: "Text(\"Featured\")\n    .if(featured) { $0.bold().foregroundStyle(.orange) }"
        case .composed: "Text(\"One builder\").modified {\n    $0.padding().background(.blue.opacity(0.2))\n}"
        case .transform: "Text(\"Move me\").modifier(FrameModifier(\n    offset: CGSize(width: 8, height: 0),\n    rotation: .degrees(8),\n    scale: CGSize(width: 1.1, height: 1.1), anchor: .center))"
        case .transition: ".transition(.transform(\n    from: CGRect(x: 0, y: 0, width: 10, height: 10),\n    to: CGRect(x: 0, y: 0, width: 180, height: 44)))"
        case .stack: "StackView(orientation: vertical ? .vertical : .horizontal) {\n    Text(\"One\"); Text(\"Two\")\n}"
        }
    }
}

struct ModifiersExampleView: View {
    var body: some View {
        List(ModifierSample.allCases) { sample in
            NavigationLink(value: ContentView.Demo.modifier(sample)) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(sample.rawValue).font(.headline)
                    Text(sample.detail).font(.caption).foregroundStyle(.secondary)
                }.padding(.vertical, 8)
            }
        }
    }
}

struct ModifierExampleView: View {
    let sample: ModifierSample
    @State var measuredSize = CGSize.zero
    @State var measuredFrame = CGRect.zero
    @State var emphasize = true
    @State var show = true
    @State var vertical = false
    @State var value = 24.0
    @State var rotation = 8.0
    @State var title = "Make it yours"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(sample.detail).foregroundStyle(.secondary)
                ExampleCard(sample.rawValue, detail: "A small modifier with a visible result.") {
                    preview.frame(minHeight: 180)
                }
                controls
                if sample == .transition {
                    Text("Android applies translation and uniform scale. Apple also applies rotation and independent scale axes.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                if sample == .stack {
                    Text("Apple retains child state through AnyLayout. Changing the axis can reset child state on Android.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                ExampleCode(code: sample.code)
            }.padding()
        }
    }

    @ViewBuilder private var preview: some View {
        switch sample {
        case .reverseMask:
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .reverseMask { Star(points: 7).frame(width: 110, height: 110) }
                .frame(height: 180)
        case .corners:
            Text("A corner of your own").font(.title3.bold()).padding(32)
                .frame(maxWidth: .infinity).background(.blue.opacity(0.2))
                .cornerRadius(value, corners: .topLeft, .bottomRight)
        case .size, .frame:
            VStack(spacing: 20) {
                Text(title).padding(value).background(.orange.opacity(0.2))
                    .size(onChange: $measuredSize).frame(onChange: $measuredFrame)
                Text("Size: \(Int(measuredSize.width)) x \(Int(measuredSize.height))")
                Text("Global origin: \(Int(measuredFrame.minX)), \(Int(measuredFrame.minY))")
            }.font(.system(.body, design: .monospaced))
        case .conditional:
            Text("Featured collection").font(.title2).padding()
                .if(emphasize) { $0.bold().foregroundStyle(.orange).background(.orange.opacity(0.12)) }
        case .composed:
            Text("One builder, your styling").font(.title3).modified {
                $0.padding(24).background(.blue.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: 2))
            }
        case .transform:
            Text("Move me").font(.title2.bold()).padding(24).background(.green.opacity(0.2))
                .modifier(FrameModifier(offset: CGSize(width: value - 24, height: 0), rotation: .degrees(rotation),
                                        scale: CGSize(width: 1.1, height: 1.1), anchor: .center))
        case .transition:
            ZStack {
                if show {
                    Text("Hello again").font(.title3.bold()).padding(24).background(.purple.opacity(0.2))
                        .transition(.transform(from: CGRect(x: 0, y: 0, width: 10, height: 10),
                                               to: CGRect(x: 0, y: 0, width: 180, height: 44), rotation: .degrees(45)))
                }
            }
        case .stack:
            StackView(orientation: vertical ? .vertical : .horizontal) {
                Text("One").padding(20).background(.blue.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                Text("Two").padding(20).background(.orange.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    @ViewBuilder private var controls: some View {
        switch sample {
        case .corners, .size, .frame, .transform:
            Text(sample == .corners ? "Corner radius" : sample == .transform ? "Horizontal offset" : "Padding")
            Slider(value: $value, in: 0...48)
            if sample == .size || sample == .frame { TextField("Preview text", text: $title).textFieldStyle(.roundedBorder) }
            if sample == .transform {
                Text("Rotation")
                Slider(value: $rotation, in: -30...30)
            }
        case .conditional: Toggle("Featured", isOn: $emphasize)
        case .transition: Button("Toggle transition") { withAnimation { show.toggle() } }.buttonStyle(.borderedProminent)
        case .stack: Toggle("Vertical layout", isOn: $vertical)
        case .reverseMask, .composed: EmptyView()
        }
    }
}
