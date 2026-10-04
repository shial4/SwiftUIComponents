import SwiftUI

extension MuscleMap.Back {
    public struct LatissimusDorsi: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(LatissimusDorsi().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.39908*width, y: 6.94252*height))
                path.addCurve(to: CGPoint(x: 6.49633*width, y: 6.91788*height), control1: CGPoint(x: 6.45413*width, y: 6.93613*height), control2: CGPoint(x: 6.48624*width, y: 6.92792*height))
                path.addCurve(to: CGPoint(x: 6.8055*width, y: 6.39872*height), control1: CGPoint(x: 6.52202*width, y: 6.89142*height), control2: CGPoint(x: 6.80826*width, y: 6.4115*height))
                path.addCurve(to: CGPoint(x: 6.68165*width, y: 6.23631*height), control1: CGPoint(x: 6.80367*width, y: 6.39325*height), control2: CGPoint(x: 6.74771*width, y: 6.31934*height))
                path.addCurve(to: CGPoint(x: 6.55963*width, y: 6.06022*height), control1: CGPoint(x: 6.59174*width, y: 6.125*height), control2: CGPoint(x: 6.55963*width, y: 6.07847*height))
                path.addCurve(to: CGPoint(x: 6.54862*width, y: 5.94434*height), control1: CGPoint(x: 6.55963*width, y: 6.04653*height), control2: CGPoint(x: 6.55505*width, y: 5.99453*height))
                path.addCurve(to: CGPoint(x: 6.5*width, y: 5.81387*height), control1: CGPoint(x: 6.53761*width, y: 5.85675*height), control2: CGPoint(x: 6.53578*width, y: 5.85128*height))
                path.addCurve(to: CGPoint(x: 6.45596*width, y: 5.76095*height), control1: CGPoint(x: 6.47982*width, y: 5.79197*height), control2: CGPoint(x: 6.45963*width, y: 5.76825*height))
                path.addCurve(to: CGPoint(x: 6.36055*width, y: 5.79471*height), control1: CGPoint(x: 6.44495*width, y: 5.74179*height), control2: CGPoint(x: 6.43578*width, y: 5.74453*height))
                path.addLine(to: CGPoint(x: 6.29174*width, y: 5.84124*height))
                path.addLine(to: CGPoint(x: 6.29817*width, y: 5.87956*height))
                path.addCurve(to: CGPoint(x: 6.31284*width, y: 5.99453*height), control1: CGPoint(x: 6.30092*width, y: 5.89964*height), control2: CGPoint(x: 6.30826*width, y: 5.95164*height))
                path.addCurve(to: CGPoint(x: 6.33028*width, y: 6.14507*height), control1: CGPoint(x: 6.31743*width, y: 6.03741*height), control2: CGPoint(x: 6.32569*width, y: 6.10493*height))
                path.addCurve(to: CGPoint(x: 6.31193*width, y: 6.55109*height), control1: CGPoint(x: 6.35505*width, y: 6.34033*height), control2: CGPoint(x: 6.35413*width, y: 6.36131*height))
                path.addCurve(to: CGPoint(x: 6.28073*width, y: 6.69252*height), control1: CGPoint(x: 6.30826*width, y: 6.56843*height), control2: CGPoint(x: 6.29358*width, y: 6.6323*height))
                path.addCurve(to: CGPoint(x: 6.24312*width, y: 6.86588*height), control1: CGPoint(x: 6.26789*width, y: 6.75274*height), control2: CGPoint(x: 6.25138*width, y: 6.83029*height))
                path.addCurve(to: CGPoint(x: 6.27339*width, y: 6.95803*height), control1: CGPoint(x: 6.22202*width, y: 6.96533*height), control2: CGPoint(x: 6.22202*width, y: 6.96533*height))
                path.addCurve(to: CGPoint(x: 6.39908*width, y: 6.94252*height), control1: CGPoint(x: 6.29725*width, y: 6.95529*height), control2: CGPoint(x: 6.35413*width, y: 6.94799*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.66606*width, y: 6.94617*height))
                path.addCurve(to: CGPoint(x: 7.65138*width, y: 6.88412*height), control1: CGPoint(x: 7.6633*width, y: 6.93704*height), control2: CGPoint(x: 7.65688*width, y: 6.90967*height))
                path.addCurve(to: CGPoint(x: 7.62844*width, y: 6.77464*height), control1: CGPoint(x: 7.64679*width, y: 6.85949*height), control2: CGPoint(x: 7.63578*width, y: 6.81022*height))
                path.addCurve(to: CGPoint(x: 7.60459*width, y: 6.66515*height), control1: CGPoint(x: 7.62018*width, y: 6.73996*height), control2: CGPoint(x: 7.60917*width, y: 6.69069*height))
                path.addCurve(to: CGPoint(x: 7.58716*width, y: 6.58759*height), control1: CGPoint(x: 7.59908*width, y: 6.64051*height), control2: CGPoint(x: 7.59083*width, y: 6.60493*height))
                path.addCurve(to: CGPoint(x: 7.54037*width, y: 6.33668*height), control1: CGPoint(x: 7.55046*width, y: 6.42153*height), control2: CGPoint(x: 7.53853*width, y: 6.3604*height))
                path.addCurve(to: CGPoint(x: 7.56972*width, y: 6.06752*height), control1: CGPoint(x: 7.5422*width, y: 6.30474*height), control2: CGPoint(x: 7.55596*width, y: 6.17701*height))
                path.addCurve(to: CGPoint(x: 7.58991*width, y: 5.83759*height), control1: CGPoint(x: 7.58716*width, y: 5.92883*height), control2: CGPoint(x: 7.5945*width, y: 5.84398*height))
                path.addCurve(to: CGPoint(x: 7.45413*width, y: 5.74818*height), control1: CGPoint(x: 7.58624*width, y: 5.83029*height), control2: CGPoint(x: 7.46055*width, y: 5.74818*height))
                path.addCurve(to: CGPoint(x: 7.36055*width, y: 5.84854*height), control1: CGPoint(x: 7.44862*width, y: 5.74818*height), control2: CGPoint(x: 7.37615*width, y: 5.82664*height))
                path.addCurve(to: CGPoint(x: 7.33945*width, y: 5.97263*height), control1: CGPoint(x: 7.35413*width, y: 5.85766*height), control2: CGPoint(x: 7.34495*width, y: 5.91332*height))
                path.addCurve(to: CGPoint(x: 7.31651*width, y: 6.10128*height), control1: CGPoint(x: 7.33394*width, y: 6.03741*height), control2: CGPoint(x: 7.32477*width, y: 6.0885*height))
                path.addCurve(to: CGPoint(x: 7.14679*width, y: 6.31387*height), control1: CGPoint(x: 7.30367*width, y: 6.12044*height), control2: CGPoint(x: 7.1578*width, y: 6.30383*height))
                path.addCurve(to: CGPoint(x: 7.08257*width, y: 6.40146*height), control1: CGPoint(x: 7.13394*width, y: 6.32664*height), control2: CGPoint(x: 7.08257*width, y: 6.39599*height))
                path.addCurve(to: CGPoint(x: 7.39725*width, y: 6.92245*height), control1: CGPoint(x: 7.08257*width, y: 6.41423*height), control2: CGPoint(x: 7.37798*width, y: 6.90328*height))
                path.addCurve(to: CGPoint(x: 7.50459*width, y: 6.94343*height), control1: CGPoint(x: 7.40367*width, y: 6.92792*height), control2: CGPoint(x: 7.45138*width, y: 6.93796*height))
                path.addCurve(to: CGPoint(x: 7.60459*width, y: 6.95803*height), control1: CGPoint(x: 7.5578*width, y: 6.94891*height), control2: CGPoint(x: 7.60275*width, y: 6.95529*height))
                path.addCurve(to: CGPoint(x: 7.63945*width, y: 6.96168*height), control1: CGPoint(x: 7.60642*width, y: 6.95985*height), control2: CGPoint(x: 7.62294*width, y: 6.96168*height))
                path.addCurve(to: CGPoint(x: 7.66606*width, y: 6.94617*height), control1: CGPoint(x: 7.66514*width, y: 6.96168*height), control2: CGPoint(x: 7.66972*width, y: 6.95894*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
