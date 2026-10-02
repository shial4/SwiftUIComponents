import SwiftUI

extension MuscleMap.Front {
    public struct Biceps: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.20734*width, y: 7.15055*height))
                path.addCurve(to: CGPoint(x: 2.19266*width, y: 7.0073*height), control1: CGPoint(x: 2.20459*width, y: 7.12956*height), control2: CGPoint(x: 2.19817*width, y: 7.06478*height))
                path.addCurve(to: CGPoint(x: 2.16514*width, y: 6.83394*height), control1: CGPoint(x: 2.18624*width, y: 6.94982*height), control2: CGPoint(x: 2.17431*width, y: 6.87135*height))
                path.addCurve(to: CGPoint(x: 2.0367*width, y: 6.35036*height), control1: CGPoint(x: 2.11009*width, y: 6.61405*height), control2: CGPoint(x: 2.04404*width, y: 6.36314*height))
                path.addCurve(to: CGPoint(x: 2.0*width, y: 6.32938*height), control1: CGPoint(x: 2.03211*width, y: 6.34124*height), control2: CGPoint(x: 2.0156*width, y: 6.33212*height))
                path.addCurve(to: CGPoint(x: 1.92202*width, y: 6.34124*height), control1: CGPoint(x: 1.97339*width, y: 6.32391*height), control2: CGPoint(x: 1.95963*width, y: 6.32573*height))
                path.addCurve(to: CGPoint(x: 1.81193*width, y: 6.3823*height), control1: CGPoint(x: 1.91193*width, y: 6.3458*height), control2: CGPoint(x: 1.86239*width, y: 6.36405*height))
                path.addCurve(to: CGPoint(x: 1.70459*width, y: 6.42427*height), control1: CGPoint(x: 1.76147*width, y: 6.40055*height), control2: CGPoint(x: 1.71284*width, y: 6.4188*height))
                path.addCurve(to: CGPoint(x: 1.6789*width, y: 6.43248*height), control1: CGPoint(x: 1.69541*width, y: 6.42883*height), control2: CGPoint(x: 1.6844*width, y: 6.43248*height))
                path.addCurve(to: CGPoint(x: 1.62844*width, y: 6.45164*height), control1: CGPoint(x: 1.67339*width, y: 6.43248*height), control2: CGPoint(x: 1.65138*width, y: 6.44069*height))
                path.addLine(to: CGPoint(x: 1.58716*width, y: 6.4708*height))
                path.addLine(to: CGPoint(x: 1.58716*width, y: 6.52281*height))
                path.addCurve(to: CGPoint(x: 1.66972*width, y: 6.87956*height), control1: CGPoint(x: 1.58716*width, y: 6.60036*height), control2: CGPoint(x: 1.62018*width, y: 6.7427*height))
                path.addCurve(to: CGPoint(x: 1.79541*width, y: 7.16241*height), control1: CGPoint(x: 1.69908*width, y: 6.96168*height), control2: CGPoint(x: 1.78807*width, y: 7.16241*height))
                path.addCurve(to: CGPoint(x: 1.85321*width, y: 7.0365*height), control1: CGPoint(x: 1.80092*width, y: 7.16241*height), control2: CGPoint(x: 1.85321*width, y: 7.04927*height))
                path.addCurve(to: CGPoint(x: 1.90275*width, y: 6.9708*height), control1: CGPoint(x: 1.85321*width, y: 7.01825*height), control2: CGPoint(x: 1.88899*width, y: 6.9708*height))
                path.addCurve(to: CGPoint(x: 2.19083*width, y: 7.19161*height), control1: CGPoint(x: 1.9156*width, y: 6.9708*height), control2: CGPoint(x: 2.18532*width, y: 7.17792*height))
                path.addCurve(to: CGPoint(x: 2.20275*width, y: 7.19343*height), control1: CGPoint(x: 2.19266*width, y: 7.19526*height), control2: CGPoint(x: 2.19817*width, y: 7.19617*height))
                path.addCurve(to: CGPoint(x: 2.20734*width, y: 7.15055*height), control1: CGPoint(x: 2.20826*width, y: 7.19069*height), control2: CGPoint(x: 2.21009*width, y: 7.17153*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 4.04495*width, y: 7.02007*height))
                path.addCurve(to: CGPoint(x: 4.07339*width, y: 6.99544*height), control1: CGPoint(x: 4.05321*width, y: 7.01004*height), control2: CGPoint(x: 4.06606*width, y: 6.99909*height))
                path.addCurve(to: CGPoint(x: 4.10917*width, y: 6.97536*height), control1: CGPoint(x: 4.08073*width, y: 6.99179*height), control2: CGPoint(x: 4.09725*width, y: 6.98266*height))
                path.addCurve(to: CGPoint(x: 4.13853*width, y: 6.96624*height), control1: CGPoint(x: 4.12202*width, y: 6.96898*height), control2: CGPoint(x: 4.13486*width, y: 6.96442*height))
                path.addCurve(to: CGPoint(x: 4.22569*width, y: 7.1396*height), control1: CGPoint(x: 4.14495*width, y: 6.9708*height), control2: CGPoint(x: 4.20826*width, y: 7.0958*height))
                path.addLine(to: CGPoint(x: 4.2367*width, y: 7.16697*height))
                path.addLine(to: CGPoint(x: 4.27431*width, y: 7.08668*height))
                path.addCurve(to: CGPoint(x: 4.40734*width, y: 6.45073*height), control1: CGPoint(x: 4.42294*width, y: 6.77464*height), control2: CGPoint(x: 4.48991*width, y: 6.45073*height))
                path.addCurve(to: CGPoint(x: 4.37798*width, y: 6.44252*height), control1: CGPoint(x: 4.4*width, y: 6.45073*height), control2: CGPoint(x: 4.38716*width, y: 6.44708*height))
                path.addCurve(to: CGPoint(x: 4.27064*width, y: 6.40055*height), control1: CGPoint(x: 4.36972*width, y: 6.43796*height), control2: CGPoint(x: 4.3211*width, y: 6.4188*height))
                path.addCurve(to: CGPoint(x: 4.16055*width, y: 6.35949*height), control1: CGPoint(x: 4.22018*width, y: 6.3823*height), control2: CGPoint(x: 4.17064*width, y: 6.36405*height))
                path.addCurve(to: CGPoint(x: 4.03303*width, y: 6.32938*height), control1: CGPoint(x: 4.09174*width, y: 6.3312*height), control2: CGPoint(x: 4.0633*width, y: 6.32391*height))
                path.addCurve(to: CGPoint(x: 3.9945*width, y: 6.34215*height), control1: CGPoint(x: 4.01468*width, y: 6.33212*height), control2: CGPoint(x: 3.99725*width, y: 6.33759*height))
                path.addCurve(to: CGPoint(x: 3.88165*width, y: 6.77464*height), control1: CGPoint(x: 3.98991*width, y: 6.35036*height), control2: CGPoint(x: 3.94771*width, y: 6.51095*height))
                path.addCurve(to: CGPoint(x: 3.82569*width, y: 7.16058*height), control1: CGPoint(x: 3.84862*width, y: 6.90876*height), control2: CGPoint(x: 3.82569*width, y: 7.06569*height))
                path.addLine(to: CGPoint(x: 3.82569*width, y: 7.19891*height))
                path.addLine(to: CGPoint(x: 3.92752*width, y: 7.11953*height))
                path.addCurve(to: CGPoint(x: 4.04495*width, y: 7.02007*height), control1: CGPoint(x: 3.98349*width, y: 7.07482*height), control2: CGPoint(x: 4.0367*width, y: 7.03102*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
