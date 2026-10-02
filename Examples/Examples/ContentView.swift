import SwiftUI
import SwiftUIComponents

/// The searchable catalogue is the first screen on every platform.
struct ContentView: View {
    @State var path: [Demo] = []
    @State var query = ""

    init(initialDemo: Demo? = nil) {
        _path = State(initialValue: initialDemo.map { [$0] } ?? [])
    }

    enum Category: String, CaseIterable, Identifiable {
        case components = "Components", muscleMap = "Muscle Map tours", shapes = "Shapes"
        case modifiers = "Modifiers and layout", calendar = "Calendar building blocks"
        case integrations = "Bindings and persistence", front = "Front anatomical shapes", back = "Back anatomical shapes"
        var id: Self { self }
    }

    enum Demo: CaseIterable, Identifiable, Hashable {
        case muscleMap, calendar, dynamicList, checkbox, rating, badge, countingLabel
        case progress, joystick, search, shapes, modifiers, storage
        case muscleStyles, muscleRegions, muscleDrag, frontAtlas, backAtlas, frontView, backView
        case muscleAppearance(MuscleAppearance)
        case shape(ShapeSample), modifier(ModifierSample), calendarPart(CalendarPartSample)
        case utility(UtilitySample), anatomy(MuscleShapeSample)

        static var allCases: [Self] {
            [.muscleMap, .calendar, .dynamicList, .checkbox, .rating, .badge, .countingLabel,
             .progress, .joystick, .search, .shapes, .modifiers, .storage,
             .muscleStyles, .muscleRegions, .muscleDrag, .frontAtlas, .backAtlas, .frontView, .backView]
            + MuscleAppearance.allCases.map(Self.muscleAppearance)
            + ShapeSample.allCases.map(Self.shape)
            + ModifierSample.allCases.map(Self.modifier)
            + CalendarPartSample.allCases.map(Self.calendarPart)
            + UtilitySample.allCases.map(Self.utility)
            + MuscleShapeSample.allCases.map(Self.anatomy)
        }
        init?(rawValue: String) {
            guard let demo = Self.allCases.first(where: { $0.rawValue == rawValue }) else { return nil }
            self = demo
        }
        var id: Self { self }
        var rawValue: String {
            switch self {
            case .muscleMap: "Muscle Map"
            case .calendar: "Calendar"
            case .dynamicList: "DynamicList"
            case .checkbox: "Checkbox"
            case .rating: "Rating"
            case .badge: "Badges"
            case .countingLabel: "Counting Label"
            case .progress: "Progress"
            case .joystick: "Joystick"
            case .search: "Search Bar"
            case .shapes: "Shapes"
            case .modifiers: "Modifiers"
            case .storage: "Codable Storage"
            case .muscleStyles: "Muscle Map Styles"
            case .muscleRegions: "Muscle Map Regions"
            case .muscleDrag: "Muscle Map Drag"
            case .frontAtlas: "Front Muscle Atlas"
            case .backAtlas: "Back Muscle Atlas"
            case .frontView: "MuscleMap.Front"
            case .backView: "MuscleMap.Back"
            case .muscleAppearance(let appearance): "Muscle " + appearance.rawValue.capitalized
            case .shape(let sample): sample.rawValue
            case .modifier(let sample): sample.rawValue
            case .calendarPart(let sample): sample.rawValue
            case .utility(let sample): sample.rawValue
            case .anatomy(let sample): sample.rawValue
            }
        }
        var category: Category {
            switch self {
            case .muscleStyles, .muscleRegions, .muscleDrag, .frontAtlas, .backAtlas, .frontView, .backView, .muscleAppearance: .muscleMap
            case .shape: .shapes
            case .modifier: .modifiers
            case .calendarPart: .calendar
            case .utility: .integrations
            case .anatomy(let sample): sample.isFront ? .front : .back
            default: .components
            }
        }
        var detail: String {
            switch self {
            case .muscleMap: "Anatomy, highlighting, gradients and tap selection"
            case .calendar: "Week, month, year, events and date ranges"
            case .dynamicList: "Lazy cells, both axes and programmatic scrolling"
            case .checkbox: "Indicators and interactive bound checkboxes"
            case .rating: "Fractional ratings and whole-star input"
            case .badge: "Counts, custom labels and corner placement"
            case .countingLabel: "Animated numbers embedded in text"
            case .progress: "Shape-based progress and custom strokes"
            case .joystick: "Drag translation and spring return"
            case .search: "Inline search, filtering and focus"
            case .shapes: "A gallery linking to every shape's playground"
            case .modifiers: "Every modifier and layout helper, one playground each"
            case .storage: "JSON persistence and synchronized bindings"
            case .muscleStyles: "Solid fills, outlines, gradients and borders"
            case .muscleRegions: "Front, back, both, upper, lower and one muscle"
            case .muscleDrag: "Paint and erase regions with tap or drag"
            case .frontAtlas: "All 16 front-side anatomical vectors"
            case .backAtlas: "All 16 back-side anatomical vectors"
            case .frontView, .backView: "A standalone side with caller-owned hit testing"
            case .muscleAppearance: "A complete body map with this fill and stroke treatment"
            case .shape(let sample): sample.detail
            case .modifier(let sample): sample.detail
            case .calendarPart(let sample): sample.detail
            case .utility(.bindings): "Reference-owned properties and live controls"
            case .utility(.dates): "Calendar-aware dates and inclusive ranges"
            case .utility(.json): "Save, load and remove Codable values directly"
            case .utility(.vector): "Build your own shape with the public vector builder"
            case .anatomy: "An isolated vector with fill, stroke and gradient controls"
            }
        }
    }

