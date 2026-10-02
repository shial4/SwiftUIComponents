import SwiftUI

/// A spring-return joystick. The binding reports the raw drag translation in points;
/// the visible grip is constrained to the control's circular travel area.
public struct JoystickView: View {
    @Binding public var translation: CGPoint
    private var gripColor: Color = .white
    private var controlColor: Color = .black

    public init(translation: Binding<CGPoint>) { self._translation = translation }

    public var body: some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let grip = Self.constrained(translation, radius: diameter / 4)
            Circle()
                .stroke(controlColor.opacity(0.4), lineWidth: 1)
                .background(Circle().fill(controlColor.opacity(0.2)))
                .overlay {
                    Circle().fill(gripColor)
                        .overlay(Circle().stroke(controlColor, lineWidth: 1))
                        .frame(width: diameter / 2, height: diameter / 2)
                        .offset(x: grip.x, y: grip.y)
                }
                .componentHitArea(Circle())
                #if os(tvOS)
                .focusable()
                .onMoveCommand { direction in
                    switch direction {
                    case .left: translation.x -= 10
                    case .right: translation.x += 10
                    case .up: translation.y -= 10
                    case .down: translation.y += 10
                    @unknown default: break
                    }
                }
                .onExitCommand { translation = .zero }
                #else
                .gesture(DragGesture()
                    .onChanged { translation = CGPoint(x: $0.translation.width, y: $0.translation.height) }
                    .onEnded { _ in translation = .zero })
                #endif
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityLabel("Joystick")
        .accessibilityValue("Horizontal \(translation.x), vertical \(translation.y)")
    }

    static func constrained(_ point: CGPoint, radius: Double) -> CGPoint {
        guard point.x.isFinite, point.y.isFinite, radius.isFinite, radius > 0 else { return .zero }
        let distance = hypot(point.x, point.y)
        guard distance > radius else { return point }
        return CGPoint(x: point.x / distance * radius, y: point.y / distance * radius)
    }

    public func gripColor(_ color: Color) -> Self {
        var view = self
        view.gripColor = color
        return view
    }

    public func accentColor(_ color: Color) -> Self {
        var view = self
        view.controlColor = color
        return view
    }

    @available(*, deprecated, renamed: "accentColor(_:)")
    public func accetColor(_ color: Color) -> Self { accentColor(color) }
}
