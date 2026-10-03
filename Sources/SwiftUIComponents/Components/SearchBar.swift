import SwiftUI

/// An inline search field with a clear-and-dismiss button while focused.
public struct SearchBar: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    private let prompt: String

    public init(text: Binding<String>, prompt: String = "Search...") {
        self._text = text
        self.prompt = prompt
    }

    public var body: some View {
        TextField(prompt, text: $text)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .padding(10)
            .padding(.trailing, isFocused ? 28 : 0)
            .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            .accessibilityLabel(Text(prompt))
            .overlay(alignment: .trailing) {
                if isFocused {
                    Button("Clear search", systemImage: "xmark") {
                        // Let the native editor commit before resetting its binding.
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
