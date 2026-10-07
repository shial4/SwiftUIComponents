import SwiftUI
#if os(Android)
import SkipBridge
#endif

/// A native, lazily rendered scroll view with content-sized, index-addressed cells.
/// Supply `itemLength` or `itemLengths` to override SwiftUI's automatic cell sizing.
/// Bind `scrollToIndex` to request a cell; requests reset to nil after processing.
/// Observe native scrolling with `onVisibleCellChange`.
/// Apple-only `scrollOffset` overloads preserve the negative point-offset API.
/// Cell identity is its index. Use native `ForEach` when data needs model identity.
public struct DynamicList<Content: View>: View {
    @Binding private var scrollToIndex: Int?
    @State var reportedID: AnyHashable?
    #if !os(Android)
    @State var jumpTask: Task<Void, Never>?
    @State var arrivalIndex: Int?
    @State var visibleIndexIDs: Set<Int> = []
    @State var requestTransaction = DynamicListTransaction()
    @Binding private var scrollOffset: Double
    private var usesPointOffsets = false
    @State var position: ScrollPosition
    @State var viewport = DynamicListViewport()
    @State var pointOrientation: Orientation
    @State var initialPointOffset: Double?
    @State var visiblePointIDs: Set<Int> = []
    #endif
    private let numberOfItems: Int
    private let lengths: DynamicListLengths?
    private let cellBuilder: (Int) -> Content
    private var orientation: Orientation
    private var visibleCellChange: (Int?) -> Void = { _ in }

