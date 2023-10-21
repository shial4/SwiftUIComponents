import Foundation
import SwiftUI

public enum Orientation {
    case horizontal
    case vertical
}

public struct StackView<Content: View>: View {
    private var orientation: Orientation
    private let content: Content
    
    init(orientation: Orientation, @ViewBuilder content: () -> Content) {
        self.orientation = orientation
        self.content = content()
    }
    
    public var body: some View {
        if orientation == .horizontal {
            HStack(spacing: 0) {
                content
            }
        } else {
            VStack(spacing: 0) {
                content
            }
        }
    }
}

public struct DynamicList<Content: View>: View {
    private class ViewModel: ObservableObject {
        @Published var scrollOffset: Double = 0
        var previousScrollOffset: Double = 0
    }
    
    @StateObject private var viewModel = ViewModel()
    @Binding private var scrollOffset: Double
    
    private let animation: Animation = .easeInOut(duration: 0.3)
    
    private let lengths: [Double]
    private let length: Double
    private let cellBuilder: (Int) -> Content
    private var orientation: Orientation

    public init(
        scrollOffset: Binding<Double>,
        orientation: Orientation = .horizontal,
        numberOfItems: Int,
        itemLength: Double,
        viewForCell cellBuilder: @escaping (Int) -> Content
    ) {
        self.lengths = Array(repeating: itemLength, count: numberOfItems)
        self.length = itemLength * Double(numberOfItems)
        self.cellBuilder = cellBuilder
        self.orientation = orientation
        self._scrollOffset = scrollOffset
    }
    
    public init(
        scrollOffset: Binding<Double>,
        orientation: Orientation = .horizontal,
        itemLengths: [Double],
        viewForCell cellBuilder: @escaping (Int) -> Content
    ) {
        self.lengths = itemLengths
        self.length = itemLengths.reduce(0.0, +)
        self.cellBuilder = cellBuilder
        self.orientation = orientation
        self._scrollOffset = scrollOffset
    }
    
    public var body: some View {
        GeometryReader { geometry in
            listView(geometry.size)
                .onChange(of: scrollOffset) { value in
                    guard scrollOffset != viewModel.scrollOffset else { return }
                    
                    let scrollOffset: Double
                    switch orientation {
                    case .horizontal:
                        scrollOffset = max(min(0, value), geometry.size.width - length)
                    case .vertical:
                        scrollOffset = max(min(0, value), geometry.size.height - length)
                    }
                    
                    viewModel.previousScrollOffset = scrollOffset
                    if self.scrollOffset != scrollOffset {
                        self.scrollOffset = scrollOffset
                    }
                    
                    withAnimation(animation) {
                        viewModel.scrollOffset = scrollOffset
                    }
                }
        }
    }
    
    private var previousScrollOffset: Double {
        viewModel.previousScrollOffset
    }

    private func dragGesture(screenDimension size: Double) -> some Gesture {
        DragGesture()
            .onChanged{ value in
                let translation = orientation == .horizontal ? value.translation.width : value.translation.height
                let scrollOffset = max(min(0, previousScrollOffset + translation), size - length)
                viewModel.scrollOffset = scrollOffset
                self.scrollOffset = scrollOffset
            }
            .onEnded { value in
                withAnimation(animation) {
                    let translation = orientation == .horizontal ? value.translation.width : value.translation.height
                    let scrollOffset = max(min(0, previousScrollOffset + translation), size - length)
                    viewModel.scrollOffset = scrollOffset
                    self.scrollOffset = scrollOffset
                    viewModel.previousScrollOffset = viewModel.scrollOffset
                }
            }
    }
    
    private func index(for offset: Double) -> (index: Int, width: Double) {
        var startIndex = 0
        var accumulatedWidth: Double = 0
        
        for (index, width) in lengths.enumerated() {
            if accumulatedWidth < (offset - width) {
                startIndex = index
            } else {
                break
            }
            accumulatedWidth += width
        }
        return (startIndex, accumulatedWidth)
    }
    
    private func endIndex(for start: (index: Int, width: Double), screenWidth: Double) -> Int {
        var endIndex = start.index
        var accumulatedWidth = start.width

        while endIndex < lengths.count, accumulatedWidth <= (start.width + screenWidth) {
            accumulatedWidth += lengths[endIndex]
            endIndex += 1
        }
        
        if (endIndex + 1) < lengths.count {
            endIndex += 1
        }
        
        return endIndex
    }
    
    private func listView(_ size: CGSize) -> some View {
        let screenDimension: Double
        let scrollOffset: Double

        switch orientation {
        case .horizontal:
            screenDimension = size.width
            scrollOffset = viewModel.scrollOffset
        case .vertical:
            screenDimension = size.height
            scrollOffset = viewModel.scrollOffset
        }
        
        let numberOfItems = lengths.count
        
        let start = index(for: abs(scrollOffset))
        let endIndex = min(endIndex(for: start, screenWidth: screenDimension) + 1, numberOfItems)
        let visibleRange = start.index ..< endIndex
        
        let padding: Double
        switch orientation {
        case .horizontal:
            padding = max(0, start.width - lengths[start.index])
        case .vertical:
            padding = max(0, start.width - lengths[start.index])
        }
        
        return StackView(orientation: orientation) {
            Spacer()
                .frame(
                    width: orientation == .horizontal ? padding : nil,
                    height: orientation == .vertical ? padding : nil
                )
            ForEach(visibleRange, id: \.hashValue) { index in
                cellBuilder(index)
                    .frame(
                        width: orientation == .horizontal ? lengths[index] : nil,
                        height: orientation == .vertical ? lengths[index] : nil
                    )
                    .transition(
                        .offset(
                            x: orientation == .horizontal ? index > (endIndex - start.index) ? lengths[start.index] : -lengths[start.index] : 0,
                            y: orientation == .vertical ? index > (endIndex - start.index) ? lengths[start.index] : -lengths[start.index] : 0
                        )
                    )
                    .background(Color.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: orientation == .horizontal ? viewModel.scrollOffset : 0,
                y: orientation == .vertical ? viewModel.scrollOffset : 0)
        .contentShape(Rectangle())
        .gesture(dragGesture(screenDimension: screenDimension))
    }
    
    public func orientation(_ orientation: Orientation) -> Self {
        var view = self
        view.orientation = orientation
        return view
    }
}

// MARK: - Public Init

extension DynamicList {
    public init(
        orientation: Orientation = .horizontal,
        numberOfItems: Int,
        itemLength: Double,
        viewForCell cellBuilder: @escaping (Int) -> Content
    ) {
        self.init(
            scrollOffset: .constant(0),
            orientation: orientation,
            numberOfItems: numberOfItems,
            itemLength: itemLength,
            viewForCell: cellBuilder
        )
    }
    
    public init(
        orientation: Orientation = .horizontal,
        itemLengths: [Double],
        viewForCell cellBuilder: @escaping (Int) -> Content
    ) {
        self.init(
            scrollOffset: .constant(0),
            orientation: orientation,
            itemLengths: itemLengths,
            viewForCell: cellBuilder
        )
    }
}
