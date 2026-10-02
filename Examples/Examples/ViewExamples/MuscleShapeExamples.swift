import SwiftUI
import SwiftUIComponents

enum MuscleShapeSample: String, CaseIterable, Identifiable {
    case frontAbdominals = "Front Abdominals"
    case frontBiceps = "Front Biceps"
    case frontCalves = "Front Calves"
    case frontContour = "Front Contour"
    case frontDeltoid = "Front Deltoid"
    case frontExternalOblique = "Front External Oblique"
    case frontForearms = "Front Forearms"
    case frontHands = "Front Hands"
    case frontHead = "Front Head"
    case frontHips = "Front Hips"
    case frontNeck = "Front Neck"
    case frontPectoralisMajor = "Front Pectoralis Major"
    case frontQuadriceps = "Front Quadriceps"
    case frontTibiaAndFoot = "Front Tibia And Foot"
    case frontTibialisAnterior = "Front Tibialis Anterior"
    case frontTrapezius = "Front Trapezius"
    case backCalves = "Back Calves"
    case backContour = "Back Contour"
    case backDeltoid = "Back Deltoid"
    case backFoot = "Back Foot"
    case backForearms = "Back Forearms"
    case backGluteus = "Back Gluteus"
    case backHamstrings = "Back Hamstrings"
    case backHands = "Back Hands"
    case backHead = "Back Head"
    case backInfraspinatus = "Back Infraspinatus"
    case backLatissimusDorsi = "Back Latissimus Dorsi"
    case backLowerBack = "Back Lower Back"
    case backTeresMajor = "Back Teres Major"
    case backThighs = "Back Thighs"
    case backTrapezius = "Back Trapezius"
    case backTriceps = "Back Triceps"
    var id: Self { self }
    var isFront: Bool { rawValue.hasPrefix("Front ") }
    var constructor: String {
        switch self {
        case .frontAbdominals: "MuscleMap.Front.Abdominals()"
        case .frontBiceps: "MuscleMap.Front.Biceps()"
        case .frontCalves: "MuscleMap.Front.Calves()"
        case .frontContour: "MuscleMap.Front.Contour()"
        case .frontDeltoid: "MuscleMap.Front.Deltoid()"
        case .frontExternalOblique: "MuscleMap.Front.ExternalOblique()"
        case .frontForearms: "MuscleMap.Front.Forearms()"
        case .frontHands: "MuscleMap.Front.Hands()"
        case .frontHead: "MuscleMap.Front.Head()"
        case .frontHips: "MuscleMap.Front.Hips()"
        case .frontNeck: "MuscleMap.Front.Neck()"
        case .frontPectoralisMajor: "MuscleMap.Front.PectoralisMajor()"
        case .frontQuadriceps: "MuscleMap.Front.Quadriceps()"
        case .frontTibiaAndFoot: "MuscleMap.Front.TibiaAndFoot()"
        case .frontTibialisAnterior: "MuscleMap.Front.TibialisAnterior()"
        case .frontTrapezius: "MuscleMap.Front.Trapezius()"
        case .backCalves: "MuscleMap.Back.Calves()"
        case .backContour: "MuscleMap.Back.Contour()"
        case .backDeltoid: "MuscleMap.Back.Deltoid()"
        case .backFoot: "MuscleMap.Back.Foot()"
        case .backForearms: "MuscleMap.Back.Forearms()"
        case .backGluteus: "MuscleMap.Back.Gluteus()"
        case .backHamstrings: "MuscleMap.Back.Hamstrings()"
        case .backHands: "MuscleMap.Back.Hands()"
        case .backHead: "MuscleMap.Back.Head()"
        case .backInfraspinatus: "MuscleMap.Back.Infraspinatus()"
        case .backLatissimusDorsi: "MuscleMap.Back.LatissimusDorsi()"
        case .backLowerBack: "MuscleMap.Back.LowerBack()"
        case .backTeresMajor: "MuscleMap.Back.TeresMajor()"
        case .backThighs: "MuscleMap.Back.Thighs()"
        case .backTrapezius: "MuscleMap.Back.Trapezius()"
        case .backTriceps: "MuscleMap.Back.Triceps()"
        }
    }
    func path(in rect: CGRect) -> Path {
        switch self {
        case .frontAbdominals: MuscleMap.Front.Abdominals().path(in: rect)
        case .frontBiceps: MuscleMap.Front.Biceps().path(in: rect)
        case .frontCalves: MuscleMap.Front.Calves().path(in: rect)
        case .frontContour: MuscleMap.Front.Contour().path(in: rect)
        case .frontDeltoid: MuscleMap.Front.Deltoid().path(in: rect)
        case .frontExternalOblique: MuscleMap.Front.ExternalOblique().path(in: rect)
        case .frontForearms: MuscleMap.Front.Forearms().path(in: rect)
        case .frontHands: MuscleMap.Front.Hands().path(in: rect)
        case .frontHead: MuscleMap.Front.Head().path(in: rect)
        case .frontHips: MuscleMap.Front.Hips().path(in: rect)
        case .frontNeck: MuscleMap.Front.Neck().path(in: rect)
        case .frontPectoralisMajor: MuscleMap.Front.PectoralisMajor().path(in: rect)
        case .frontQuadriceps: MuscleMap.Front.Quadriceps().path(in: rect)
        case .frontTibiaAndFoot: MuscleMap.Front.TibiaAndFoot().path(in: rect)
        case .frontTibialisAnterior: MuscleMap.Front.TibialisAnterior().path(in: rect)
        case .frontTrapezius: MuscleMap.Front.Trapezius().path(in: rect)
        case .backCalves: MuscleMap.Back.Calves().path(in: rect)
        case .backContour: MuscleMap.Back.Contour().path(in: rect)
        case .backDeltoid: MuscleMap.Back.Deltoid().path(in: rect)
        case .backFoot: MuscleMap.Back.Foot().path(in: rect)
        case .backForearms: MuscleMap.Back.Forearms().path(in: rect)
        case .backGluteus: MuscleMap.Back.Gluteus().path(in: rect)
        case .backHamstrings: MuscleMap.Back.Hamstrings().path(in: rect)
        case .backHands: MuscleMap.Back.Hands().path(in: rect)
        case .backHead: MuscleMap.Back.Head().path(in: rect)
        case .backInfraspinatus: MuscleMap.Back.Infraspinatus().path(in: rect)
        case .backLatissimusDorsi: MuscleMap.Back.LatissimusDorsi().path(in: rect)
        case .backLowerBack: MuscleMap.Back.LowerBack().path(in: rect)
        case .backTeresMajor: MuscleMap.Back.TeresMajor().path(in: rect)
        case .backThighs: MuscleMap.Back.Thighs().path(in: rect)
        case .backTrapezius: MuscleMap.Back.Trapezius().path(in: rect)
        case .backTriceps: MuscleMap.Back.Triceps().path(in: rect)
        }
    }
}