    /// Lets SwiftUI determine each cell's length from its content.
    public init(scrollToIndex: Binding<Int?> = .constant(nil), orientation: Orientation = .horizontal,
                numberOfItems: Int, @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollToIndex: scrollToIndex, orientation: orientation,
                  numberOfItems: numberOfItems, lengths: nil, viewForCell: viewForCell)
    }

    public init(scrollToIndex: Binding<Int?> = .constant(nil), orientation: Orientation = .horizontal,
                numberOfItems: Int, itemLength: Double,
                @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollToIndex: scrollToIndex, orientation: orientation,
                  numberOfItems: numberOfItems,
                  lengths: DynamicListLengths(count: numberOfItems, length: itemLength),
                  viewForCell: viewForCell)
    }

    public init(scrollToIndex: Binding<Int?> = .constant(nil), orientation: Orientation = .horizontal,
                itemLengths: [Double], @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollToIndex: scrollToIndex, orientation: orientation,
                  numberOfItems: itemLengths.count, lengths: DynamicListLengths(itemLengths),
                  viewForCell: viewForCell)
    }

    private init(scrollToIndex: Binding<Int?>, orientation: Orientation, numberOfItems: Int,
                 lengths: DynamicListLengths?, viewForCell: @escaping (Int) -> Content) {
        self._scrollToIndex = scrollToIndex
        self.orientation = orientation
        let count = lengths?.count ?? max(0, numberOfItems)
        self.numberOfItems = count
        self.lengths = lengths
        self.cellBuilder = viewForCell
        let initialIndex = count > 0
            ? min(max(0, scrollToIndex.wrappedValue ?? 0), count - 1) : nil
        self._reportedID = State(initialValue: initialIndex.map(AnyHashable.init))
        #if !os(Android)
        self._pointOrientation = State(initialValue: orientation)
        self._scrollOffset = .constant(0)
        self._position = State(initialValue: ScrollPosition(point: .zero))
        #endif
    }

    #if !os(Android)
    /// Apple compatibility: observe and request a negative offset in points.
    /// Use `scrollToIndex` for the shared iOS/Android API.
    public init(scrollOffset: Binding<Double>, orientation: Orientation = .horizontal,
                numberOfItems: Int, @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollOffset: scrollOffset, orientation: orientation,
                  numberOfItems: numberOfItems, lengths: nil, viewForCell: viewForCell)
    }

    public init(scrollOffset: Binding<Double>, orientation: Orientation = .horizontal,
                numberOfItems: Int, itemLength: Double,
                @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollOffset: scrollOffset, orientation: orientation,
                  numberOfItems: numberOfItems,
                  lengths: DynamicListLengths(count: numberOfItems, length: itemLength),
                  viewForCell: viewForCell)
    }

    public init(scrollOffset: Binding<Double>, orientation: Orientation = .horizontal,
                itemLengths: [Double], @ViewBuilder viewForCell: @escaping (Int) -> Content) {
        self.init(scrollOffset: scrollOffset, orientation: orientation,
                  numberOfItems: itemLengths.count, lengths: DynamicListLengths(itemLengths),
                  viewForCell: viewForCell)
    }

    private init(scrollOffset: Binding<Double>, orientation: Orientation, numberOfItems: Int,
                 lengths: DynamicListLengths?, viewForCell: @escaping (Int) -> Content) {
        self.init(scrollToIndex: .constant(nil), orientation: orientation,
                  numberOfItems: numberOfItems, lengths: lengths, viewForCell: viewForCell)
        self._scrollOffset = scrollOffset
        self.usesPointOffsets = true
        // Apply the initial request after layout supplies the viewport and content extent.
        self._initialPointOffset = State(initialValue: scrollOffset.wrappedValue)
    }
    #endif

    public var body: some View {
        #if !os(Android)
        if usesPointOffsets { pointOffsetList } else { indexedList }
        #else
        indexedList
        #endif
    }

    private var indexedList: some View {
        ScrollViewReader { proxy in
            nativeList
                #if os(Android)
                .scrollPosition(id: $reportedID)
                #else
                // Publish after layout rather than feeding visible IDs back into
                // the same layout pass while lazy estimates are being corrected.
                .task(id: visibleIndexIDs) {
                    guard !Task.isCancelled else { return }
                    // A lazy stack can be briefly empty while resolving a distant
                    // target. Keep the last position until new cells are laid out.
                    guard !visibleIndexIDs.isEmpty || numberOfItems == 0 else { return }
                    let id = visibleIndexIDs.min().map(AnyHashable.init)
                    if reportedID != id { reportedID = id }
                }
                // onChange does not carry the caller's transaction. A changing
                // child captures it before the deferred scroll request runs.
                .background {
                    Color.clear.id(scrollToIndex).transaction { transaction in
                        requestTransaction.value = transaction
                    }
                }
                .onScrollPhaseChange { oldPhase, phase in
                    if phase == .interacting || phase == .tracking {
                        cancelJump()
                    } else if oldPhase == .animating, phase == .idle, let index = arrivalIndex {
                        arrivalIndex = nil
                        jumpTask = Task { @MainActor in
                            try? await Task.sleep(for: .milliseconds(80))
                            guard !Task.isCancelled, !visibleIndexIDs.contains(index) else { return }
                            await alignIndex(index, proxy: proxy)
                        }
                    }
                }
                .onDisappear { cancelJump() }
                #endif
                .task(id: orientation) {
                    await Task.yield()
                    guard !Task.isCancelled else { return }
                    requestIndex(scrollToIndex, proxy: proxy)
                }
                .onChange(of: scrollToIndex) { _, value in requestIndex(value, proxy: proxy) }
                .onChange(of: clampedIndex(reportedIndex), initial: true) { _, index in visibleCellChange(index) }
                .onChange(of: numberOfItems) { _, count in
                    #if !os(Android)
                    cancelJump()
                    #endif
                    if count == 0 {
                        if scrollToIndex != nil { scrollToIndex = nil }
                        if reportedID != nil { reportedID = nil }
                    } else if let scrollToIndex {
                        requestIndex(scrollToIndex, proxy: proxy)
                    } else if reportedID == nil {
                        #if os(Android)
                        // Skip reports index changes; empty -> first cell can stay at
                        // native index zero without producing another notification.
                        reportedID = AnyHashable(0)
                        #endif
                        requestIndex(0, proxy: proxy)
                    }
                }
        }
        .id(orientation)
    }

    private var reportedIndex: Int? {
        #if os(Android)
        // Fuse returns IDs in its native SwiftHashable wrapper.
        if let wrapped = reportedID?.base as? SwiftHashable { return wrapped.base as? Int }
        #endif
        return reportedID?.base as? Int
    }

    private func clampedIndex(_ index: Int?) -> Int? {
        guard numberOfItems > 0, let index else { return nil }
        return min(max(0, index), numberOfItems - 1)
    }

    private func requestIndex(_ value: Int?, proxy: ScrollViewProxy) {
        guard let value else { return }
        let index = clampedIndex(value)
        #if !os(Android)
        cancelJump()
        #endif
        guard let index else {
            scrollToIndex = nil
            return
        }
        let anchor: UnitPoint = orientation == .horizontal ? .leading : .top
        #if os(Android)
        // Compose's native lazy-list animation already skips distant items.
        scrollToIndex = nil
        proxy.scrollTo(index, anchor: anchor)
        #else
        let origin = reportedIndex ?? 0
        jumpTask = Task { @MainActor in
            await Task.yield()
            guard !Task.isCancelled else { return }
            let transaction = requestTransaction.value
            let animated = transaction.animation != nil && !transaction.disablesAnimations
            scrollToIndex = nil
            let approach = max(3, visibleIndexIDs.count + 1)
            let isDistant = abs(index - origin) > max(8, visibleIndexIDs.count * 2)
            let nearby: Int
            if isDistant {
                // Leave roughly one viewport for the arrival. Account for end clamping
                // so jumping to the last cell still has room to animate.
                nearby = index > origin ? max(0, index - approach)
                    : index + min(approach, numberOfItems - 1 - index)
            } else {
                nearby = index
            }
            if nearby != index {
                await alignIndex(nearby, proxy: proxy)
            }
            guard !Task.isCancelled else { return }
            if animated {
                arrivalIndex = index
                withTransaction(transaction) {
                    proxy.scrollTo(index, anchor: anchor)
                }
            } else {
                await alignIndex(index, proxy: proxy)
            }
        }
        #endif
    }

    #if !os(Android)
    private func cancelJump() {
        jumpTask?.cancel()
        arrivalIndex = nil
    }

    private func alignIndex(_ index: Int, proxy: ScrollViewProxy) async {
        // Lazy stacks revise their estimated extent after a distant scroll.
        // Bound corrections, yielding to layout and allowing user input to cancel.
        var wasVisible = false
        for _ in 0..<6 {
            guard !Task.isCancelled else { return }
            if !wasVisible {
                var immediate = Transaction(animation: nil)
                immediate.disablesAnimations = true
                withTransaction(immediate) {
                    proxy.scrollTo(index, anchor: orientation == .horizontal ? .leading : .top)
                }
            }
            try? await Task.sleep(for: .milliseconds(80))
            let visible = visibleIndexIDs.contains(index)
            if visible && wasVisible { return }
            wasVisible = visible
        }
    }
    #endif

    /// Reports the first visible cell's index, including partially visible cells,
    /// or nil for empty content.
    public func onVisibleCellChange(_ action: @escaping (Int?) -> Void) -> Self {
        var view = self
        view.visibleCellChange = action
        return view
    }

    private var nativeList: some View {
        ScrollView(orientation == .horizontal ? .horizontal : .vertical) {
            if orientation == .horizontal {
                LazyHStack(spacing: 0) { cells }
            } else {
                LazyVStack(spacing: 0) { cells }
            }
        }
    }

    #if !os(Android)
    private var pointOffsetList: some View {
        ScrollViewReader { proxy in
            ScrollView(orientation == .horizontal ? .horizontal : .vertical) {
                pointOffsetContent
                    // Observe the laid-out content, including lazy-stack estimate corrections.
                    .onGeometryChange(for: DynamicListViewport.self) { [orientation] geometry in
                        let space = NamedCoordinateSpace.scrollView(axis: orientation == .horizontal ? .horizontal : .vertical)
                        let frame = geometry.frame(in: space)
                        let bounds = geometry.bounds(of: space)?.size ?? .zero
                        return DynamicListViewport(
                            offset: orientation == .horizontal ? frame.minX : frame.minY,
                            length: orientation == .horizontal ? bounds.width : bounds.height,
                            contentLength: orientation == .horizontal ? frame.width : frame.height
                        )
                    } action: { oldValue, newValue in
                        updatePointViewport(from: oldValue, to: newValue, proxy: proxy)
                    }
            }
            .scrollPosition($position)
            .onChange(of: visiblePointIDs) { oldIDs, ids in
                if oldIDs.max() != ids.max() { visibleCellChange(ids.max()) }
                if let initialPointOffset, viewport.length > 0 {
                    scroll(to: initialPointOffset, proxy: proxy)
                }
            }
            .onChange(of: scrollOffset) { _, value in
                guard abs(value - viewport.offset) > 0.5 || !value.isFinite else { return }
                initialPointOffset = nil
                scroll(to: value, proxy: proxy)
            }
            .onChange(of: lengths) { _, _ in scroll(to: viewport.offset, proxy: proxy) }
            .onChange(of: orientation) { _, _ in scroll(to: scrollOffset, proxy: proxy) }
        }
    }

    @ViewBuilder private var pointOffsetContent: some View {
        if orientation == .horizontal {
            LazyHStack(spacing: 0) { pointOffsetCells }
                .frame(width: lengths.map { CGFloat($0.total) }, alignment: .leading)
        } else {
            LazyVStack(spacing: 0) { pointOffsetCells }
                .frame(height: lengths.map { CGFloat($0.total) }, alignment: .top)
        }
    }

    private func updatePointViewport(from oldValue: DynamicListViewport, to newValue: DynamicListViewport,
                                     proxy: ScrollViewProxy) {
        guard newValue.length > 0 else { return }
        let changedAxis = pointOrientation != orientation
        pointOrientation = orientation
        viewport = newValue
        if let initialPointOffset {
            guard lengths != nil || numberOfItems == 0 || newValue.contentLength > 0 else { return }
            let offset = clampedOffset(initialPointOffset)
            let targetsEnd = lengths == nil && initialPointOffset.isFinite
                && initialPointOffset < offset && offset < 0
            // Native scroll views can round the final position to a whole point.
            if abs(newValue.offset - offset) > 1 || (targetsEnd && !visiblePointIDs.contains(numberOfItems - 1)) {
                scroll(to: initialPointOffset, proxy: proxy)
            } else {
                self.initialPointOffset = nil
                let actualOffset = clampedOffset(newValue.offset)
                viewport.offset = actualOffset
                if scrollOffset != actualOffset { scrollOffset = actualOffset }
            }
            return
        }
        if changedAxis {
            scroll(to: oldValue.offset, proxy: proxy)
            return
        }
        if oldValue.length != newValue.length {
            scroll(to: oldValue.offset, proxy: proxy)
        } else {
            let offset = clampedOffset(newValue.offset)
            viewport.offset = offset
            if scrollOffset != offset { scrollOffset = offset }
        }
    }

    private var pointOffsetCells: some View {
        ForEach(0..<numberOfItems, id: \.self) { index in
            cell(at: index)
                .id(index)
                .onScrollVisibilityChange(threshold: 0.001) { visible in
                    if visible {
                        visiblePointIDs.insert(index)
                    } else {
                        visiblePointIDs.remove(index)
                    }
                }
        }
    }
    #endif

    private var cells: some View {
        ForEach(0..<numberOfItems, id: \.self) { index in
            cell(at: index)
                .id(index)
                #if !os(Android)
                .modifier(DynamicListCellVisibility(orientation: orientation) { visible in
                    guard visibleIndexIDs.contains(index) != visible else { return }
                    if visible { visibleIndexIDs.insert(index) } else { visibleIndexIDs.remove(index) }
                })
                #endif
        }
    }

    private func cell(at index: Int) -> VStack<DynamicListCell<Content>> {
        // A concrete container gives each index one layout child even when the
        // user's content has a variable number of views. Do not erase its type.
        VStack(spacing: 0) {
            DynamicListCell(index: index, orientation: orientation,
                            length: lengths.map { CGFloat($0[index]) }, content: cellBuilder)
        }
    }

    #if !os(Android)
    private func scroll(to value: Double, proxy: ScrollViewProxy) {
        let offset = clampedOffset(value)
        if lengths == nil, numberOfItems > 0, value.isFinite, value < offset, offset < 0 {
            // Resolve the last cell by identity rather than the lazy stack's estimated edge.
            if abs(offset - viewport.offset) <= 0.5, scrollOffset != offset { scrollOffset = offset }
            proxy.scrollTo(numberOfItems - 1, anchor: orientation == .horizontal ? .trailing : .bottom)
            return
        }
        if scrollOffset != offset { scrollOffset = offset }
        if orientation == .horizontal {
            position.scrollTo(x: -offset)
        } else {
            position.scrollTo(y: -offset)
        }
    }

    private func clampedOffset(_ value: Double) -> Double {
        let contentLength = lengths?.total ?? (viewport.length > 0 ? viewport.contentLength : nil)
        return DynamicListLengths.clampedOffset(value, viewport: viewport.length, contentLength: contentLength)
    }
    #endif

    public func orientation(_ orientation: Orientation) -> Self {
        var view = self
        view.orientation = orientation
        return view
    }
}

