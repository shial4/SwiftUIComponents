import SwiftUI

extension MuscleMap.Front {
    public struct Forearms: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 1.72018*width, y: 6.36861*height))
                path.addCurve(to: CGPoint(x: 1.85505*width, y: 6.31661*height), control1: CGPoint(x: 1.73028*width, y: 6.36405*height), control2: CGPoint(x: 1.79083*width, y: 6.34124*height))
                path.addLine(to: CGPoint(x: 1.97156*width, y: 6.27281*height))
                path.addLine(to: CGPoint(x: 1.98807*width, y: 6.23175*height))
                path.addCurve(to: CGPoint(x: 1.81284*width, y: 5.75365*height), control1: CGPoint(x: 2.03028*width, y: 6.125*height), control2: CGPoint(x: 1.97706*width, y: 5.97901*height))
                path.addCurve(to: CGPoint(x: 1.68073*width, y: 5.54836*height), control1: CGPoint(x: 1.7055*width, y: 5.60584*height), control2: CGPoint(x: 1.70183*width, y: 5.59945*height))
                path.addCurve(to: CGPoint(x: 1.62844*width, y: 5.30748*height), control1: CGPoint(x: 1.65321*width, y: 5.48084*height), control2: CGPoint(x: 1.63578*width, y: 5.40328*height))
                path.addCurve(to: CGPoint(x: 1.60183*width, y: 5.22263*height), control1: CGPoint(x: 1.62202*width, y: 5.23631*height), control2: CGPoint(x: 1.61927*width, y: 5.22719*height))
                path.addCurve(to: CGPoint(x: 1.44404*width, y: 5.35219*height), control1: CGPoint(x: 1.55505*width, y: 5.21168*height), control2: CGPoint(x: 1.48532*width, y: 5.26825*height))
                path.addCurve(to: CGPoint(x: 1.42477*width, y: 5.51369*height), control1: CGPoint(x: 1.42018*width, y: 5.40146*height), control2: CGPoint(x: 1.41927*width, y: 5.40602*height))
                path.addCurve(to: CGPoint(x: 1.43945*width, y: 5.69343*height), control1: CGPoint(x: 1.42752*width, y: 5.57482*height), control2: CGPoint(x: 1.43486*width, y: 5.65602*height))
                path.addCurve(to: CGPoint(x: 1.48349*width, y: 5.96715*height), control1: CGPoint(x: 1.46422*width, y: 5.86496*height), control2: CGPoint(x: 1.47064*width, y: 5.90328*height))
                path.addCurve(to: CGPoint(x: 1.52844*width, y: 6.16332*height), control1: CGPoint(x: 1.50826*width, y: 6.0885*height), control2: CGPoint(x: 1.51284*width, y: 6.10766*height))
                path.addCurve(to: CGPoint(x: 1.55046*width, y: 6.24544*height), control1: CGPoint(x: 1.5367*width, y: 6.19343*height), control2: CGPoint(x: 1.54679*width, y: 6.23084*height))
                path.addCurve(to: CGPoint(x: 1.59725*width, y: 6.38869*height), control1: CGPoint(x: 1.5578*width, y: 6.27555*height), control2: CGPoint(x: 1.58349*width, y: 6.35128*height))
                path.addLine(to: CGPoint(x: 1.60734*width, y: 6.41241*height))
                path.addLine(to: CGPoint(x: 1.65413*width, y: 6.39416*height))
                path.addCurve(to: CGPoint(x: 1.72018*width, y: 6.36861*height), control1: CGPoint(x: 1.68073*width, y: 6.38412*height), control2: CGPoint(x: 1.71009*width, y: 6.37226*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 4.45321*width, y: 6.33212*height))
                path.addCurve(to: CGPoint(x: 4.52569*width, y: 6.07664*height), control1: CGPoint(x: 4.47615*width, y: 6.26186*height), control2: CGPoint(x: 4.51743*width, y: 6.11679*height))
                path.addCurve(to: CGPoint(x: 4.54404*width, y: 5.9854*height), control1: CGPoint(x: 4.52752*width, y: 6.06387*height), control2: CGPoint(x: 4.53578*width, y: 6.02281*height))
                path.addCurve(to: CGPoint(x: 4.6055*width, y: 5.54106*height), control1: CGPoint(x: 4.57431*width, y: 5.8385*height), control2: CGPoint(x: 4.59083*width, y: 5.71715*height))
                path.addCurve(to: CGPoint(x: 4.59541*width, y: 5.36861*height), control1: CGPoint(x: 4.61468*width, y: 5.42792*height), control2: CGPoint(x: 4.61376*width, y: 5.4188*height))
                path.addCurve(to: CGPoint(x: 4.42844*width, y: 5.22172*height), control1: CGPoint(x: 4.5633*width, y: 5.28467*height), control2: CGPoint(x: 4.47248*width, y: 5.20438*height))
                path.addCurve(to: CGPoint(x: 4.40459*width, y: 5.31204*height), control1: CGPoint(x: 4.42018*width, y: 5.22445*height), control2: CGPoint(x: 4.41193*width, y: 5.2573*height))
                path.addCurve(to: CGPoint(x: 4.26055*width, y: 5.69434*height), control1: CGPoint(x: 4.38073*width, y: 5.4927*height), control2: CGPoint(x: 4.34495*width, y: 5.58942*height))
                path.addCurve(to: CGPoint(x: 4.0367*width, y: 6.08029*height), control1: CGPoint(x: 4.16972*width, y: 5.80748*height), control2: CGPoint(x: 4.06789*width, y: 5.98358*height))
                path.addCurve(to: CGPoint(x: 4.04771*width, y: 6.24179*height), control1: CGPoint(x: 4.02294*width, y: 6.12226*height), control2: CGPoint(x: 4.02844*width, y: 6.19617*height))
                path.addCurve(to: CGPoint(x: 4.15321*width, y: 6.30931*height), control1: CGPoint(x: 4.06147*width, y: 6.27281*height), control2: CGPoint(x: 4.06972*width, y: 6.27828*height))
                path.addCurve(to: CGPoint(x: 4.33028*width, y: 6.37774*height), control1: CGPoint(x: 4.20275*width, y: 6.32755*height), control2: CGPoint(x: 4.28257*width, y: 6.35858*height))
                path.addCurve(to: CGPoint(x: 4.42385*width, y: 6.40602*height), control1: CGPoint(x: 4.37798*width, y: 6.39599*height), control2: CGPoint(x: 4.42018*width, y: 6.40967*height))
                path.addCurve(to: CGPoint(x: 4.45321*width, y: 6.33212*height), control1: CGPoint(x: 4.42752*width, y: 6.40328*height), control2: CGPoint(x: 4.44037*width, y: 6.36953*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
