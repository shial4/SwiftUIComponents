import SwiftUI

/// A checkbox view with optional label.
public struct Checkbox: View {
#if !SKIP
    @Namespace private var animation
#endif
    @Environment(\.isEnabled) private var isEnabled
    private var checked: Bool
    private var isFilled: Bool = true
    private let label: String?
    
    /// Creates a checkbox with the specified checked state.
    ///
    /// - Parameter checked: A Boolean value indicating whether the checkbox is checked.
    public init(checked: Bool) {
        self.checked = checked
        self.label = nil
    }
    
    /// Creates a checkbox with the specified label and checked state.
    ///
    /// - Parameters:
    ///   - label: The label text associated with the checkbox.
    ///   - checked: A Boolean value indicating whether the checkbox is checked.
    public init(label: String, checked: Bool) {
        self.checked = checked
        self.label = label
    }
    
    public var body: some View {
        let result = HStack {
            GeometryReader { proxy in
                if checked {
                    if isFilled {
                        RoundedRectangle(cornerRadius: proxy.size.height * 0.125)
                            .fill(ForegroundStyle.foreground)
                            .reverseMask {
                                Tick(thickness: 0.125)
                                    .stroke(ForegroundStyle.foreground,
                                            style: StrokeStyle(lineWidth: proxy.size.height * 0.125,
                                                               lineCap: CGLineCap.round,
                                                               lineJoin: CGLineJoin.round))
                            }
                            .opacity(isEnabled ? 1 : 0.4)
#if !SKIP
                            .matchedGeometryEffect(id: "color", in: animation)
#endif
                    } else {
                        RoundedRectangle(cornerRadius: proxy.size.height * 0.125)
                            .strokeBorder(ForegroundStyle.foreground, lineWidth: proxy.size.height * 0.125)
                        Tick(thickness: 0.125)
                            .stroke(ForegroundStyle.foreground,
                                    style: StrokeStyle(lineWidth: proxy.size.height * 0.125,
                                                       lineCap: CGLineCap.round, 
                                                       lineJoin: CGLineJoin.round))
                            .opacity(isEnabled ? 1 : 0.4)
#if !SKIP
                            .matchedGeometryEffect(id: "color", in: animation)
#endif
                    }
                } else {
                    RoundedRectangle(cornerRadius: proxy.size.height * 0.125)
                        .strokeBorder(ForegroundStyle.foreground, lineWidth: proxy.size.height * 0.125)
                        .opacity(isEnabled ? 1 : 0.4)
#if !SKIP
                        .matchedGeometryEffect(id: "color", in: animation)
#endif
                }
            }
            .aspectRatio(1, contentMode: ContentMode.fit)
            .contentShape(Rectangle())
            
            if let label {
                Text(label)
                    .lineLimit(1)
                    .opacity(isEnabled ? 1 : 0.4)
            }
        }
        return result
    }
}

extension Checkbox {
    /// Returns a checkbox with a stroked appearance.
    ///
    /// - Returns: A modified checkbox with a stroked appearance.
    public func stroked() -> Self {
        var view = self
        view.isFilled = false
        return view
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 25) {
            Checkbox(checked: true)
            Checkbox(checked: true)
                .frame(height: 50)
                .foregroundStyle(.red)
            Checkbox(checked: false)
                .frame(height: 50)
                .foregroundColor(.blue)
            
            Checkbox(label: "Text", checked: true)
                .frame(height: 50)
            Checkbox(label: "Text", checked: false)
                .frame(height: 50)
            
            Checkbox(checked: true)
                .disabled(true)
                .frame(height: 50)
            Checkbox(checked: false)
                .disabled(true)
                .frame(height: 50)
            
            Checkbox(label: "Disabled", checked: true)
                .disabled(true)
                .frame(height: 50)
            Checkbox(label: "Disabled", checked: false)
                .disabled(true)
                .frame(height: 50)
        }
    }
}
