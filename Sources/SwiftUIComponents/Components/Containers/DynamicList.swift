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
    @StateObject private var viewModel = ViewModel()
    @Binding private var scrollOffset: Double
    
    private let animation: Animation = .easeInOut(duration: 0.3)
    
    private let length: Length
    private let cellBuilder: (Int) -> Content
    private var orientation: Orientation

    public init(
        scrollOffset: Binding<Double>,
        orientation: Orientation = .horizontal,
        numberOfItems: Int,
        itemLength: Double,
        viewForCell cellBuilder: @escaping (Int) -> Content
    ) {
        self.length = Length(length: itemLength, numberOfItems: numberOfItems)
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
        self.length = Length(lengths: itemLengths)
        self.cellBuilder = cellBuilder
        self.orientation = orientation
        self._scrollOffset = scrollOffset
    }
    
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
    
    public var body: some View {
        GeometryReader { geometry in
            listView(geometry.size)
                .onChange(of: scrollOffset) { value in
                    guard scrollOffset != viewModel.scrollOffset else { return }
                    
                    let scrollOffset: Double
                    switch orientation {
                    case .horizontal:
                        scrollOffset = max(min(0, value), geometry.size.width - length.total)
                    case .vertical:
                        scrollOffset = max(min(0, value), geometry.size.height - length.total)
                    }
                    
                    viewModel.previousScrollOffset = scrollOffset
                    if self.scrollOffset != scrollOffset {
                        self.scrollOffset = scrollOffset
                    }
                    viewModel.isLeadingAnimation = viewModel.scrollOffset < scrollOffset
                    withAnimation(animation) {
                        viewModel.scrollOffset = scrollOffset
                    }
                }
        }
    }
    
    private var previousScrollOffset: Double {
        viewModel.previousScrollOffset
    }
    
    private func transition(
        index: Int,
        start: (index: Int, width: Double),
        endIndex: Int
    ) -> AnyTransition {
        let isLeading: Bool
        if viewModel.isLeadingAnimation == true {
            isLeading =  index <= (endIndex - start.index)
        } else {
            isLeading =  index < (endIndex - start.index)
        }
        let x = orientation == .horizontal ? isLeading ? -length[start.index] : length[start.index] : 0
        let y = orientation == .vertical ? isLeading ? -length[start.index] : length[start.index] : 0
        return .asymmetric(
            insertion: .offset(x: x, y: y),
            removal: .opacity
        )
    }

    private func dragGesture(screenDimension size: Double) -> some Gesture {
        DragGesture()
            .onChanged{ value in
                let translation = orientation == .horizontal ? value.translation.width : value.translation.height
                let scrollOffset = max(min(0, previousScrollOffset + translation), size - length.total)
                viewModel.isLeadingAnimation = nil
                viewModel.scrollOffset = scrollOffset
                self.scrollOffset = scrollOffset
            }
            .onEnded { value in
                withAnimation(animation) {
                    let translation = orientation == .horizontal ? value.predictedEndTranslation.width : value.predictedEndTranslation.height
                    let scrollOffset = max(min(0, previousScrollOffset + translation), size - length.total)
                    viewModel.scrollOffset = scrollOffset
                    self.scrollOffset = scrollOffset
                    viewModel.previousScrollOffset = viewModel.scrollOffset
                }
            }
    }
    
    private func index(for offset: Double) -> (index: Int, width: Double) {
        var startIndex = 0
        var accumulatedWidth: Double = 0
        
        for (index, width) in length.enumerated() {
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

        while endIndex < length.count, accumulatedWidth <= (start.width + screenWidth) {
            accumulatedWidth += length[endIndex]
            endIndex += 1
        }
        
        if (endIndex + 1) < length.count {
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
        
        let numberOfItems = length.count
        
        let start = index(for: abs(scrollOffset))
        let endIndex = min(endIndex(for: start, screenWidth: screenDimension) + 1, numberOfItems)
        let visibleRange = start.index ..< endIndex
        
        let padding: Double
        switch orientation {
        case .horizontal:
            padding = max(0, start.width - length[start.index])
        case .vertical:
            padding = max(0, start.width - length[start.index])
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
                        width: orientation == .horizontal ? length[index] : nil,
                        height: orientation == .vertical ? length[index] : nil
                    )
                    .transition(
                        transition(index: index, start: start, endIndex: endIndex)
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
    
    // MARK: Internal types
    
    private class ViewModel: ObservableObject {
        @Published var scrollOffset: Double = 0
        var previousScrollOffset: Double = 0
        var isLeadingAnimation: Bool? = nil
    }
    
    private struct Length: Sequence, IteratorProtocol {
        let lengths: [Double]
        let length: Double
        let count: Int
        let total: Double
        
        private var currentIndex: Int = 0
        
        init(lengths: [Double]) {
            self.lengths = lengths
            self.length = 0
            self.count = lengths.count
            self.total = lengths.reduce(0.0, +)
        }
        
        init(length: Double, numberOfItems: Int) {
            self.lengths = []
            self.length = length
            self.count = numberOfItems
            self.total = length * Double(numberOfItems)
        }
        
        subscript(index: Int) -> Double {
            get {
                if !lengths.isEmpty, index >= 0 && index < lengths.count {
                    return lengths[index]
                }
                return length
            }
        }
        
        func makeIterator() -> Self {
            return self
        }
        
        mutating func next() -> Double? {
            guard currentIndex < count else {
                return nil
            }
            
            defer { currentIndex += 1 }
            return self[currentIndex]
        }
    }
}
