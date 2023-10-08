import SwiftUI

public struct DynamicList<Content: View>: View {
    public enum Orientation {
        case horizontal
        case vertical
    }

    private class ViewModel: ObservableObject {
        @Published var scrollOffset: Double = 0
        var previousScrollOffset: Double = 0
    }
    
    @StateObject private var viewModel = ViewModel()
    
    private let lengths: [Double]
    private let cellBuilder: (Int) -> Content
    private var orientation: Orientation

    public init(orientation: Orientation = .horizontal, numberOfItems: Int, itemLength: Double, viewForCell cellBuilder: @escaping (Int) -> Content) {
        self.lengths = Array(repeating: itemLength, count: numberOfItems)
        self.cellBuilder = cellBuilder
        self.orientation = orientation
    }
    
    public init(orientation: Orientation = .horizontal, itemLengths: [Double], viewForCell cellBuilder: @escaping (Int) -> Content) {
        self.lengths = itemLengths
        self.cellBuilder = cellBuilder
        self.orientation = orientation
    }

    
    public var body: some View {
        GeometryReader { geometry in
            listView(geometry.size)
        }
    }
    
    private var previousScrollOffset: Double {
        viewModel.previousScrollOffset
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged{ value in
                let translation = orientation == .horizontal ? value.translation.width : value.translation.height
                viewModel.scrollOffset = min(0, previousScrollOffset + translation)
            }
            .onEnded { value in
                withAnimation {
                    let translation = orientation == .horizontal ? value.translation.width : value.translation.height
                    viewModel.scrollOffset = min(0, previousScrollOffset + translation)
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
        
        let leadingPadding: Double
        switch orientation {
        case .horizontal:
            leadingPadding = max(0, start.width - lengths[start.index])
        case .vertical:
            leadingPadding = max(0, start.width - lengths[start.index])
        }
        
        return HStack(spacing: 0) {
            Spacer()
                .frame(
                    width: orientation == .horizontal ? leadingPadding : nil,
                    height: orientation == .vertical ? leadingPadding : nil
                )
            ForEach(visibleRange, id: \.hashValue) { index in
                cellBuilder(index)
                    .frame(
                        width: orientation == .horizontal ? lengths[index] : nil,
                        height: orientation == .vertical ? lengths[index] : nil
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .offset(x: orientation == .horizontal ? viewModel.scrollOffset : 0,
                y: orientation == .vertical ? viewModel.scrollOffset : 0)
        .contentShape(Rectangle())
        .gesture(dragGesture)
    }
    
    public func orientation(_ orientation: Orientation) -> Self {
        var view = self
        view.orientation = orientation
        return view
    }
}

