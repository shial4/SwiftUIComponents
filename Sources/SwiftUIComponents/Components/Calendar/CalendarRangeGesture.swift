import SwiftUI

/// Day grids own range drags; surrounding headings and gutters remain scrollable.
@available(tvOS, unavailable)
struct CalendarRangeGesture: ViewModifier {
    let isEnabled: Bool
    let onTap: (CGPoint) -> Void
    let onDrag: (DragGesture.Value) -> Void
    private let minimumDistance: CGFloat = 4
    #if os(Android)
    @State var isDragging = false
    #endif

    func body(content: Content) -> some View {
        #if os(Android)
        // Consuming the touch prevents the parent ScrollView from moving the dates
        // during selection. Zero distance also preserves Skip's original touchdown.
        // This consumes button taps too, so dispatch them through the same selection rule.
        content.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                if !isDragging && hasMoved(value) { isDragging = true }
                if isDragging { onDrag(value) }
            }
            .onEnded { value in
                if isDragging || hasMoved(value) {
                    onDrag(value)
                } else {
                    onTap(value.location)
                }
                if isDragging { isDragging = false }
            }, isEnabled: isEnabled)
        #else
        content.highPriorityGesture(DragGesture(minimumDistance: minimumDistance, coordinateSpace: .global)
            .onChanged(onDrag).onEnded(onDrag), isEnabled: isEnabled)
        #endif
    }

    private func hasMoved(_ value: DragGesture.Value) -> Bool {
        hypot(value.translation.width, value.translation.height) >= minimumDistance
    }
}
