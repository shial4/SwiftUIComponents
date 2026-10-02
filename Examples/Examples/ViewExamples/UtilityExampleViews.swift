import Observation
#if os(Android)
import SkipFuse
#endif
import SwiftUI
import SwiftUIComponents

enum UtilitySample: String, CaseIterable, Identifiable {
    case bindings = "Key-path Bindings", dates = "Date and TimeRange", json = "UserDefaults JSON"
    case vector = "Custom Muscle Vector"
    var id: Self { self }
}

@MainActor @Observable final class ExampleSettings {
    var enabled = true
    var label = "Training dashboard"
}

struct KeyPathBindingExampleView: View {
    @State var settings = ExampleSettings()
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Connect controls to a reference owner's properties without copying its state.")
                    .foregroundStyle(.secondary)
                ExampleCard("One owner, two bindings") {
                    Toggle("Enable dashboard", isOn: Binding(for: \.enabled, on: settings))
                    TextField("Dashboard title", text: Binding.create(for: \.label, on: settings))
                        .textFieldStyle(.roundedBorder)
                    Text(settings.label).font(.title3.bold())
                    Text(settings.enabled ? "Dashboard enabled" : "Dashboard disabled")
                        .foregroundStyle(settings.enabled ? .blue : .secondary)
                }
                ExampleCode(code: "Toggle(\"Enabled\", isOn: Binding(for: \\.enabled, on: settings))\nTextField(\"Title\", text: Binding.create(for: \\.label, on: settings))")
            }.padding()
        }
    }
}

struct DateHelpersExampleView: View {
    @State var date = Date()
    @State var days = 5
    private var calendar: Calendar { .current }
    private var range: TimeRange {
        TimeRange(start: date.normalized(calendar),
                  end: calendar.date(byAdding: .day, value: days, to: date.normalized(calendar)) ?? date)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Keep day comparisons, month changes and inclusive date ranges calendar-aware.")
                    .foregroundStyle(.secondary)
                ExampleCard("Your date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Text(date.dateString(calendar)).font(.title2.bold())
                    Text("Year \(date.year(calendar)), month \(date.month(calendar)), day \(date.day(calendar))")
                    Text("Weekday \(date.weekday(calendar)); month starts on \(date.firstWeekday(calendar))")
                    Text("Time: " + date.timeString(calendar))
                    Text(date.isInCurrentWeek(calendar: calendar) ? "In the current week" : "Outside the current week")
                    Text(date.isInCurrentMonth(calendar: calendar) ? "In the current month" : "Outside the current month")
                    Text(date.isInCurrentYear(calendar: calendar) ? "In the current year" : "Outside the current year")
                }
                Stepper("Range span: \(days) days", value: $days, in: 0...14)
                ExampleCard("An inclusive TimeRange") {
                    Text("\(range.toArray(calendar: calendar).count) calendar days, including both endpoints")
                    Text("Span: \(range.span(calendar: calendar)) days")
                    Text(range.contains(date.normalized(calendar)) ? "Contains the starting day" : "Outside range")
                    Text("Same day after normalization: \(date.compareDate(date.normalized(calendar), calendar: calendar) ? "yes" : "no")")
                    Button("Shift to February") { date = date.shiftToMonth(2, calendar: calendar) }
                }
                ExampleCode(code: "let start = date.normalized(calendar)\nlet range = TimeRange(start: start, end: end)\nlet days = range.toArray(calendar: calendar)\nlet span = range.span(calendar: calendar)\nlet sameDay = date.compareDate(otherDate, calendar: calendar)")
            }.padding()
        }
    }
}

private struct SavedRegions: Codable { var names: [String] }

struct JSONStorageExampleView: View {
    @State var loaded: [String] = []
    @State var status = "Save a selection, then read it back."
    private let key = "catalog.manualJSON"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Use JSON persistence directly when you do not need a property wrapper.")
                    .foregroundStyle(.secondary)
                ExampleCard("A saved muscle selection") {
                    Text(status).font(.headline)
                    Text(loaded.isEmpty ? "No loaded regions" : loaded.joined(separator: ", "))
                    HStack {
                        Button("Save JSON") {
                            UserDefaults.standard.setCodable(SavedRegions(names: ["biceps", "quadriceps"]), forKey: key)
                            status = "Selection saved"
                        }
                        Button("Load JSON") {
                            let value: SavedRegions? = UserDefaults.standard.codable(forKey: key)
                            loaded = value?.names ?? []
                            status = value == nil ? "No saved selection" : "Selection loaded"
                        }
                    }.buttonStyle(.bordered)
                    Button("Remove JSON") {
                        UserDefaults.standard.setCodable(Optional<SavedRegions>.none, forKey: key)
                        loaded = []; status = "Selection removed"
                    }
                }
                ExampleCode(code: "defaults.setCodable(selection, forKey: \"selection\")\nlet loaded: Selection? = defaults.codable(forKey: \"selection\")\ndefaults.setCodable(Optional<Selection>.none, forKey: \"selection\")")
            }.padding()
        }
    }
}

nonisolated struct CustomMuscleVector: MuscleMapShape {
    var translationX: Double { 0 }
    func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
        [MuscleMapVectorPath { path in
            path.move(to: CGPoint(x: 5 * width, y: 9 * height))
            path.addCurve(to: CGPoint(x: 8 * width, y: 5 * height),
                          control1: CGPoint(x: 9 * width, y: 8 * height),
                          control2: CGPoint(x: 8 * width, y: 7 * height))
            path.addLine(to: CGPoint(x: 5 * width, y: height))
            path.addCurve(to: CGPoint(x: 2 * width, y: 5 * height),
                          control1: CGPoint(x: 4 * width, y: 2 * height),
                          control2: CGPoint(x: width, y: 3 * height))
            path.addCurve(to: CGPoint(x: 5 * width, y: 9 * height),
                          control1: CGPoint(x: 2 * width, y: 7 * height),
                          control2: CGPoint(x: 3 * width, y: 8 * height))
            path.closeSubpath()
        }]
    }
}

struct CustomMuscleVectorExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Build your own vector with the public path builder, then reuse the same fill, gradient and border APIs.")
                    .foregroundStyle(.secondary)
                ExampleCard("Your own vector") {
                    CustomMuscleVector()
                        .fill(.init(gradientColors: [.cyan, .blue, .purple], strokeColor: .blue, lineWidth: 2))
                        .frame(height: 240)
                }
                ExampleCode(code: "struct CustomVector: MuscleMapShape {\n    var translationX: Double { 0 }\n    func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {\n        [MuscleMapVectorPath { path in\n            path.move(to: start)\n            path.addCurve(to: end, control1: c1, control2: c2)\n            path.addLine(to: corner)\n            path.closeSubpath()\n        }]\n    }\n}")
            }.padding()
        }
    }
}
