import SwiftUI

extension MuscleMap.Front {
    public struct PectoralisMajor: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(PectoralisMajor().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.53853*width, y: 7.69708*height))
                path.addCurve(to: CGPoint(x: 3.74128*width, y: 7.31296*height), control1: CGPoint(x: 3.56881*width, y: 7.66697*height), control2: CGPoint(x: 3.72385*width, y: 7.37409*height))
                path.addCurve(to: CGPoint(x: 3.76422*width, y: 7.08394*height), control1: CGPoint(x: 3.75413*width, y: 7.27099*height), control2: CGPoint(x: 3.77064*width, y: 7.10036*height))
                path.addCurve(to: CGPoint(x: 3.58257*width, y: 6.99361*height), control1: CGPoint(x: 3.75963*width, y: 7.07117*height), control2: CGPoint(x: 3.69817*width, y: 7.04015*height))
                path.addCurve(to: CGPoint(x: 3.42018*width, y: 6.92427*height), control1: CGPoint(x: 3.47339*width, y: 6.94891*height), control2: CGPoint(x: 3.43945*width, y: 6.93431*height))
                path.addCurve(to: CGPoint(x: 3.27982*width, y: 6.94434*height), control1: CGPoint(x: 3.39266*width, y: 6.90967*height), control2: CGPoint(x: 3.35046*width, y: 6.91606*height))
                path.addCurve(to: CGPoint(x: 3.16881*width, y: 6.97993*height), control1: CGPoint(x: 3.26972*width, y: 6.94799*height), control2: CGPoint(x: 3.22018*width, y: 6.96442*height))
                path.addCurve(to: CGPoint(x: 3.04312*width, y: 7.36131*height), control1: CGPoint(x: 3.02569*width, y: 7.02281*height), control2: CGPoint(x: 3.03578*width, y: 6.99088*height))
                path.addCurve(to: CGPoint(x: 3.10275*width, y: 7.70073*height), control1: CGPoint(x: 3.04954*width, y: 7.69982*height), control2: CGPoint(x: 3.04679*width, y: 7.68704*height))
                path.addCurve(to: CGPoint(x: 3.1789*width, y: 7.72263*height), control1: CGPoint(x: 3.11927*width, y: 7.70529*height), control2: CGPoint(x: 3.15413*width, y: 7.71533*height))
                path.addCurve(to: CGPoint(x: 3.36697*width, y: 7.73084*height), control1: CGPoint(x: 3.21468*width, y: 7.73358*height), control2: CGPoint(x: 3.25596*width, y: 7.7354*height))
                path.addLine(to: CGPoint(x: 3.50917*width, y: 7.72628*height))
                path.addLine(to: CGPoint(x: 3.53853*width, y: 7.69708*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.92018*width, y: 7.70347*height))
                path.addCurve(to: CGPoint(x: 2.97706*width, y: 7.68066*height), control1: CGPoint(x: 2.94954*width, y: 7.69343*height), control2: CGPoint(x: 2.97523*width, y: 7.68248*height))
                path.addCurve(to: CGPoint(x: 2.98716*width, y: 7.36223*height), control1: CGPoint(x: 2.97982*width, y: 7.67883*height), control2: CGPoint(x: 2.9844*width, y: 7.53558*height))
                path.addCurve(to: CGPoint(x: 2.97431*width, y: 7.02828*height), control1: CGPoint(x: 2.99266*width, y: 7.05292*height), control2: CGPoint(x: 2.99266*width, y: 7.04836*height))
                path.addCurve(to: CGPoint(x: 2.83303*width, y: 6.9708*height), control1: CGPoint(x: 2.96239*width, y: 7.01642*height), control2: CGPoint(x: 2.90826*width, y: 6.99453*height))
                path.addCurve(to: CGPoint(x: 2.69541*width, y: 6.92427*height), control1: CGPoint(x: 2.76606*width, y: 6.94982*height), control2: CGPoint(x: 2.70367*width, y: 6.92883*height))
                path.addCurve(to: CGPoint(x: 2.65688*width, y: 6.91606*height), control1: CGPoint(x: 2.68624*width, y: 6.91971*height), control2: CGPoint(x: 2.66972*width, y: 6.91606*height))
                path.addCurve(to: CGPoint(x: 2.29541*width, y: 7.05931*height), control1: CGPoint(x: 2.63303*width, y: 6.91606*height), control2: CGPoint(x: 2.44587*width, y: 6.98996*height))
                path.addLine(to: CGPoint(x: 2.26606*width, y: 7.07299*height))
                path.addLine(to: CGPoint(x: 2.27156*width, y: 7.17518*height))
                path.addCurve(to: CGPoint(x: 2.2844*width, y: 7.29471*height), control1: CGPoint(x: 2.27431*width, y: 7.23084*height), control2: CGPoint(x: 2.27982*width, y: 7.28467*height))
                path.addCurve(to: CGPoint(x: 2.30734*width, y: 7.3677*height), control1: CGPoint(x: 2.28807*width, y: 7.30474*height), control2: CGPoint(x: 2.29908*width, y: 7.33759*height))
                path.addCurve(to: CGPoint(x: 2.48532*width, y: 7.69343*height), control1: CGPoint(x: 2.34037*width, y: 7.48175*height), control2: CGPoint(x: 2.41927*width, y: 7.62682*height))
                path.addLine(to: CGPoint(x: 2.51835*width, y: 7.7281*height))
                path.addLine(to: CGPoint(x: 2.69266*width, y: 7.72536*height))
                path.addCurve(to: CGPoint(x: 2.92018*width, y: 7.70347*height), control1: CGPoint(x: 2.84128*width, y: 7.72263*height), control2: CGPoint(x: 2.87523*width, y: 7.71989*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
