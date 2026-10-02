import SwiftUI
import SwiftUIComponents

struct JoystickExampleView: View {
    @State var translation = CGPoint.zero
    @State var customized = true
    var body: some View {
        VStack(spacing: 24) {
            Text("Drag the grip. It returns to the center when released.")
            Toggle("Custom colors", isOn: $customized)
            JoystickView(translation: $translation)
                .accentColor(customized ? .purple : .black)
                .gripColor(customized ? .orange : .white)
                .frame(width: 220, height: 220)
            Text("x: \(translation.x, specifier: "%.1f"), y: \(translation.y, specifier: "%.1f") points")
                .font(.system(.body, design: .monospaced))
            Circle().fill(.blue).frame(width: 24, height: 24)
                .offset(x: translation.x / 4, y: translation.y / 4)
            Spacer()
        }.padding()
    }
}

struct SearchExampleView: View {
    @State var query = ""
    private let words = ["Calendar", "DynamicList", "Muscle Map", "Joystick", "Rating", "Checkbox"]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SearchBar(text: $query, prompt: "Find a component")
            Text("Query: " + query).font(.caption).foregroundStyle(.secondary)
            List(words.filter { query.isEmpty || $0.localizedCaseInsensitiveContains(query) }, id: \.self) { Text($0) }
        }.padding()
    }
}

private struct DemoPreferences: Codable {
    var favorite = "Calendar"
    var showDetails = true
}

struct StorageExampleView: View {
    @CodableAppStorage("catalog.preferences") private var preferences = DemoPreferences()
    @CodableAppStorage("catalog.preferences") private var secondReader = DemoPreferences()
    var body: some View {
        Form {
            Text("Settings are encoded as JSON. Both wrappers observe the same key and survive app restarts.")
            Picker("Favorite component", selection: $preferences.favorite) {
                ForEach(ContentView.Demo.allCases) { Text($0.rawValue).tag($0.rawValue) }
            }
            Toggle("Show details", isOn: $preferences.showDetails)
            Text("Second reader: " + secondReader.favorite)
            Text(secondReader.showDetails ? "Details enabled" : "Details disabled")
            Button("Reset") { preferences = DemoPreferences() }
        }
    }
}
