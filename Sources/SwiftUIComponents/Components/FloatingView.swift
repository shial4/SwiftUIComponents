import SwiftUI

class FloatingViewModel: ObservableObject {
    static let shared = FloatingViewModel()
    @Published var builders: [UUID: () -> AnyView] = [:]
    
    func addBuilder(_ builder: @escaping () -> AnyView, for id: UUID) {
        builders[id] = builder
    }
    
    func removeBuilder(for id: UUID) {
        builders.removeValue(forKey: id)
    }
}

struct FloatingViewContainer: ViewModifier {
    @StateObject var viewModel = FloatingViewModel.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ForEach(Array(viewModel.builders.keys.enumerated()), id: \.element.uuidString) { index, key in
                viewModel.builders[key]!()
                    .padding()
                    .background(.quaternary, in: Capsule())
                    .shadow(radius: 5)
                    .offset(x: CGFloat(index * 20), y: CGFloat(index * 20)) // Offset to avoid overlap
            }
        }
    }
}

struct FloatingViewModifier: ViewModifier {
    @State var uuid = UUID()
    
    let builder: () -> AnyView
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                FloatingViewModel.shared.addBuilder(builder, for: uuid)
            }
            .onDisappear {
                FloatingViewModel.shared.removeBuilder(for: uuid)
            }
    }
}

public extension View {
    func registerFloatContainer() -> some View {
        self.modifier(FloatingViewContainer())
    }
    
    func floating(_ builder: @escaping () -> some View) -> some View {
        let wrappedBuilder: () -> AnyView = { AnyView(builder()) }
        return self.modifier(FloatingViewModifier(builder: wrappedBuilder))
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(FloatingViewContainer())
}
