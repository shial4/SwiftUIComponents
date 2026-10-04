import SwiftUI

extension MuscleMap.Back {
    public struct Trapezius: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Trapezius().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.92477*width, y: 7.45529*height))
                path.addLine(to: CGPoint(x: 6.92661*width, y: 6.40328*height))
                path.addLine(to: CGPoint(x: 6.89266*width, y: 6.40967*height))
                path.addCurve(to: CGPoint(x: 6.85688*width, y: 6.41697*height), control1: CGPoint(x: 6.87339*width, y: 6.41332*height), control2: CGPoint(x: 6.85688*width, y: 6.41697*height))
                path.addCurve(to: CGPoint(x: 6.73394*width, y: 6.61953*height), control1: CGPoint(x: 6.85321*width, y: 6.42245*height), control2: CGPoint(x: 6.74679*width, y: 6.59763*height))
                path.addCurve(to: CGPoint(x: 6.62569*width, y: 6.79745*height), control1: CGPoint(x: 6.72477*width, y: 6.63504*height), control2: CGPoint(x: 6.67615*width, y: 6.71442*height))
                path.addLine(to: CGPoint(x: 6.53394*width, y: 6.94891*height))
                path.addLine(to: CGPoint(x: 6.52385*width, y: 7.05292*height))
                path.addCurve(to: CGPoint(x: 6.50459*width, y: 7.29015*height), control1: CGPoint(x: 6.51835*width, y: 7.1104*height), control2: CGPoint(x: 6.51009*width, y: 7.21715*height))
                path.addCurve(to: CGPoint(x: 6.48991*width, y: 7.50274*height), control1: CGPoint(x: 6.5*width, y: 7.36314*height), control2: CGPoint(x: 6.49266*width, y: 7.45894*height))
                path.addLine(to: CGPoint(x: 6.48349*width, y: 7.58394*height))
                path.addLine(to: CGPoint(x: 6.3367*width, y: 7.68066*height))
                path.addCurve(to: CGPoint(x: 6.18624*width, y: 7.78832*height), control1: CGPoint(x: 6.25596*width, y: 7.73449*height), control2: CGPoint(x: 6.18807*width, y: 7.78285*height))
                path.addCurve(to: CGPoint(x: 6.30917*width, y: 7.8677*height), control1: CGPoint(x: 6.1844*width, y: 7.79288*height), control2: CGPoint(x: 6.24037*width, y: 7.82938*height))
                path.addCurve(to: CGPoint(x: 6.47706*width, y: 7.96259*height), control1: CGPoint(x: 6.3789*width, y: 7.90693*height), control2: CGPoint(x: 6.45413*width, y: 7.94891*height))
                path.addCurve(to: CGPoint(x: 6.6578*width, y: 8.06296*height), control1: CGPoint(x: 6.56147*width, y: 8.01095*height), control2: CGPoint(x: 6.61101*width, y: 8.03923*height))
                path.addLine(to: CGPoint(x: 6.7055*width, y: 8.08759*height))
                path.addLine(to: CGPoint(x: 6.70367*width, y: 8.25639*height))
                path.addLine(to: CGPoint(x: 6.70183*width, y: 8.42609*height))
                path.addLine(to: CGPoint(x: 6.7844*width, y: 8.46898*height))
                path.addCurve(to: CGPoint(x: 6.8945*width, y: 8.51004*height), control1: CGPoint(x: 6.83853*width, y: 8.49818*height), control2: CGPoint(x: 6.87615*width, y: 8.51186*height))
                path.addLine(to: CGPoint(x: 6.92202*width, y: 8.50821*height))
                path.addLine(to: CGPoint(x: 6.92477*width, y: 7.45529*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.09908*width, y: 8.47263*height))
                path.addCurve(to: CGPoint(x: 7.18899*width, y: 8.41971*height), control1: CGPoint(x: 7.14404*width, y: 8.45073*height), control2: CGPoint(x: 7.1844*width, y: 8.42701*height))
                path.addCurve(to: CGPoint(x: 7.19174*width, y: 8.31204*height), control1: CGPoint(x: 7.1945*width, y: 8.41241*height), control2: CGPoint(x: 7.19633*width, y: 8.37226*height))
                path.addCurve(to: CGPoint(x: 7.19174*width, y: 8.08394*height), control1: CGPoint(x: 7.18257*width, y: 8.16971*height), control2: CGPoint(x: 7.18257*width, y: 8.08394*height))
                path.addCurve(to: CGPoint(x: 7.30275*width, y: 8.02464*height), control1: CGPoint(x: 7.19725*width, y: 8.08394*height), control2: CGPoint(x: 7.24679*width, y: 8.05748*height))
                path.addCurve(to: CGPoint(x: 7.40917*width, y: 7.96533*height), control1: CGPoint(x: 7.35872*width, y: 7.99179*height), control2: CGPoint(x: 7.40642*width, y: 7.96533*height))
                path.addCurve(to: CGPoint(x: 7.44771*width, y: 7.94434*height), control1: CGPoint(x: 7.41101*width, y: 7.96533*height), control2: CGPoint(x: 7.42844*width, y: 7.9562*height))
                path.addCurve(to: CGPoint(x: 7.53211*width, y: 7.89507*height), control1: CGPoint(x: 7.46606*width, y: 7.93248*height), control2: CGPoint(x: 7.50459*width, y: 7.91058*height))
                path.addCurve(to: CGPoint(x: 7.69174*width, y: 7.80474*height), control1: CGPoint(x: 7.58349*width, y: 7.86679*height), control2: CGPoint(x: 7.66147*width, y: 7.82299*height))
                path.addCurve(to: CGPoint(x: 7.70275*width, y: 7.78467*height), control1: CGPoint(x: 7.70092*width, y: 7.79927*height), control2: CGPoint(x: 7.70642*width, y: 7.79015*height))
                path.addCurve(to: CGPoint(x: 7.55138*width, y: 7.67974*height), control1: CGPoint(x: 7.69908*width, y: 7.7792*height), control2: CGPoint(x: 7.63119*width, y: 7.73175*height))
                path.addLine(to: CGPoint(x: 7.40642*width, y: 7.58485*height))
                path.addLine(to: CGPoint(x: 7.4*width, y: 7.49453*height))
                path.addCurve(to: CGPoint(x: 7.37064*width, y: 7.06204*height), control1: CGPoint(x: 7.38991*width, y: 7.35858*height), control2: CGPoint(x: 7.37706*width, y: 7.16971*height))
                path.addCurve(to: CGPoint(x: 7.25596*width, y: 6.78376*height), control1: CGPoint(x: 7.36422*width, y: 6.95803*height), control2: CGPoint(x: 7.36147*width, y: 6.95164*height))
                path.addCurve(to: CGPoint(x: 7.15138*width, y: 6.6104*height), control1: CGPoint(x: 7.23761*width, y: 6.75365*height), control2: CGPoint(x: 7.18991*width, y: 6.67609*height))
                path.addCurve(to: CGPoint(x: 7.00092*width, y: 6.40785*height), control1: CGPoint(x: 7.05229*width, y: 6.44526*height), control2: CGPoint(x: 7.03394*width, y: 6.42062*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 6.39781*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 7.45529*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 8.51277*height))
                path.addLine(to: CGPoint(x: 6.99541*width, y: 8.51277*height))
                path.addCurve(to: CGPoint(x: 7.09908*width, y: 8.47263*height), control1: CGPoint(x: 7.00826*width, y: 8.51277*height), control2: CGPoint(x: 7.05505*width, y: 8.49453*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
