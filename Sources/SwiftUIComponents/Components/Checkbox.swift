import SwiftUI

/// A checkbox indicator, or an interactive checkbox when initialized with a binding.
public struct Checkbox: View {
    @Environment(\.isEnabled) var isEnabled
    private let checked: Bool
    private let binding: Binding<Bool>?
    private let label: String?
    private var isFilled = true

    public init(checked: Bool) {
        self.checked = checked
        self.binding = nil
        self.label = nil
    }

    public init(label: String, checked: Bool) {
        self.checked = checked
        self.binding = nil
        self.label = label
    }

    public init(checked: Binding<Bool>) {
        self.checked = false
        self.binding = checked
        self.label = nil
    }

    public init(label: String, checked: Binding<Bool>) {
        self.checked = false
        self.binding = checked
        self.label = label
    }

    private var isChecked: Bool { binding?.wrappedValue ?? checked }

    public var body: some View {
        Group {
            if let binding {
                Button { binding.wrappedValue.toggle() } label: { indicator }
                    .buttonStyle(.plain)
            } else {
                indicator
            }
        }
        .componentAccessibilityChildren(.ignore)
        .accessibilityLabel(Text(label ?? "Checkbox"))
        .accessibilityValue(Text(isChecked ? "Checked" : "Unchecked"))
        .accessibilityAddTraits(isChecked ? .isSelected : .componentEmpty)
    }

    private var indicator: some View {
        GeometryReader { proxy in
            let width = min(proxy.size.width, proxy.size.height)
            HStack {
                ZStack {
                    if isChecked && isFilled {
                        FilledCheckbox().fill(.foreground, style: FillStyle(eoFill: true))
                    } else {
                        RoundedRectangle(cornerRadius: width * 0.125)
                            .strokeBorder(.foreground, lineWidth: width * 0.125)
                        if isChecked { Tick().fill(.foreground).padding(width * 0.2) }
                    }
                }
                .frame(width: width, height: width)
                if let label { Text(label) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .componentHitArea(Rectangle())
        .opacity(isEnabled ? 1 : 0.4)
    }

    public func stroked() -> Self {
        var view = self
        view.isFilled = false
        return view
    }
}

/// One vector fill draws both the box and its cutout, without a mask layer.
struct FilledCheckbox: Shape {
    func path(in rect: CGRect) -> Path {
        let width = min(rect.width, rect.height)
        var path = RoundedRectangle(cornerRadius: width * 0.125).path(in: rect)
        path.addPath(Tick().path(in: rect.insetBy(dx: width * 0.2, dy: width * 0.2)))
        return path
    }
}
