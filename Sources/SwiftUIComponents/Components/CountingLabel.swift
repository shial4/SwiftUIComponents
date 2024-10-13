import SwiftUI
import Combine

public struct CountingLabel: View {
    @State private var text: String = ""
    @State private var round: Double = 1
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    private let counter: Counter = Counter()
    private let from: String
    private let to: String
    private let format: [String]?
    private let fromValues: [String]
    private let toValues: [String]
    private let numbersCount: Int
    
    public init(from: String? = nil, to: String, interval: TimeInterval = 0.2, format: [String]? = nil) {
        let toValues = counter.numbers(to)
        let numbersCount = toValues.count < toValues.count ? toValues.count : toValues.count
        
        var fromText = from ?? to
        if from == nil {
            for i in 0..<numbersCount {
                fromText = fromText.replacingOccurrences(of: toValues[i], with: String(format: format?[i] ?? "%0.0f", 0))
            }
        }
        let fromValues = counter.numbers(fromText)
        
        self.to = to
        self.from = fromText
        self.text = fromText
        self.format = format
        self.fromValues = fromValues
        self.toValues = toValues
        self.numbersCount = numbersCount
        self.timer = Timer.publish(every: interval, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect()
        
        guard numbersCount > 0 else {
            self.text = to
            return
        }
    }
    
    public var body: some View {
        Text(text).onReceive(timer) { input in
            guard text != to else {
                self.timer.upstream.connect().cancel()
                return
            }
            var fromString = to
            var shouldInvalidate = true
            
            for i in 0..<numbersCount {
                guard let fromD = Double(fromValues[i]),
                      let toD = Double(toValues[i]),
                      let offset = Double(format?[i].components(separatedBy: CharacterSet(charactersIn: ".0123456789").inverted).joined() ?? "0"),
                      counter.shouldContinue(fromD, to: toD, round: round, offset: offset) else { continue }
                let value = String(format: format?[i] ?? "%0.0f", counter.shift(fromD, to: toD, round: round, offset: offset))
                fromString = fromString.replacingOccurrences(of: toValues[i], with: value)
                shouldInvalidate = false
            }
            
            if shouldInvalidate {
                withAnimation {
                    text = to
                }
            } else {
                withAnimation {
                    text = fromString
                }
                round = round + 1
            }
        }
    }
    
    // MARK: Helper Type
    
    struct Counter {
        func numbers(_ text: String) -> [String] {
            do {
                let regex = try NSRegularExpression(pattern: "[\\-\\+]?[0-9]*(\\.[0-9]+)?")
                let nsString = text as NSString
                let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
                return results.map { nsString.substring(with: $0.range)}.filter({ !$0.isEmpty })
            } catch {
                return []
            }
        }
        fileprivate func shouldContinue(_ from: Double, to: Double, round: Double, offset: Double = 0) -> Bool {
            if to - from < 0 {
                return shift(from, to: to, round: round, offset: offset) > to
            } else {
                return shift(from, to: to, round: round, offset: offset) < to
            }
        }
        
        fileprivate func shift(_ from: Double, to: Double, round: Double, offset: Double = 0) -> Double {
            if to - from < 0 {
                return (from - (1 * pow(10.0, offset)) * round)
            } else {
                return (from + (1 * pow(10.0, offset)) * round)
            }
        }
    }
}

#Preview {
    VStack {
        CountingLabel(to: "11 and second number in same string -22.0")
        CountingLabel(from: "down 11.0 up 7", to: "down 5.0 up 11", interval: 0.2)
        CountingLabel(from: "down 11.0 up 7", to: "down 5.0 up 11", format: ["%0.2f", "%0.0f"])
    }
}
