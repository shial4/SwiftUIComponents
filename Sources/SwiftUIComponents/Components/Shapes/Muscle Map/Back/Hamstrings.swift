import SwiftUI

extension MuscleMap.Back {
    public struct Hamstrings: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Hamstrings().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.67798*width, y: 4.74635*height))
                path.addCurve(to: CGPoint(x: 6.86697*width, y: 4.34763*height), control1: CGPoint(x: 6.79174*width, y: 4.62682*height), control2: CGPoint(x: 6.83945*width, y: 4.52646*height))
                path.addCurve(to: CGPoint(x: 6.8633*width, y: 3.57208*height), control1: CGPoint(x: 6.88073*width, y: 4.25912*height), control2: CGPoint(x: 6.87982*width, y: 3.99726*height))
                path.addCurve(to: CGPoint(x: 6.83578*width, y: 3.29653*height), control1: CGPoint(x: 6.85688*width, y: 3.38777*height), control2: CGPoint(x: 6.85229*width, y: 3.34398*height))
                path.addCurve(to: CGPoint(x: 6.81651*width, y: 3.21442*height), control1: CGPoint(x: 6.82569*width, y: 3.26551*height), control2: CGPoint(x: 6.81651*width, y: 3.2281*height))
                path.addCurve(to: CGPoint(x: 6.79908*width, y: 3.12044*height), control1: CGPoint(x: 6.81651*width, y: 3.17701*height), control2: CGPoint(x: 6.8055*width, y: 3.12044*height))
                path.addCurve(to: CGPoint(x: 6.77431*width, y: 3.14781*height), control1: CGPoint(x: 6.79633*width, y: 3.12044*height), control2: CGPoint(x: 6.78532*width, y: 3.13321*height))
                path.addCurve(to: CGPoint(x: 6.71284*width, y: 3.22354*height), control1: CGPoint(x: 6.76422*width, y: 3.16332*height), control2: CGPoint(x: 6.73578*width, y: 3.19708*height))
                path.addCurve(to: CGPoint(x: 6.63211*width, y: 3.31387*height), control1: CGPoint(x: 6.68899*width, y: 3.24909*height), control2: CGPoint(x: 6.65321*width, y: 3.29015*height))
                path.addCurve(to: CGPoint(x: 6.53578*width, y: 3.36314*height), control1: CGPoint(x: 6.59083*width, y: 3.36131*height), control2: CGPoint(x: 6.57064*width, y: 3.37135*height))
                path.addCurve(to: CGPoint(x: 6.47706*width, y: 3.26004*height), control1: CGPoint(x: 6.51101*width, y: 3.35675*height), control2: CGPoint(x: 6.47798*width, y: 3.29745*height))
                path.addCurve(to: CGPoint(x: 6.42294*width, y: 3.26734*height), control1: CGPoint(x: 6.47706*width, y: 3.23084*height), control2: CGPoint(x: 6.45505*width, y: 3.23358*height))
                path.addCurve(to: CGPoint(x: 6.33945*width, y: 3.44161*height), control1: CGPoint(x: 6.39725*width, y: 3.2938*height), control2: CGPoint(x: 6.33945*width, y: 3.41515*height))
                path.addCurve(to: CGPoint(x: 6.30183*width, y: 3.51734*height), control1: CGPoint(x: 6.33945*width, y: 3.44799*height), control2: CGPoint(x: 6.32202*width, y: 3.48266*height))
                path.addCurve(to: CGPoint(x: 6.18532*width, y: 3.74635*height), control1: CGPoint(x: 6.24037*width, y: 3.62135*height), control2: CGPoint(x: 6.21468*width, y: 3.67062*height))
                path.addCurve(to: CGPoint(x: 6.11927*width, y: 3.98449*height), control1: CGPoint(x: 6.16055*width, y: 3.81113*height), control2: CGPoint(x: 6.14954*width, y: 3.85128*height))
                path.addCurve(to: CGPoint(x: 6.12294*width, y: 4.38412*height), control1: CGPoint(x: 6.1055*width, y: 4.04288*height), control2: CGPoint(x: 6.10826*width, y: 4.31022*height))
                path.addCurve(to: CGPoint(x: 6.24771*width, y: 4.68066*height), control1: CGPoint(x: 6.14495*width, y: 4.49635*height), control2: CGPoint(x: 6.18165*width, y: 4.58485*height))
                path.addCurve(to: CGPoint(x: 6.47248*width, y: 4.77007*height), control1: CGPoint(x: 6.30367*width, y: 4.76277*height), control2: CGPoint(x: 6.29725*width, y: 4.76004*height))
                path.addCurve(to: CGPoint(x: 6.6367*width, y: 4.7792*height), control1: CGPoint(x: 6.55872*width, y: 4.77464*height), control2: CGPoint(x: 6.63211*width, y: 4.7792*height))
                path.addCurve(to: CGPoint(x: 6.67798*width, y: 4.74635*height), control1: CGPoint(x: 6.64037*width, y: 4.78011*height), control2: CGPoint(x: 6.65963*width, y: 4.76551*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.5945*width, y: 4.73084*height))
                path.addCurve(to: CGPoint(x: 7.70826*width, y: 4.56934*height), control1: CGPoint(x: 7.66422*width, y: 4.6469*height), control2: CGPoint(x: 7.6844*width, y: 4.61861*height))
                path.addCurve(to: CGPoint(x: 7.65046*width, y: 3.625*height), control1: CGPoint(x: 7.83211*width, y: 4.30748*height), control2: CGPoint(x: 7.80917*width, y: 3.92336*height))
                path.addCurve(to: CGPoint(x: 7.58991*width, y: 3.51916*height), control1: CGPoint(x: 7.62936*width, y: 3.58577*height), control2: CGPoint(x: 7.60183*width, y: 3.53832*height))
                path.addCurve(to: CGPoint(x: 7.54587*width, y: 3.42062*height), control1: CGPoint(x: 7.57798*width, y: 3.5*height), control2: CGPoint(x: 7.5578*width, y: 3.4562*height))
                path.addCurve(to: CGPoint(x: 7.42752*width, y: 3.24179*height), control1: CGPoint(x: 7.51193*width, y: 3.31934*height), control2: CGPoint(x: 7.45321*width, y: 3.23175*height))
                path.addCurve(to: CGPoint(x: 7.40826*width, y: 3.27828*height), control1: CGPoint(x: 7.42018*width, y: 3.24453*height), control2: CGPoint(x: 7.41101*width, y: 3.26095*height))
                path.addCurve(to: CGPoint(x: 7.3844*width, y: 3.3385*height), control1: CGPoint(x: 7.40459*width, y: 3.29562*height), control2: CGPoint(x: 7.3945*width, y: 3.32299*height))
                path.addCurve(to: CGPoint(x: 7.26697*width, y: 3.32391*height), control1: CGPoint(x: 7.3578*width, y: 3.3823*height), control2: CGPoint(x: 7.32018*width, y: 3.37774*height))
                path.addCurve(to: CGPoint(x: 7.20183*width, y: 3.24909*height), control1: CGPoint(x: 7.24312*width, y: 3.29927*height), control2: CGPoint(x: 7.21376*width, y: 3.26642*height))
                path.addCurve(to: CGPoint(x: 7.15229*width, y: 3.18978*height), control1: CGPoint(x: 7.18899*width, y: 3.23266*height), control2: CGPoint(x: 7.16697*width, y: 3.20529*height))
                path.addCurve(to: CGPoint(x: 7.11284*width, y: 3.14142*height), control1: CGPoint(x: 7.13761*width, y: 3.17427*height), control2: CGPoint(x: 7.12018*width, y: 3.15237*height))
                path.addCurve(to: CGPoint(x: 7.08257*width, y: 3.18248*height), control1: CGPoint(x: 7.08991*width, y: 3.10675*height), control2: CGPoint(x: 7.08257*width, y: 3.11679*height))
                path.addCurve(to: CGPoint(x: 7.0633*width, y: 3.29836*height), control1: CGPoint(x: 7.08257*width, y: 3.22263*height), control2: CGPoint(x: 7.07523*width, y: 3.26369*height))
                path.addCurve(to: CGPoint(x: 7.03486*width, y: 3.55839*height), control1: CGPoint(x: 7.04679*width, y: 3.34398*height), control2: CGPoint(x: 7.0422*width, y: 3.38777*height))
                path.addCurve(to: CGPoint(x: 7.03211*width, y: 4.34763*height), control1: CGPoint(x: 7.01927*width, y: 3.90785*height), control2: CGPoint(x: 7.01835*width, y: 4.25547*height))
                path.addCurve(to: CGPoint(x: 7.15229*width, y: 4.66515*height), control1: CGPoint(x: 7.05321*width, y: 4.48358*height), control2: CGPoint(x: 7.09725*width, y: 4.60128*height))
                path.addCurve(to: CGPoint(x: 7.20275*width, y: 4.72719*height), control1: CGPoint(x: 7.16697*width, y: 4.68248*height), control2: CGPoint(x: 7.18991*width, y: 4.71077*height))
                path.addLine(to: CGPoint(x: 7.22661*width, y: 4.75821*height))
                path.addLine(to: CGPoint(x: 7.39817*width, y: 4.75912*height))
                path.addLine(to: CGPoint(x: 7.56881*width, y: 4.76095*height))
                path.addLine(to: CGPoint(x: 7.5945*width, y: 4.73084*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
