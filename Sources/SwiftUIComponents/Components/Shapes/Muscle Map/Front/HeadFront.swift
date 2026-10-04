import SwiftUI

extension MuscleMap.Front {
    public struct Head: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Head().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.10642*width, y: 9.33303*height))
                path.addCurve(to: CGPoint(x: 3.21743*width, y: 9.30474*height), control1: CGPoint(x: 3.14587*width, y: 9.32755*height), control2: CGPoint(x: 3.19541*width, y: 9.31478*height))
                path.addCurve(to: CGPoint(x: 3.38991*width, y: 8.93248*height), control1: CGPoint(x: 3.32569*width, y: 9.25365*height), control2: CGPoint(x: 3.40459*width, y: 9.08394*height))
                path.addCurve(to: CGPoint(x: 3.38073*width, y: 8.85949*height), control1: CGPoint(x: 3.38716*width, y: 8.89964*height), control2: CGPoint(x: 3.38257*width, y: 8.86679*height))
                path.addCurve(to: CGPoint(x: 3.38532*width, y: 8.83212*height), control1: CGPoint(x: 3.37798*width, y: 8.85219*height), control2: CGPoint(x: 3.38073*width, y: 8.83942*height))
                path.addCurve(to: CGPoint(x: 3.41284*width, y: 8.83029*height), control1: CGPoint(x: 3.39266*width, y: 8.82026*height), control2: CGPoint(x: 3.39725*width, y: 8.82026*height))
                path.addCurve(to: CGPoint(x: 3.41743*width, y: 8.67701*height), control1: CGPoint(x: 3.46147*width, y: 8.8604*height), control2: CGPoint(x: 3.4633*width, y: 8.80474*height))
                path.addCurve(to: CGPoint(x: 3.37798*width, y: 8.63869*height), control1: CGPoint(x: 3.40917*width, y: 8.6542*height), control2: CGPoint(x: 3.39908*width, y: 8.64416*height))
                path.addCurve(to: CGPoint(x: 3.34037*width, y: 8.58485*height), control1: CGPoint(x: 3.35321*width, y: 8.6323*height), control2: CGPoint(x: 3.34862*width, y: 8.62591*height))
                path.addCurve(to: CGPoint(x: 3.33028*width, y: 8.50821*height), control1: CGPoint(x: 3.33486*width, y: 8.56022*height), control2: CGPoint(x: 3.33028*width, y: 8.52555*height))
                path.addCurve(to: CGPoint(x: 3.22661*width, y: 8.32938*height), control1: CGPoint(x: 3.33028*width, y: 8.45803*height), control2: CGPoint(x: 3.31651*width, y: 8.43431*height))
                path.addLine(to: CGPoint(x: 3.1422*width, y: 8.23084*height))
                path.addLine(to: CGPoint(x: 3.01651*width, y: 8.22993*height))
                path.addLine(to: CGPoint(x: 2.89083*width, y: 8.22993*height))
                path.addLine(to: CGPoint(x: 2.81376*width, y: 8.31934*height))
                path.addCurve(to: CGPoint(x: 2.69817*width, y: 8.53467*height), control1: CGPoint(x: 2.71009*width, y: 8.43887*height), control2: CGPoint(x: 2.70826*width, y: 8.44252*height))
                path.addCurve(to: CGPoint(x: 2.64862*width, y: 8.64234*height), control1: CGPoint(x: 2.68807*width, y: 8.62044*height), control2: CGPoint(x: 2.67982*width, y: 8.63777*height))
                path.addCurve(to: CGPoint(x: 2.58716*width, y: 8.76095*height), control1: CGPoint(x: 2.62477*width, y: 8.64599*height), control2: CGPoint(x: 2.6055*width, y: 8.68431*height))
                path.addCurve(to: CGPoint(x: 2.60367*width, y: 8.83668*height), control1: CGPoint(x: 2.57339*width, y: 8.82026*height), control2: CGPoint(x: 2.5789*width, y: 8.84672*height))
                path.addCurve(to: CGPoint(x: 2.64312*width, y: 8.92518*height), control1: CGPoint(x: 2.64587*width, y: 8.81934*height), control2: CGPoint(x: 2.64679*width, y: 8.82208*height))
                path.addCurve(to: CGPoint(x: 2.74954*width, y: 9.25639*height), control1: CGPoint(x: 2.63853*width, y: 9.07664*height), control2: CGPoint(x: 2.67064*width, y: 9.17883*height))
                path.addCurve(to: CGPoint(x: 2.89908*width, y: 9.33029*height), control1: CGPoint(x: 2.79817*width, y: 9.30566*height), control2: CGPoint(x: 2.81651*width, y: 9.31387*height))
                path.addCurve(to: CGPoint(x: 3.10642*width, y: 9.33303*height), control1: CGPoint(x: 2.97615*width, y: 9.34489*height), control2: CGPoint(x: 3.01927*width, y: 9.34489*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
