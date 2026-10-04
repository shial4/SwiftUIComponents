import SwiftUI

extension MuscleMap.Back {
    public struct Calves: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Calves().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.60183*width, y: 3.28193*height))
                path.addCurve(to: CGPoint(x: 6.71835*width, y: 3.14507*height), control1: CGPoint(x: 6.62202*width, y: 3.26095*height), control2: CGPoint(x: 6.67431*width, y: 3.19982*height))
                path.addLine(to: CGPoint(x: 6.79817*width, y: 3.04745*height))
                path.addLine(to: CGPoint(x: 6.79817*width, y: 2.98996*height))
                path.addCurve(to: CGPoint(x: 6.78899*width, y: 2.85128*height), control1: CGPoint(x: 6.79817*width, y: 2.95894*height), control2: CGPoint(x: 6.79358*width, y: 2.8969*height))
                path.addCurve(to: CGPoint(x: 6.79725*width, y: 2.68704*height), control1: CGPoint(x: 6.78073*width, y: 2.78011*height), control2: CGPoint(x: 6.78165*width, y: 2.75912*height))
                path.addCurve(to: CGPoint(x: 6.84862*width, y: 2.36314*height), control1: CGPoint(x: 6.82294*width, y: 2.57299*height), control2: CGPoint(x: 6.83394*width, y: 2.50547*height))
                path.addCurve(to: CGPoint(x: 6.79633*width, y: 2.22993*height), control1: CGPoint(x: 6.8633*width, y: 2.21442*height), control2: CGPoint(x: 6.85963*width, y: 2.20529*height))
                path.addCurve(to: CGPoint(x: 6.6578*width, y: 2.31843*height), control1: CGPoint(x: 6.7578*width, y: 2.24544*height), control2: CGPoint(x: 6.69174*width, y: 2.28741*height))
                path.addCurve(to: CGPoint(x: 6.6156*width, y: 2.3385*height), control1: CGPoint(x: 6.64862*width, y: 2.32664*height), control2: CGPoint(x: 6.62936*width, y: 2.33577*height))
                path.addCurve(to: CGPoint(x: 6.53028*width, y: 2.28923*height), control1: CGPoint(x: 6.57064*width, y: 2.34763*height), control2: CGPoint(x: 6.55138*width, y: 2.33668*height))
                path.addCurve(to: CGPoint(x: 6.43486*width, y: 2.19891*height), control1: CGPoint(x: 6.50826*width, y: 2.23723*height), control2: CGPoint(x: 6.46697*width, y: 2.19891*height))
                path.addCurve(to: CGPoint(x: 6.31101*width, y: 2.31296*height), control1: CGPoint(x: 6.4055*width, y: 2.19891*height), control2: CGPoint(x: 6.33211*width, y: 2.26551*height))
                path.addCurve(to: CGPoint(x: 6.30275*width, y: 2.62682*height), control1: CGPoint(x: 6.29083*width, y: 2.35493*height), control2: CGPoint(x: 6.28716*width, y: 2.52464*height))
                path.addCurve(to: CGPoint(x: 6.38073*width, y: 3.0292*height), control1: CGPoint(x: 6.32844*width, y: 2.79471*height), control2: CGPoint(x: 6.34495*width, y: 2.88139*height))
                path.addCurve(to: CGPoint(x: 6.40367*width, y: 3.1688*height), control1: CGPoint(x: 6.39266*width, y: 3.08212*height), control2: CGPoint(x: 6.40367*width, y: 3.14416*height))
                path.addCurve(to: CGPoint(x: 6.43486*width, y: 3.19799*height), control1: CGPoint(x: 6.40367*width, y: 3.21442*height), control2: CGPoint(x: 6.40734*width, y: 3.21807*height))
                path.addCurve(to: CGPoint(x: 6.50183*width, y: 3.19617*height), control1: CGPoint(x: 6.45688*width, y: 3.18157*height), control2: CGPoint(x: 6.48991*width, y: 3.18066*height))
                path.addCurve(to: CGPoint(x: 6.52294*width, y: 3.2573*height), control1: CGPoint(x: 6.50734*width, y: 3.20164*height), control2: CGPoint(x: 6.51651*width, y: 3.22993*height))
                path.addCurve(to: CGPoint(x: 6.55963*width, y: 3.32117*height), control1: CGPoint(x: 6.53303*width, y: 3.30201*height), control2: CGPoint(x: 6.54495*width, y: 3.32117*height))
                path.addCurve(to: CGPoint(x: 6.60183*width, y: 3.28193*height), control1: CGPoint(x: 6.56239*width, y: 3.32117*height), control2: CGPoint(x: 6.58073*width, y: 3.30383*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.35596*width, y: 3.29836*height))
                path.addCurve(to: CGPoint(x: 7.36697*width, y: 3.24909*height), control1: CGPoint(x: 7.36239*width, y: 3.28558*height), control2: CGPoint(x: 7.36697*width, y: 3.26369*height))
                path.addCurve(to: CGPoint(x: 7.42018*width, y: 3.18431*height), control1: CGPoint(x: 7.36697*width, y: 3.2208*height), control2: CGPoint(x: 7.39633*width, y: 3.18431*height))
                path.addCurve(to: CGPoint(x: 7.45505*width, y: 3.19799*height), control1: CGPoint(x: 7.42936*width, y: 3.18431*height), control2: CGPoint(x: 7.44495*width, y: 3.19069*height))
                path.addCurve(to: CGPoint(x: 7.48624*width, y: 3.16697*height), control1: CGPoint(x: 7.48257*width, y: 3.21898*height), control2: CGPoint(x: 7.48624*width, y: 3.21442*height))
                path.addCurve(to: CGPoint(x: 7.50459*width, y: 3.05109*height), control1: CGPoint(x: 7.48624*width, y: 3.14234*height), control2: CGPoint(x: 7.4945*width, y: 3.09033*height))
                path.addCurve(to: CGPoint(x: 7.5789*width, y: 2.69161*height), control1: CGPoint(x: 7.52294*width, y: 2.97993*height), control2: CGPoint(x: 7.55505*width, y: 2.82573*height))
                path.addCurve(to: CGPoint(x: 7.59174*width, y: 2.47172*height), control1: CGPoint(x: 7.58624*width, y: 2.65237*height), control2: CGPoint(x: 7.59174*width, y: 2.55839*height))
                path.addLine(to: CGPoint(x: 7.59174*width, y: 2.32026*height))
                path.addLine(to: CGPoint(x: 7.56606*width, y: 2.28741*height))
                path.addCurve(to: CGPoint(x: 7.46055*width, y: 2.19891*height), control1: CGPoint(x: 7.52477*width, y: 2.23358*height), control2: CGPoint(x: 7.48349*width, y: 2.19891*height))
                path.addCurve(to: CGPoint(x: 7.41193*width, y: 2.21807*height), control1: CGPoint(x: 7.44862*width, y: 2.19891*height), control2: CGPoint(x: 7.42661*width, y: 2.20712*height))
                path.addCurve(to: CGPoint(x: 7.33945*width, y: 2.33942*height), control1: CGPoint(x: 7.38532*width, y: 2.23631*height), control2: CGPoint(x: 7.33945*width, y: 2.31387*height))
                path.addCurve(to: CGPoint(x: 7.31193*width, y: 2.35858*height), control1: CGPoint(x: 7.33945*width, y: 2.34672*height), control2: CGPoint(x: 7.32752*width, y: 2.35493*height))
                path.addCurve(to: CGPoint(x: 7.23119*width, y: 2.31752*height), control1: CGPoint(x: 7.28807*width, y: 2.36405*height), control2: CGPoint(x: 7.27798*width, y: 2.35858*height))
                path.addCurve(to: CGPoint(x: 7.04954*width, y: 2.2208*height), control1: CGPoint(x: 7.17523*width, y: 2.26734*height), control2: CGPoint(x: 7.07156*width, y: 2.21259*height))
                path.addCurve(to: CGPoint(x: 7.07982*width, y: 2.61861*height), control1: CGPoint(x: 7.02294*width, y: 2.23084*height), control2: CGPoint(x: 7.03394*width, y: 2.37591*height))
                path.addCurve(to: CGPoint(x: 7.09817*width, y: 2.89325*height), control1: CGPoint(x: 7.10183*width, y: 2.73084*height), control2: CGPoint(x: 7.10275*width, y: 2.75547*height))
                path.addLine(to: CGPoint(x: 7.09174*width, y: 3.04562*height))
                path.addLine(to: CGPoint(x: 7.13578*width, y: 3.09854*height))
                path.addCurve(to: CGPoint(x: 7.20459*width, y: 3.17701*height), control1: CGPoint(x: 7.15963*width, y: 3.12865*height), control2: CGPoint(x: 7.18991*width, y: 3.16332*height))
                path.addCurve(to: CGPoint(x: 7.22936*width, y: 3.21715*height), control1: CGPoint(x: 7.21835*width, y: 3.19069*height), control2: CGPoint(x: 7.22936*width, y: 3.20894*height))
                path.addCurve(to: CGPoint(x: 7.33578*width, y: 3.32117*height), control1: CGPoint(x: 7.22936*width, y: 3.23358*height), control2: CGPoint(x: 7.31835*width, y: 3.32117*height))
                path.addCurve(to: CGPoint(x: 7.35596*width, y: 3.29836*height), control1: CGPoint(x: 7.34128*width, y: 3.32117*height), control2: CGPoint(x: 7.35046*width, y: 3.31113*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
