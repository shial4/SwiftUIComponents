import SwiftUI

extension MuscleMap.Front {
    public struct ExternalOblique: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(ExternalOblique().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.35963*width, y: 6.97628*height))
                path.addCurve(to: CGPoint(x: 2.49817*width, y: 6.91606*height), control1: CGPoint(x: 2.38624*width, y: 6.96442*height), control2: CGPoint(x: 2.44862*width, y: 6.93704*height))
                path.addCurve(to: CGPoint(x: 2.59174*width, y: 6.87135*height), control1: CGPoint(x: 2.54679*width, y: 6.89507*height), control2: CGPoint(x: 2.58899*width, y: 6.875*height))
                path.addCurve(to: CGPoint(x: 2.58257*width, y: 6.80839*height), control1: CGPoint(x: 2.59358*width, y: 6.8677*height), control2: CGPoint(x: 2.58991*width, y: 6.83942*height))
                path.addCurve(to: CGPoint(x: 2.55229*width, y: 6.56569*height), control1: CGPoint(x: 2.54679*width, y: 6.65785*height), control2: CGPoint(x: 2.54312*width, y: 6.62956*height))
                path.addCurve(to: CGPoint(x: 2.57064*width, y: 6.48358*height), control1: CGPoint(x: 2.55688*width, y: 6.53011*height), control2: CGPoint(x: 2.56514*width, y: 6.49361*height))
                path.addCurve(to: CGPoint(x: 2.58165*width, y: 6.39142*height), control1: CGPoint(x: 2.57615*width, y: 6.47263*height), control2: CGPoint(x: 2.58165*width, y: 6.43157*height))
                path.addCurve(to: CGPoint(x: 2.59541*width, y: 6.29927*height), control1: CGPoint(x: 2.58257*width, y: 6.3458*height), control2: CGPoint(x: 2.58807*width, y: 6.31113*height))
                path.addCurve(to: CGPoint(x: 2.58349*width, y: 6.23905*height), control1: CGPoint(x: 2.60642*width, y: 6.28285*height), control2: CGPoint(x: 2.6055*width, y: 6.27555*height))
                path.addCurve(to: CGPoint(x: 2.55963*width, y: 6.14872*height), control1: CGPoint(x: 2.56606*width, y: 6.20803*height), control2: CGPoint(x: 2.55963*width, y: 6.18613*height))
                path.addCurve(to: CGPoint(x: 2.60642*width, y: 5.97536*height), control1: CGPoint(x: 2.55963*width, y: 6.07482*height), control2: CGPoint(x: 2.58165*width, y: 5.99453*height))
                path.addCurve(to: CGPoint(x: 2.61651*width, y: 5.90055*height), control1: CGPoint(x: 2.62661*width, y: 5.96077*height), control2: CGPoint(x: 2.62661*width, y: 5.95803*height))
                path.addCurve(to: CGPoint(x: 2.64128*width, y: 5.47445*height), control1: CGPoint(x: 2.59725*width, y: 5.79836*height), control2: CGPoint(x: 2.60459*width, y: 5.67974*height))
                path.addCurve(to: CGPoint(x: 2.67798*width, y: 5.3312*height), control1: CGPoint(x: 2.64587*width, y: 5.44708*height), control2: CGPoint(x: 2.66239*width, y: 5.3823*height))
                path.addCurve(to: CGPoint(x: 2.70642*width, y: 5.23175*height), control1: CGPoint(x: 2.69358*width, y: 5.28011*height), control2: CGPoint(x: 2.70642*width, y: 5.2354*height))
                path.addCurve(to: CGPoint(x: 2.62661*width, y: 5.33394*height), control1: CGPoint(x: 2.70642*width, y: 5.22901*height), control2: CGPoint(x: 2.67064*width, y: 5.27464*height))
                path.addCurve(to: CGPoint(x: 2.47431*width, y: 5.53832*height), control1: CGPoint(x: 2.54128*width, y: 5.44982*height), control2: CGPoint(x: 2.49174*width, y: 5.51642*height))
                path.addCurve(to: CGPoint(x: 2.36055*width, y: 5.69799*height), control1: CGPoint(x: 2.44495*width, y: 5.57573*height), control2: CGPoint(x: 2.36881*width, y: 5.68248*height))
                path.addCurve(to: CGPoint(x: 2.37706*width, y: 5.94891*height), control1: CGPoint(x: 2.35138*width, y: 5.71624*height), control2: CGPoint(x: 2.35413*width, y: 5.75182*height))
                path.addCurve(to: CGPoint(x: 2.3789*width, y: 6.41423*height), control1: CGPoint(x: 2.39266*width, y: 6.07938*height), control2: CGPoint(x: 2.39358*width, y: 6.31204*height))
                path.addCurve(to: CGPoint(x: 2.31101*width, y: 6.84763*height), control1: CGPoint(x: 2.36055*width, y: 6.53741*height), control2: CGPoint(x: 2.33211*width, y: 6.72172*height))
                path.addCurve(to: CGPoint(x: 2.35963*width, y: 6.97628*height), control1: CGPoint(x: 2.28257*width, y: 7.02099*height), control2: CGPoint(x: 2.2789*width, y: 7.01277*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.74312*width, y: 6.99179*height))
                path.addCurve(to: CGPoint(x: 3.7156*width, y: 6.81843*height), control1: CGPoint(x: 3.74312*width, y: 6.98358*height), control2: CGPoint(x: 3.72844*width, y: 6.89416*height))
                path.addCurve(to: CGPoint(x: 3.64862*width, y: 6.3823*height), control1: CGPoint(x: 3.7*width, y: 6.72263*height), control2: CGPoint(x: 3.66055*width, y: 6.46624*height))
                path.addCurve(to: CGPoint(x: 3.64862*width, y: 5.99453*height), control1: CGPoint(x: 3.63486*width, y: 6.28193*height), control2: CGPoint(x: 3.63486*width, y: 6.1104*height))
                path.addCurve(to: CGPoint(x: 3.66972*width, y: 5.80566*height), control1: CGPoint(x: 3.65413*width, y: 5.94708*height), control2: CGPoint(x: 3.66422*width, y: 5.86223*height))
                path.addLine(to: CGPoint(x: 3.68073*width, y: 5.70438*height))
                path.addLine(to: CGPoint(x: 3.57615*width, y: 5.56387*height))
                path.addCurve(to: CGPoint(x: 3.34862*width, y: 5.25547*height), control1: CGPoint(x: 3.40367*width, y: 5.33394*height), control2: CGPoint(x: 3.35688*width, y: 5.27007*height))
                path.addCurve(to: CGPoint(x: 3.33945*width, y: 5.28376*height), control1: CGPoint(x: 3.33578*width, y: 5.23266*height), control2: CGPoint(x: 3.33028*width, y: 5.25*height))
                path.addCurve(to: CGPoint(x: 3.3945*width, y: 5.50639*height), control1: CGPoint(x: 3.3633*width, y: 5.36131*height), control2: CGPoint(x: 3.3844*width, y: 5.44799*height))
                path.addCurve(to: CGPoint(x: 3.41376*width, y: 5.61405*height), control1: CGPoint(x: 3.40092*width, y: 5.54197*height), control2: CGPoint(x: 3.40917*width, y: 5.59033*height))
                path.addCurve(to: CGPoint(x: 3.41101*width, y: 5.92153*height), control1: CGPoint(x: 3.42569*width, y: 5.67701*height), control2: CGPoint(x: 3.42385*width, y: 5.88595*height))
                path.addCurve(to: CGPoint(x: 3.43211*width, y: 5.97993*height), control1: CGPoint(x: 3.40183*width, y: 5.95073*height), control2: CGPoint(x: 3.40275*width, y: 5.95347*height))
                path.addLine(to: CGPoint(x: 3.4633*width, y: 6.0073*height))
                path.addLine(to: CGPoint(x: 3.46606*width, y: 6.10675*height))
                path.addCurve(to: CGPoint(x: 3.44495*width, y: 6.2427*height), control1: CGPoint(x: 3.46972*width, y: 6.20164*height), control2: CGPoint(x: 3.46881*width, y: 6.20712*height))
                path.addCurve(to: CGPoint(x: 3.43394*width, y: 6.30383*height), control1: CGPoint(x: 3.4211*width, y: 6.27828*height), control2: CGPoint(x: 3.4211*width, y: 6.28193*height))
                path.addCurve(to: CGPoint(x: 3.45138*width, y: 6.42792*height), control1: CGPoint(x: 3.45229*width, y: 6.33668*height), control2: CGPoint(x: 3.46055*width, y: 6.39507*height))
                path.addCurve(to: CGPoint(x: 3.45872*width, y: 6.4854*height), control1: CGPoint(x: 3.44495*width, y: 6.44891*height), control2: CGPoint(x: 3.44679*width, y: 6.46259*height))
                path.addCurve(to: CGPoint(x: 3.46422*width, y: 6.73631*height), control1: CGPoint(x: 3.48899*width, y: 6.54015*height), control2: CGPoint(x: 3.49083*width, y: 6.62591*height))
                path.addCurve(to: CGPoint(x: 3.50275*width, y: 6.90237*height), control1: CGPoint(x: 3.43028*width, y: 6.87774*height), control2: CGPoint(x: 3.42936*width, y: 6.87226*height))
                path.addCurve(to: CGPoint(x: 3.69725*width, y: 6.98905*height), control1: CGPoint(x: 3.60183*width, y: 6.94434*height), control2: CGPoint(x: 3.68257*width, y: 6.97993*height))
                path.addCurve(to: CGPoint(x: 3.74312*width, y: 6.99179*height), control1: CGPoint(x: 3.71376*width, y: 6.99909*height), control2: CGPoint(x: 3.74312*width, y: 7.00091*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
