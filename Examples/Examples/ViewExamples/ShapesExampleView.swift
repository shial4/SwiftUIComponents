import SwiftUI
import SwiftUIComponents

enum ShapeSample: String, CaseIterable, Identifiable {
    case arrow = "Arrow", chevron = "Chevron", star = "Star", tick = "Tick"
    case triangle = "Triangle", xMark = "XMark", plus = "Plus", minus = "Minus"
    case roundedCorner = "RoundedCorner"
    var id: Self { self }
    var constructor: String {
        switch self {
        case .arrow: "Arrow()"
        case .chevron: "Chevron(thickness: 0.2)"
        case .star: "Star(points: 7)"
        case .tick: "Tick(thickness: 0.2)"
        case .triangle: "Triangle(orientation: .top)"
        case .xMark: "XMark()"
        case .plus: "Plus()"
        case .minus: "Minus()"
        case .roundedCorner: "RoundedCorner(radius: 32, corners: [.topLeft, .bottomRight])"
        }
    }
    var code: String {
        if self == .xMark {
            return "XMark().stroke(.red,\n    style: StrokeStyle(lineWidth: 5, lineCap: .round))"
        }
        return constructor + "\n    .fill(LinearGradient(colors: [.cyan, .blue, .purple],\n        startPoint: .topLeading, endPoint: .bottomTrailing))"
    }
    var detail: String {
        switch self {
        case .arrow: "A vector arrow for next steps, directions and callouts."
        case .chevron: "Change the thickness, then use rotation for any direction."
        case .star: "Choose the point count for ratings, achievements or highlights."
        case .tick: "A scalable checkmark with configurable thickness."
        case .triangle: "Four directions, ready for indicators and decorative accents."
        case .xMark: "An open path. Use a stroke with rounded caps for a close icon."
        case .plus: "A filled addition icon that scales without an image asset."
        case .minus: "A matching subtraction icon, with fill and outline options."
        case .roundedCorner: "Round just the corners you choose, as a shape or clipping mask."
        }
    }
}

struct ShapesExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("One vector. Many looks.").font(.title2.bold())
                Text("Every shape has its own playground. Explore fills, outlines, gradients and borders using the same SwiftUI code on iOS and Android.")
                    .foregroundStyle(.secondary)
                ForEach(ShapeSample.allCases) { sample in
                    NavigationLink(value: ContentView.Demo.shape(sample)) {
                        ExampleCard(sample.rawValue, detail: sample.detail) {
                            ShapeExampleView(sample: sample).preview.frame(height: 100)
                        }
                    }.buttonStyle(.plain)
                }
            }.padding()
        }
    }
}

struct ShapeExampleView: View {
    let sample: ShapeSample
    @State var style = 2
    @State var points = 7
    @State var thickness = 0.2
    @State var direction = 2
    @State var radius = 32.0
    @State var dashed = false
    @State var rotation = 0.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(sample.detail).foregroundStyle(.secondary)
                ExampleCard("Your \(sample.rawValue)", detail: "The same shape, styled with standard SwiftUI.") {
                    preview.frame(height: 190).padding(16)
                }
                Picker("Shape style", selection: $style) {
                    Text("Fill").tag(0); Text("Stroke").tag(1)
                    Text("Gradient").tag(2); Text("Border").tag(3)
                }.pickerStyle(.segmented)
                if sample == .star { Stepper("Star points: \(points)", value: $points, in: 3...12) }
                if sample == .chevron || sample == .tick {
                    Text("Thickness: \(thickness, specifier: "%.2f")")
                    Slider(value: $thickness, in: 0.05...0.45)
                }
                if sample == .triangle {
                    Picker("Triangle direction", selection: $direction) {
                        Text("Left").tag(0); Text("Right").tag(1)
                        Text("Up").tag(2); Text("Down").tag(3)
                    }.pickerStyle(.segmented)
                }
                if sample == .roundedCorner {
                    Text("Corner radius: \(radius, specifier: "%.0f")")
                    Slider(value: $radius, in: 0...80)
                }
                Toggle("Dashed outline", isOn: $dashed)
                Text("Rotation: \(rotation, specifier: "%.0f") degrees")
                Slider(value: $rotation, in: 0...360)
                ExampleCode(code: sample.code + "\n    .frame(width: 120, height: 120)")
            }.padding()
        }
    }

    @ViewBuilder var preview: some View {
        switch sample {
        case .arrow: styled(Arrow())
        case .chevron: styled(Chevron(thickness: thickness))
        case .star: styled(Star(points: points))
        case .tick: styled(Tick(thickness: thickness))
        case .triangle:
            styled(Triangle(orientation: direction == 0 ? .leading : direction == 1 ? .trailing : direction == 2 ? .top : .bottom))
        case .xMark: styled(XMark(), openPath: true)
        case .plus: styled(Plus())
        case .minus: styled(Minus())
        case .roundedCorner: styled(RoundedCorner(radius: radius, corners: [.topLeft, .bottomRight]))
        }
    }

    private func styled<S: Shape>(_ shape: S, openPath: Bool = false) -> some View {
        let fitted = FittedPreviewShape(shape: shape, aspectRatio: sample == .arrow || sample == .minus ? 1.8 : 1)
        return ZStack {
            if !openPath, style != 1 {
                if style >= 2 {
                    fitted.fill(LinearGradient(colors: [.cyan, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                } else { fitted.fill(.blue) }
            }
            if openPath || style == 1 || style == 3 {
                fitted.stroke(openPath ? Color.red : .blue,
                              style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round,
                                                 dash: dashed ? [10, 6] : []))
            }
        }
        .rotationEffect(.degrees(rotation))
        .padding(8)
    }
}

/// Use the size SwiftUI gives the shape instead of adding a measurement view.
private struct FittedPreviewShape<S: Shape>: Shape {
    let shape: S
    let aspectRatio: CGFloat
    func path(in rect: CGRect) -> Path {
        let width = min(rect.width, rect.height * aspectRatio)
        let height = width / aspectRatio
        return shape.path(in: CGRect(x: rect.midX - width / 2, y: rect.midY - height / 2,
                                     width: width, height: height))
    }
}