// Keep the explicit scroll target on a lightweight cell. Its separate body
// defers user content while SwiftUI resolves identities for distant jumps.
struct DynamicListCell<Content: View>: View {
    let index: Int
    let orientation: Orientation
    let length: CGFloat?
    let content: (Int) -> Content

    var body: some View {
        content(index)
            .frame(width: orientation == .horizontal ? length : nil,
                   height: orientation == .vertical ? length : nil)
    }
}

public enum Orientation: CaseIterable, Sendable {
    case horizontal, vertical
    public func not() -> Self { self == .horizontal ? .vertical : .horizontal }
}

/// A stack whose axis is selected at runtime, without erasing its content type.
public struct StackView<Content: View>: View {
    private let orientation: Orientation
    private let content: Content

    public init(orientation: Orientation, @ViewBuilder content: () -> Content) {
        self.orientation = orientation
        self.content = content()
    }

    public var body: some View {
        #if os(Android)
        if orientation == .horizontal {
            HStack(spacing: 0) { content }
        } else {
            VStack(spacing: 0) { content }
        }
        #else
        let layout = orientation == .horizontal
            ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
        layout { content }
        #endif
    }
}

struct DynamicListViewport: Equatable {
    var offset: Double = 0
    var length: Double = 0
    var contentLength: Double = 0
}

