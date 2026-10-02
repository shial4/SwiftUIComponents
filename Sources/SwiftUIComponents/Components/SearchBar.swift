import SwiftUI

/// An inline search field with a clear-and-dismiss button while focused.
public struct SearchBar: View {
    @Binding private var text: String
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
            .overlay(alignment: .trailing) {
                if isFocused {
                    Button("Clear search", systemImage: "xmark") {
                        text = ""
                        isFocused = false
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                }
            }
            .accessibilityLabel(Text(prompt))
    }
}
