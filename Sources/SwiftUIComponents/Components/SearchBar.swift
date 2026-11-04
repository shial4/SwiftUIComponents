import SwiftUI

/// An inline search field with a clear-and-dismiss button while focused or nonempty.
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
        let inputText = Self.inputBinding($text, isCurrent: { inputID == currentInputID })
        let showsClear = isFocused || !text.isEmpty
        return TextField(prompt, text: inputText)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .id(inputID)
            .padding(10)
            .padding(.trailing, showsClear ? 28 : 0)
            .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            .accessibilityLabel(Text(prompt))
            .overlay(alignment: .trailing) {
                if showsClear {
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

    static func inputBinding(_ source: Binding<String>, isCurrent: @escaping @MainActor () -> Bool) -> Binding<String> {
        func write(_ value: String, to binding: Binding<String>) {
            // A dismissed keyboard can commit its composition after Clear.
            guard isCurrent() else { return }
            binding.wrappedValue = value
        }
        #if os(Android)
        // SkipFuseUI does not expose transaction-aware binding setters.
        return Binding(get: { source.wrappedValue }, set: { write($0, to: source) })
        #else
        return Binding(get: { source.wrappedValue }, set: { value, transaction in
            withTransaction(transaction) { write(value, to: source.transaction(transaction)) }
        })
        #endif
    }
}
