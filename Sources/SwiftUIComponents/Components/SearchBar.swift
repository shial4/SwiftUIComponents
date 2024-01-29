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
            .padding(.leading, 8)
            .padding(.trailing, 34)
            .background(Color.gray)
            .cornerRadius(8)
            .overlay(alignment: .trailing) {
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
                    .padding(.trailing, 10)
                    .transition(AnyTransition.move(edge: Edge.trailing))
                }
            }
            .padding(.horizontal, 10)
            .focused($focusedField, equals: FocusedField.search)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
