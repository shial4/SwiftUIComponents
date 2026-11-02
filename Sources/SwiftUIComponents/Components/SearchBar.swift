import SwiftUI

/// An inline search field with a clear-and-dismiss button while focused.
public struct SearchBar: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    @State var inputID = UUID()
    private let prompt: String

    public init(text: Binding<String>, prompt: String = "Search...") {
        self._text = text
        self.prompt = prompt
    }

    public var body: some View {
        let currentInputID = inputID
        let inputText = Binding(get: { text }, set: { value in
            // A dismissed keyboard can commit its composition after Clear.
            guard inputID == currentInputID else { return }
            text = value
        })
        return TextField(prompt, text: inputText)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .id(inputID)
            .padding(10)
            .padding(.trailing, isFocused ? 28 : 0)
            .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            .accessibilityLabel(Text(prompt))
            .overlay(alignment: .trailing) {
                if isFocused {
                    Button("Clear search", systemImage: "xmark") {
                        // Retire the old editor before dismissing its keyboard.
                        inputID = UUID()
                        isFocused = false
                        componentDismissKeyboard()
                        text = ""
                    }
                    .labelStyle(.iconOnly)
                    .accessibilityLabel("Clear search")
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                }
            }
    }
}