/// Fits the original anatomical path for an isolated preview. The source geometry stays unchanged.
struct FittedMuscleShape: Shape {
    let sample: MuscleShapeSample
    func path(in rect: CGRect) -> Path {
        let source = sample.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        let bounds = source.boundingRect
        let target = rect.insetBy(dx: 8, dy: 8)
        guard bounds.width > 0, bounds.height > 0, target.width > 0, target.height > 0 else { return Path() }
        let scale = min(target.width / bounds.width, target.height / bounds.height)
        return source.applying(CGAffineTransform(a: scale, b: 0, c: 0, d: scale,
            tx: target.midX - bounds.midX * scale, ty: target.midY - bounds.midY * scale))
    }
}

struct MuscleShapePreview: View {
    let sample: MuscleShapeSample
    var appearance = MuscleAppearance.linear
    var body: some View {
        let shape = FittedMuscleShape(sample: sample)
        let style = appearance.style
        ZStack {
            if style.gradientColors.count > 1 {
                if style.gradientKind == .radial {
                    shape.fill(RadialGradient(colors: style.gradientColors, center: .center,
                                              startRadius: 0, endRadius: style.gradientRadius))
                } else {
                    shape.fill(LinearGradient(colors: style.gradientColors,
                                              startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            } else { shape.fill(style.fillColor) }
            shape.stroke(style.strokeColor, lineWidth: style.lineWidth)
        }
    }
}

struct MuscleShapeExampleView: View {
    let sample: MuscleShapeSample
    @State var appearance = MuscleAppearance.linear
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Use this anatomical vector on its own: in a workout card, a detail screen or a custom body composition.")
                    .foregroundStyle(.secondary)
                ExampleCard(sample.rawValue, detail: "Isolated preview, fitted without changing the anatomical proportions.") {
                    MuscleShapePreview(sample: sample, appearance: appearance).frame(height: 240)
                }
                Picker("Muscle shape style", selection: $appearance) {
                    ForEach(MuscleAppearance.allCases) { Text($0.rawValue).tag($0) }
                }
                ExampleCode(code: "let shape = " + sample.constructor + "\nshape" + appearance.shapeModifiers + "\n    .frame(width: 280, height: 280)")
                Text("Individual shapes use the map's coordinate system. This playground fits the path bounds for the isolated preview; keep the original coordinates when composing a body map.")
                    .font(.caption).foregroundStyle(.secondary)
            }.padding()
        }
    }
}

struct MuscleAtlasExampleView: View {
    let front: Bool
    private var samples: [MuscleShapeSample] { MuscleShapeSample.allCases.filter { $0.isFront == front } }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(front ? "Every front-side vector." : "Every back-side vector.").font(.title2.bold())
                Text("Each named shape is public. Open a tile for its own preview, styling controls and SwiftUI example.")
                    .foregroundStyle(.secondary)
                ForEach(0..<((samples.count + 1) / 2), id: \.self) { row in
                    HStack(alignment: .top, spacing: 12) {
                        tile(samples[row * 2])
                        if row * 2 + 1 < samples.count { tile(samples[row * 2 + 1]) }
                    }
                }
            }.padding()
        }
    }
    private func tile(_ sample: MuscleShapeSample) -> some View {
        NavigationLink(value: ContentView.Demo.anatomy(sample)) {
            VStack(spacing: 12) {
                MuscleShapePreview(sample: sample).frame(height: 110)
                Text(sample.rawValue).font(.caption.bold()).foregroundStyle(.primary)
            }
            .padding(12).frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
        }.buttonStyle(.plain)
    }
}
