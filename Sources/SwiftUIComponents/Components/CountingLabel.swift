import SwiftUI

/// Counts the numbers embedded in a string. Animation cancels when the view disappears
/// and restarts when its inputs change. At most 120 frames are produced per change.
public struct CountingLabel: View {
    @State var text: String
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    private let counter: CountingText
    private let interval: TimeInterval

    public init(from: String? = nil, to: String, interval: TimeInterval = 0.2, format: [String]? = nil) {
        let counter = CountingText(from: from, to: to, formats: format ?? [])
        self.counter = counter
        self.interval = interval.isFinite ? max(0.001, min(interval, 60)) : 0.2
        self._text = State(initialValue: counter.initialText)
    }

    public var body: some View {
        Text(text)
            .task(id: AnimationInput(counter: counter, interval: interval, reduceMotion: reduceMotion)) {
                text = reduceMotion ? counter.target : counter.initialText
                guard !reduceMotion, counter.initialText != counter.target else { return }
                for frame in 1...counter.frameCount {
                    do { try await Task.sleep(for: .seconds(interval)) }
                    catch { return }
                    guard !Task.isCancelled else { return }
                    text = counter.text(at: frame)
                }
            }
    }

    private struct AnimationInput: Equatable {
        let counter: CountingText
        let interval: TimeInterval
        let reduceMotion: Bool
    }
}

struct CountingText: Equatable, Sendable {
    private struct Number: Equatable, Sendable {
        let range: NSRange
        let from: Double
        let to: Double
        let format: String
        let step: Double
    }

    private static let numberExpression = try? NSRegularExpression(pattern: #"[+-]?(?:[0-9]+(?:\.[0-9]+)?|\.[0-9]+)"#)
    private static let formatExpression = try? NSRegularExpression(pattern: #"^%([0-9]*)(?:\.([0-9]{1,2}))?[fFeEgG]$"#)
    private let numbers: [Number]
    let initialText: String
    let target: String
    let frameCount: Int

    init(from: String?, to: String, formats: [String] = []) {
        self.target = to
        let targets = Self.matches(in: to)
        let sources = from.map(Self.matches)
        let sourceText = from ?? to
        let sourceNSString = sourceText as NSString
        let targetNSString = to as NSString
        var numbers: [Number] = []
        if sources == nil || sources?.count == targets.count {
            for (index, range) in targets.enumerated() {
                guard let target = Double(targetNSString.substring(with: range)), target.isFinite else { continue }
                let source = sources.flatMap { Double(sourceNSString.substring(with: $0[index])) } ?? 0
                guard source.isFinite else { continue }
                let requestedFormat = index < formats.count ? formats[index] : "%0.0f"
                let (format, precision) = Self.validatedFormat(requestedFormat)
                numbers.append(Number(range: range, from: source, to: target, format: format, step: pow(10, -Double(precision))))
            }
        }
        self.numbers = numbers
        let steps = numbers.map { abs($0.to - $0.from) / $0.step }.max() ?? 0
        self.frameCount = Int(min(120, max(1, ceil(steps))))
        if numbers.isEmpty {
            self.initialText = to
        } else if let from {
            self.initialText = from
        } else {
            self.initialText = Self.replacing(in: to, numbers: numbers) { String(format: $0.format, 0.0) }
        }
    }

    func text(at frame: Int) -> String {
        guard frame > 0 else { return initialText }
        guard frame < frameCount else { return target }
        return Self.replacing(in: target, numbers: numbers) { number in
            let distance = number.to - number.from
            let step = max(number.step, abs(distance) / Double(frameCount)) * Double(frame)
            let fraction = Double(frame) / Double(frameCount)
            let value = distance.isFinite
                ? number.from + (distance < 0 ? -1 : 1) * min(abs(distance), step)
                : number.from * (1 - fraction) + number.to * fraction
            return String(format: number.format, value)
        }
    }

    private static func matches(in text: String) -> [NSRange] {
        numberExpression?.matches(in: text, range: NSRange(text.startIndex..., in: text)).map(\.range) ?? []
    }

    private static func validatedFormat(_ format: String) -> (String, Int) {
        guard let match = formatExpression?.firstMatch(in: format, range: NSRange(format.startIndex..., in: format)) else {
            return ("%0.0f", 0)
        }
        let string = format as NSString
        let width = Int(string.substring(with: match.range(at: 1))) ?? 0
        let precision = match.range(at: 2).location == NSNotFound ? 0 : Int(string.substring(with: match.range(at: 2))) ?? 0
        guard width <= 32, precision <= 12 else { return ("%0.0f", 0) }
        return (format, precision)
    }

    private static func replacing(in text: String, numbers: [Number], value: (Number) -> String) -> String {
        let result = NSMutableString(string: text)
        for number in numbers.reversed() { result.replaceCharacters(in: number.range, with: value(number)) }
        return result as String
    }
}