/// Validates optional explicit size overrides, not measured content sizes.
/// Keeps uniform sizing O(1) in memory. Invalid dimensions collapse to zero.
struct DynamicListLengths: Equatable, Sendable {
    private let values: [Double]
    private let uniformLength: Double
    let count: Int
    let total: Double

    init(count: Int, length: Double) {
        let count = max(0, count)
        let length = Self.validLength(length)
        let total = Double(count) * length
        self.values = []
        self.count = total.isFinite ? count : 0
        self.uniformLength = length
        self.total = total.isFinite ? total : 0
    }

    init(_ lengths: [Double]) {
        let values = lengths.map(Self.validLength)
        let total = values.reduce(0, +)
        self.values = total.isFinite ? values : []
        self.uniformLength = 0
        self.count = total.isFinite ? values.count : 0
        self.total = total.isFinite ? total : 0
    }

    subscript(index: Int) -> Double { values.isEmpty ? uniformLength : values[index] }

    func clampedOffset(_ offset: Double, viewport: Double) -> Double {
        Self.clampedOffset(offset, viewport: viewport, contentLength: total)
    }

    static func clampedOffset(_ offset: Double, viewport: Double, contentLength: Double?) -> Double {
        let offset = min(0, offset.isFinite ? offset : 0)
        guard let contentLength else { return offset }
        let viewport = Self.validLength(viewport)
        return max(offset, min(0, viewport - Self.validLength(contentLength)))
    }

