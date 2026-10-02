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
    @Binding private var scrollOffset: Double
    private var usesPointOffsets = false
    @State var position: ScrollPosition
    @State var viewport = DynamicListViewport()
    @State var pointOrientation: Orientation
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
            ? scrollToIndex.wrappedValue.map { min(max(0, $0), count - 1) } : nil
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
        // Automatic content has no known extent until SwiftUI lays out the lazy stack.
        let offset = DynamicListLengths.clampedOffset(scrollOffset.wrappedValue,
                                                     viewport: 0, contentLength: lengths?.total)
        self._position = State(initialValue: ScrollPosition(point: CGPoint(
            x: orientation == .horizontal ? -offset : 0,
            y: orientation == .vertical ? -offset : 0
        )))
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
                .scrollPosition(id: $reportedID)
                .task(id: orientation) {
                    await Task.yield()
                    requestIndex(scrollToIndex, proxy: proxy)
                    visibleCellChange(clampedIndex(reportedIndex))
                }
                .onChange(of: scrollToIndex) { _, value in requestIndex(value, proxy: proxy) }
                .onChange(of: reportedID) { _, _ in visibleCellChange(clampedIndex(reportedIndex)) }
                .onChange(of: numberOfItems) { _, count in
                    requestIndex(scrollToIndex, proxy: proxy)
                    if count == 0 {
                        reportedID = nil
                        visibleCellChange(nil)
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
        scrollToIndex = nil
        reportedID = index.map(AnyHashable.init)
        if let index { proxy.scrollTo(index, anchor: orientation == .horizontal ? .leading : .top) }
    }

    /// Reports the visible cell's index, or nil for empty content.
    /// Native containers choose which visible cell to report near the trailing edge.
    public func onVisibleCellChange(_ action: @escaping (Int?) -> Void) -> Self {
        var view = self
        view.visibleCellChange = action
        return view
    }

    private var nativeList: some View {
        ScrollView(orientation == .horizontal ? .horizontal : .vertical) {
            if orientation == .horizontal {
                LazyHStack(spacing: 0) { cells }.scrollTargetLayout()
            } else {
                LazyVStack(spacing: 0) { cells }.scrollTargetLayout()
            }
        }
    }

    #if !os(Android)
    private var pointOffsetList: some View {
        ScrollView(orientation == .horizontal ? .horizontal : .vertical) {
            if orientation == .horizontal {
                LazyHStack(spacing: 0) { cells }
                    .frame(width: lengths.map { CGFloat($0.total) }, alignment: .leading)
            } else {
                LazyVStack(spacing: 0) { cells }
                    .frame(height: lengths.map { CGFloat($0.total) }, alignment: .top)
            }
        }
        .scrollPosition($position)
        .onScrollGeometryChange(for: DynamicListViewport.self) { geometry in
            DynamicListViewport(
                offset: orientation == .horizontal ? -geometry.contentOffset.x : -geometry.contentOffset.y,
                length: orientation == .horizontal ? geometry.containerSize.width : geometry.containerSize.height,
                contentLength: orientation == .horizontal ? geometry.contentSize.width : geometry.contentSize.height
            )
        } action: { oldValue, newValue in
            let changedAxis = pointOrientation != orientation
            pointOrientation = orientation
            let isInitialLayout = viewport.length == 0
            viewport = newValue
            if changedAxis {
                scroll(to: oldValue.offset)
                return
            }
            if oldValue.length != newValue.length || (isInitialLayout && scrollOffset != clampedOffset(scrollOffset)) {
                scroll(to: isInitialLayout ? scrollOffset : oldValue.offset)
            } else {
                let offset = clampedOffset(newValue.offset)
                viewport.offset = offset
                if scrollOffset != offset { scrollOffset = offset }
            }
        }
        .onChange(of: scrollOffset) { _, value in
            guard abs(value - viewport.offset) > 0.5 || !value.isFinite else { return }
            scroll(to: value)
        }
        .onChange(of: lengths) { _, _ in scroll(to: viewport.offset) }
        .onChange(of: orientation) { _, _ in scroll(to: scrollOffset) }
    }
    #endif

    private var cells: some View {
        ForEach(0..<numberOfItems, id: \.self) { index in
            let length = lengths.map { CGFloat($0[index]) }
            cellBuilder(index)
                .frame(width: orientation == .horizontal ? length : nil,
                       height: orientation == .vertical ? length : nil)
                .id(index)
        }
    }

    #if !os(Android)
    private func scroll(to value: Double) {
        let offset = clampedOffset(value)
        if lengths == nil, numberOfItems > 0, value.isFinite, value < offset, offset < 0 {
            // An estimated length can grow while scrolling. Let SwiftUI find the
            // actual edge, then publish its resulting offset through scroll geometry.
            if abs(offset - viewport.offset) <= 0.5, scrollOffset != offset { scrollOffset = offset }
            position.scrollTo(edge: orientation == .horizontal ? .trailing : .bottom)
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
