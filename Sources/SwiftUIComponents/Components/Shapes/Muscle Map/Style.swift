import SwiftUI

extension MuscleMap {
    public enum GradientKind: Hashable, Sendable {
        case linear
        case radial
    }

    public struct Style: Hashable, Sendable {
        public var fillColor: Color
        public var gradientColors: [Color]
        public var gradientKind: GradientKind
        public var gradientRadius: Double
        public var strokeColor: Color
        public var lineWidth: Double
        
        public init(
            fillColor: Color = Color.blue.opacity(0.4),
            gradientColors: [Color] = [],
            gradientKind: GradientKind = .linear,
            gradientRadius: Double = 180,
            strokeColor: Color = Color.clear,
            lineWidth: Double = 0
        ) {
            self.fillColor = fillColor
            self.gradientColors = gradientColors
            self.gradientKind = gradientKind
            self.gradientRadius = gradientRadius
            self.strokeColor = strokeColor
            self.lineWidth = lineWidth
        }
        
        public static func clear() -> MuscleMap.Style {
            MuscleMap.Style(fillColor: Color.clear, strokeColor: Color.clear, lineWidth: 0.0)
        }
    }
}
