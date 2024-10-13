import SwiftUI

public struct SearchBar: View {
    enum FocusedField {
        case search
    }
    
    @Binding var text: String
    @FocusState private var focusedField: FocusedField?
    
    let prompt: String

    var isEditing: Bool {
        focusedField == .search
    }
    
    public init(text: Binding<String>, prompt: String = "Search...") {
        self._text = text
        self.prompt = prompt
    }
    
    public var body: some View {
        TextField(prompt, text: $text)
            .padding(8)
            .padding(Edge.Set.leading, 8)
            .padding(Edge.Set.trailing, 34)
            .background(Color.gray)
            .cornerRadius(8)
            .overlay(alignment: Alignment.trailing) {
                if isEditing {
                    Button(action: {
                        withAnimation {
                            self.text = ""
                            self.focusedField = nil
                        }
                    }) {
                        XMark()
                            .stroke(Color.black)
                            .padding(8)
                            .frame(width: 28, height: 28)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(Edge.Set.trailing, 10)
                    .transition(AnyTransition.move(edge: Edge.trailing))
                }
            }
            .padding(Edge.Set.horizontal, 10)
            .focused($focusedField, equals: FocusedField.search)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
