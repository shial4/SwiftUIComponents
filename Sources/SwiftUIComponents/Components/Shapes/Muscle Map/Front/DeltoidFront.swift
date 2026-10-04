import SwiftUI

extension MuscleMap.Front {
    public struct Deltoid: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Deltoid().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.37339*width, y: 7.77007*height))
                path.addCurve(to: CGPoint(x: 2.46789*width, y: 7.75091*height), control1: CGPoint(x: 2.42018*width, y: 7.76277*height), control2: CGPoint(x: 2.46239*width, y: 7.75456*height))
                path.addCurve(to: CGPoint(x: 2.41193*width, y: 7.65055*height), control1: CGPoint(x: 2.47982*width, y: 7.74361*height), control2: CGPoint(x: 2.46055*width, y: 7.70803*height))
                path.addCurve(to: CGPoint(x: 2.27982*width, y: 7.3896*height), control1: CGPoint(x: 2.37064*width, y: 7.60219*height), control2: CGPoint(x: 2.3055*width, y: 7.47263*height))
                path.addCurve(to: CGPoint(x: 2.1844*width, y: 7.2281*height), control1: CGPoint(x: 2.25138*width, y: 7.29745*height), control2: CGPoint(x: 2.23578*width, y: 7.27099*height))
                path.addCurve(to: CGPoint(x: 2.11835*width, y: 7.17062*height), control1: CGPoint(x: 2.15688*width, y: 7.20438*height), control2: CGPoint(x: 2.12752*width, y: 7.17883*height))
                path.addCurve(to: CGPoint(x: 1.94312*width, y: 7.03558*height), control1: CGPoint(x: 2.10642*width, y: 7.15876*height), control2: CGPoint(x: 2.01376*width, y: 7.08759*height))
                path.addCurve(to: CGPoint(x: 1.87248*width, y: 7.07299*height), control1: CGPoint(x: 1.91835*width, y: 7.01734*height), control2: CGPoint(x: 1.8844*width, y: 7.03558*height))
                path.addCurve(to: CGPoint(x: 1.83119*width, y: 7.17609*height), control1: CGPoint(x: 1.86789*width, y: 7.08942*height), control2: CGPoint(x: 1.84954*width, y: 7.13595*height))
                path.addCurve(to: CGPoint(x: 1.79817*width, y: 7.34398*height), control1: CGPoint(x: 1.80092*width, y: 7.24453*height), control2: CGPoint(x: 1.79817*width, y: 7.25547*height))
                path.addCurve(to: CGPoint(x: 1.84404*width, y: 7.5812*height), control1: CGPoint(x: 1.79817*width, y: 7.44252*height), control2: CGPoint(x: 1.81376*width, y: 7.52372*height))
                path.addCurve(to: CGPoint(x: 2.03486*width, y: 7.75639*height), control1: CGPoint(x: 1.87156*width, y: 7.63321*height), control2: CGPoint(x: 1.97615*width, y: 7.72993*height))
                path.addCurve(to: CGPoint(x: 2.18807*width, y: 7.78193*height), control1: CGPoint(x: 2.08165*width, y: 7.77828*height), control2: CGPoint(x: 2.09817*width, y: 7.78102*height))
                path.addCurve(to: CGPoint(x: 2.37339*width, y: 7.77007*height), control1: CGPoint(x: 2.24404*width, y: 7.78193*height), control2: CGPoint(x: 2.32661*width, y: 7.77646*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.96514*width, y: 7.7646*height))
                path.addCurve(to: CGPoint(x: 4.00734*width, y: 7.74635*height), control1: CGPoint(x: 3.98165*width, y: 7.75456*height), control2: CGPoint(x: 4.00092*width, y: 7.74635*height))
                path.addCurve(to: CGPoint(x: 4.14771*width, y: 7.6323*height), control1: CGPoint(x: 4.03211*width, y: 7.74635*height), control2: CGPoint(x: 4.11376*width, y: 7.67974*height))
                path.addCurve(to: CGPoint(x: 4.22936*width, y: 7.45985*height), control1: CGPoint(x: 4.19725*width, y: 7.56204*height), control2: CGPoint(x: 4.20734*width, y: 7.54015*height))
                path.addCurve(to: CGPoint(x: 4.22018*width, y: 7.21259*height), control1: CGPoint(x: 4.25046*width, y: 7.37865*height), control2: CGPoint(x: 4.24771*width, y: 7.28741*height))
                path.addCurve(to: CGPoint(x: 4.1211*width, y: 7.0073*height), control1: CGPoint(x: 4.1945*width, y: 7.14142*height), control2: CGPoint(x: 4.12936*width, y: 7.0073*height))
                path.addCurve(to: CGPoint(x: 3.93028*width, y: 7.15967*height), control1: CGPoint(x: 4.11468*width, y: 7.0073*height), control2: CGPoint(x: 4.06606*width, y: 7.04653*height))
                path.addCurve(to: CGPoint(x: 3.86697*width, y: 7.21259*height), control1: CGPoint(x: 3.90734*width, y: 7.17883*height), control2: CGPoint(x: 3.8789*width, y: 7.20255*height))
                path.addCurve(to: CGPoint(x: 3.68807*width, y: 7.5292*height), control1: CGPoint(x: 3.83211*width, y: 7.24179*height), control2: CGPoint(x: 3.78349*width, y: 7.32755*height))
                path.addCurve(to: CGPoint(x: 3.63853*width, y: 7.61588*height), control1: CGPoint(x: 3.67248*width, y: 7.56387*height), control2: CGPoint(x: 3.64954*width, y: 7.60219*height))
                path.addCurve(to: CGPoint(x: 3.56514*width, y: 7.74635*height), control1: CGPoint(x: 3.6*width, y: 7.66241*height), control2: CGPoint(x: 3.55688*width, y: 7.73814*height))
                path.addCurve(to: CGPoint(x: 3.82752*width, y: 7.78193*height), control1: CGPoint(x: 3.58073*width, y: 7.76186*height), control2: CGPoint(x: 3.7211*width, y: 7.78102*height))
                path.addCurve(to: CGPoint(x: 3.96514*width, y: 7.7646*height), control1: CGPoint(x: 3.92018*width, y: 7.78285*height), control2: CGPoint(x: 3.93945*width, y: 7.78011*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