    private static func validLength(_ value: Double) -> Double { value.isFinite ? max(0, value) : 0 }
}

#if !os(Android)
// Cached lazy cells can reappear without a geometry-value change. Restore their
// last measured visibility on appearance and remove them on disappearance.
struct DynamicListCellVisibility: ViewModifier {
    let orientation: Orientation
    let action: (Bool) -> Void
    @Environment(\.displayScale) var displayScale
    @State var isVisible = false

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: Bool.self) { [orientation, displayScale] geometry in
                let space = NamedCoordinateSpace.scrollView(axis: orientation == .horizontal ? .horizontal : .vertical)
                let frame = geometry.frame(in: space)
                let viewport = geometry.bounds(of: space)?.size ?? .zero
                let start = orientation == .horizontal ? frame.minX : frame.minY
                let length = orientation == .horizontal ? frame.width : frame.height
                let limit = orientation == .horizontal ? viewport.width : viewport.height
                // Include a partial leading cell, but ignore subpixel rounding at
                // an aligned edge. A percentage threshold skips visible content.
                return length > 0 && min(start + length, limit) - max(start, 0) >= 1 / displayScale
            } action: { visible in
                isVisible = visible
                action(visible)
            }
            .onAppear { action(isVisible) }
            .onDisappear { action(false) }
    }
}

final class DynamicListTransaction {
    var value = Transaction()
}
#endif
