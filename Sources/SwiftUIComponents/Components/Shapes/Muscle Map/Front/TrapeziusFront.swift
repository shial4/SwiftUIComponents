import SwiftUI

extension MuscleMap.Front {
    public struct Trapezius: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.7367*width, y: 7.97719*height))
                path.addCurve(to: CGPoint(x: 2.74312*width, y: 7.83577*height), control1: CGPoint(x: 2.74037*width, y: 7.92792*height), control2: CGPoint(x: 2.74312*width, y: 7.86405*height))
                path.addLine(to: CGPoint(x: 2.74312*width, y: 7.78285*height))
                path.addLine(to: CGPoint(x: 2.63028*width, y: 7.78285*height))
                path.addCurve(to: CGPoint(x: 2.3*width, y: 7.81569*height), control1: CGPoint(x: 2.53028*width, y: 7.78285*height), control2: CGPoint(x: 2.34679*width, y: 7.80109*height))
                path.addCurve(to: CGPoint(x: 2.32936*width, y: 7.85219*height), control1: CGPoint(x: 2.28624*width, y: 7.82026*height), control2: CGPoint(x: 2.29174*width, y: 7.82664*height))
                path.addCurve(to: CGPoint(x: 2.7211*width, y: 8.06569*height), control1: CGPoint(x: 2.42752*width, y: 7.91788*height), control2: CGPoint(x: 2.69725*width, y: 8.06478*height))
                path.addCurve(to: CGPoint(x: 2.7367*width, y: 7.97719*height), control1: CGPoint(x: 2.72752*width, y: 8.06569*height), control2: CGPoint(x: 2.73303*width, y: 8.03193*height))
                path.closeSubpath()
                path.move(to: CGPoint(x: 3.4055*width, y: 8.02281*height))
                path.addCurve(to: CGPoint(x: 3.73853*width, y: 7.82847*height), control1: CGPoint(x: 3.5*width, y: 7.97628*height), control2: CGPoint(x: 3.73028*width, y: 7.84124*height))
                path.addCurve(to: CGPoint(x: 3.73578*width, y: 7.81569*height), control1: CGPoint(x: 3.74128*width, y: 7.82391*height), control2: CGPoint(x: 3.74037*width, y: 7.81843*height))
                path.addCurve(to: CGPoint(x: 3.3945*width, y: 7.78467*height), control1: CGPoint(x: 3.71468*width, y: 7.80292*height), control2: CGPoint(x: 3.48807*width, y: 7.78193*height))
                path.addLine(to: CGPoint(x: 3.28899*width, y: 7.78741*height))
                path.addLine(to: CGPoint(x: 3.29174*width, y: 7.89234*height))
                path.addCurve(to: CGPoint(x: 3.31193*width, y: 8.06569*height), control1: CGPoint(x: 3.2945*width, y: 8.01186*height), control2: CGPoint(x: 3.30092*width, y: 8.06569*height))
                path.addCurve(to: CGPoint(x: 3.4055*width, y: 8.02281*height), control1: CGPoint(x: 3.31651*width, y: 8.06569*height), control2: CGPoint(x: 3.35872*width, y: 8.04653*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
