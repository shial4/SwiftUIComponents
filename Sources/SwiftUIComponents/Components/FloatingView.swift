import SwiftUI


class FloatingViewModel: ObservableObject {
    static let shared = FloatingViewModel()
    @Published var builders: [UUID: () -> AnyView] = [:]
    
    func add(for id: UUID, builder: @escaping () -> AnyView) {
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
                if let builder = viewModel.builders[key] {
                    builder()
                }
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
                FloatingViewModel.shared.add(for: uuid, builder: builder)
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
    
    func floating(alignment: Alignment = .center, _ builder: @escaping () -> some View) -> some View {
        let wrappedBuilder: () -> AnyView = { AnyView(builder()) }
        return self.modifier(
            FloatingViewModifier(
                builder: wrappedBuilder
            )
        )
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(FloatingViewContainer())
}