    private var matchingDemos: [Demo] {
        Demo.allCases.filter { query.isEmpty || $0.rawValue.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                SearchBar(text: $query, prompt: "Find an example").padding(.horizontal).padding(.top, 8)
                List {
                    Section {
                        Text("iOS + Android. Shared Swift with Skip Fuse.")
                            .font(.callout.bold()).foregroundStyle(.blue)
                        Text("\(Demo.allCases.count) runnable examples. See the result, change an option, copy the code.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    ForEach(matchingDemos) { demo in
                        NavigationLink(value: demo) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(demo.category.rawValue).font(.caption2).foregroundStyle(.blue)
                                Text(demo.rawValue).font(.headline)
                                Text(demo.detail).font(.caption).foregroundStyle(.secondary)
                            }.padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("SwiftUI Components")
            .navigationDestination(for: Demo.self) { demo in
                destination(demo).navigationTitle(demo.rawValue)
            }
        }
        #if os(macOS)
        .frame(minWidth: 480, minHeight: 640)
        #endif
    }

    @ViewBuilder func destination(_ demo: Demo) -> some View {
        switch demo {
        case .muscleMap: MuscleMapExampleView()
        case .calendar: CalendarExampleView()
        case .dynamicList: DynamicListExampleView()
        case .checkbox: CheckboxExampleView()
        case .rating: RatingExampleView()
        case .badge: BadgeExampleView()
        case .countingLabel: LabelExampleView()
        case .progress: ProgressExampleView()
        case .joystick: JoystickExampleView()
        case .search: SearchExampleView()
        case .shapes: ShapesExampleView()
        case .modifiers: ModifiersExampleView()
        case .storage: StorageExampleView()
        case .muscleStyles: MuscleMapStylesExampleView()
        case .muscleRegions: MuscleMapRegionsExampleView()
        case .muscleDrag: MuscleMapDragExampleView()
        case .frontAtlas: MuscleAtlasExampleView(front: true)
        case .backAtlas: MuscleAtlasExampleView(front: false)
        case .frontView: MuscleSideExampleView(front: true)
        case .backView: MuscleSideExampleView(front: false)
        case .muscleAppearance(let appearance): MuscleAppearanceExampleView(appearance: appearance)
        case .shape(let sample): ShapeExampleView(sample: sample)
        case .modifier(let sample): ModifierExampleView(sample: sample)
        case .calendarPart(let sample): CalendarPartExampleView(sample: sample)
        case .utility(.bindings): KeyPathBindingExampleView()
        case .utility(.dates): DateHelpersExampleView()
        case .utility(.json): JSONStorageExampleView()
        case .utility(.vector): CustomMuscleVectorExampleView()
        case .anatomy(let sample): MuscleShapeExampleView(sample: sample)
        }
    }
}

#if !os(Android)
#Preview { ContentView() }
#endif
