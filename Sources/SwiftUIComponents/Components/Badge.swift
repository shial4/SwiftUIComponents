import SwiftUI

/// A view modifier that adds a badge to a view.
public struct Badge: ViewModifier {
    @State private var badgeSize: CGSize = .zero 
    public var label: String
    public var color: Color
    public var alignment: Alignment
    
    private var normalizedAlignment: Alignment {
        switch alignment {
        case .bottomLeading,
             .bottomTrailing,
             .topTrailing,
             .topLeading:
            return alignment
        default:
            return .topTrailing
        }
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: normalizedAlignment) {
            content
            Text(label)
                .padding(.horizontal, 7)
                .background(Capsule().fill(color))
                .size(onChange: $badgeSize)
                .if(normalizedAlignment == .topTrailing) { view in
                    view.offset(x: badgeSize.width / 2, y: -badgeSize.height / 2)
                }
                .if(normalizedAlignment == .topLeading) { view in
                    view.offset(x: -badgeSize.width / 2, y: -badgeSize.height / 2)
                }
                .if(normalizedAlignment == .bottomTrailing) { view in
                    view.offset(x: badgeSize.width / 2, y: badgeSize.height / 2)
                }
                .if(normalizedAlignment == .bottomLeading) { view in
                    view.offset(x: -badgeSize.width / 2, y: badgeSize.height / 2)
                }
        }
    }
}

extension View {
    /// Adds a badge with a count value to the view.
    ///
    /// - Parameters:
    ///   - count: The count value displayed in the badge.
    ///   - max: The maximum value that will be displayed. If the count exceeds this value, the label will be formatted as "{max}+".
    ///   - color: The color of the badge.
    ///   - alignment: The alignment of the badge relative to the view.
    /// - Returns: The modified view with the badge.
    public func badge(count: UInt,
                      max: UInt = 99,
                      color: Color = .green, 
                      alignment: Alignment = .topTrailing) -> some View {
        let label: String
        if count > max {
            label = String(format: "%d+", max)
        } else {
            label = String(format: "%d", count)
        }
        return self.modifier(Badge(label: label, 
                            color: color, 
                            alignment: alignment))
    }
    
    /// Adds a badge with a custom label to the view.
    ///
    /// - Parameters:
    ///   - label: The custom label displayed in the badge.
    ///   - color: The color of the badge.
    ///   - alignment: The alignment of the badge relative to the view.
    /// - Returns: The modified view with the badge.
    public func badge(label: String, 
                      color: Color = .green, 
                      alignment: Alignment = .topTrailing) -> some View {
        self.modifier(Badge(label: label, 
                            color: color, 
                            alignment: alignment))
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            Star()
                .badge(label: "Hey", alignment: .bottomLeading)
            Star()
                .badge(label: "1", alignment: .bottomTrailing)
            Star()
                .badge(label: "99", alignment: .topLeading)
            Star()
                .badge(label: "99+", alignment: .topTrailing)
            Star()
                .badge(count: 999, alignment: .center)
            Star()
                .badge(count: 56, alignment: .topLeading)
        }.frame(width: 100, height: 100)
    }
}
