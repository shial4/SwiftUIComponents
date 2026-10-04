import SwiftUI

extension MuscleMap.Front {
    public struct TibiaAndFoot: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(TibiaAndFoot().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.39358*width, y: 3.28741*height))
                path.addCurve(to: CGPoint(x: 3.45872*width, y: 3.19708*height), control1: CGPoint(x: 3.42385*width, y: 3.25274*height), control2: CGPoint(x: 3.45413*width, y: 3.21259*height))
                path.addCurve(to: CGPoint(x: 3.51376*width, y: 3.14964*height), control1: CGPoint(x: 3.46606*width, y: 3.17427*height), control2: CGPoint(x: 3.4789*width, y: 3.16423*height))
                path.addCurve(to: CGPoint(x: 3.56422*width, y: 3.08668*height), control1: CGPoint(x: 3.55688*width, y: 3.13139*height), control2: CGPoint(x: 3.55872*width, y: 3.12956*height))
                path.addCurve(to: CGPoint(x: 3.57982*width, y: 2.97628*height), control1: CGPoint(x: 3.56697*width, y: 3.06296*height), control2: CGPoint(x: 3.57431*width, y: 3.01277*height))
                path.addCurve(to: CGPoint(x: 3.58349*width, y: 2.9042*height), control1: CGPoint(x: 3.58532*width, y: 2.93978*height), control2: CGPoint(x: 3.58716*width, y: 2.90785*height))
                path.addCurve(to: CGPoint(x: 3.55505*width, y: 2.90876*height), control1: CGPoint(x: 3.58073*width, y: 2.90146*height), control2: CGPoint(x: 3.56789*width, y: 2.90328*height))
                path.addCurve(to: CGPoint(x: 3.48716*width, y: 2.91971*height), control1: CGPoint(x: 3.5422*width, y: 2.91515*height), control2: CGPoint(x: 3.51101*width, y: 2.91971*height))
                path.addCurve(to: CGPoint(x: 3.41835*width, y: 2.89507*height), control1: CGPoint(x: 3.45138*width, y: 2.91971*height), control2: CGPoint(x: 3.43853*width, y: 2.91515*height))
                path.addCurve(to: CGPoint(x: 3.36606*width, y: 2.08485*height), control1: CGPoint(x: 3.36789*width, y: 2.84489*height), control2: CGPoint(x: 3.36789*width, y: 2.83942*height))
                path.addCurve(to: CGPoint(x: 3.41284*width, y: 1.16788*height), control1: CGPoint(x: 3.36422*width, y: 1.34033*height), control2: CGPoint(x: 3.36514*width, y: 1.32299*height))
                path.addCurve(to: CGPoint(x: 3.40917*width, y: 1.04927*height), control1: CGPoint(x: 3.43761*width, y: 1.08668*height), control2: CGPoint(x: 3.4367*width, y: 1.06022*height))
                path.addCurve(to: CGPoint(x: 3.38073*width, y: 1.00456*height), control1: CGPoint(x: 3.39266*width, y: 1.0438*height), control2: CGPoint(x: 3.38532*width, y: 1.03193*height))
                path.addCurve(to: CGPoint(x: 3.38257*width, y: 0.95529*height), control1: CGPoint(x: 3.37706*width, y: 0.98449*height), control2: CGPoint(x: 3.37798*width, y: 0.96259*height))
                path.addCurve(to: CGPoint(x: 3.49358*width, y: 0.83485*height), control1: CGPoint(x: 3.38624*width, y: 0.94799*height), control2: CGPoint(x: 3.4367*width, y: 0.89416*height))
                path.addCurve(to: CGPoint(x: 3.59633*width, y: 0.70164*height), control1: CGPoint(x: 3.57248*width, y: 0.75091*height), control2: CGPoint(x: 3.59633*width, y: 0.7208*height))
                path.addCurve(to: CGPoint(x: 3.58349*width, y: 0.67245*height), control1: CGPoint(x: 3.59633*width, y: 0.68796*height), control2: CGPoint(x: 3.59083*width, y: 0.67518*height))
                path.addCurve(to: CGPoint(x: 3.37431*width, y: 0.6688*height), control1: CGPoint(x: 3.57706*width, y: 0.66971*height), control2: CGPoint(x: 3.48257*width, y: 0.66788*height))
                path.addCurve(to: CGPoint(x: 3.16239*width, y: 0.68339*height), control1: CGPoint(x: 3.22202*width, y: 0.67062*height), control2: CGPoint(x: 3.17339*width, y: 0.67336*height))
                path.addCurve(to: CGPoint(x: 3.14679*width, y: 0.95347*height), control1: CGPoint(x: 3.14862*width, y: 0.69434*height), control2: CGPoint(x: 3.14679*width, y: 0.72445*height))
                path.addCurve(to: CGPoint(x: 3.16147*width, y: 1.24635*height), control1: CGPoint(x: 3.14679*width, y: 1.17153*height), control2: CGPoint(x: 3.14954*width, y: 1.21715*height))
                path.addCurve(to: CGPoint(x: 3.25229*width, y: 2.33212*height), control1: CGPoint(x: 3.24037*width, y: 1.43157*height), control2: CGPoint(x: 3.28991*width, y: 2.0219*height))
                path.addCurve(to: CGPoint(x: 3.1844*width, y: 2.7354*height), control1: CGPoint(x: 3.2367*width, y: 2.46715*height), control2: CGPoint(x: 3.21927*width, y: 2.56752*height))
                path.addCurve(to: CGPoint(x: 3.15596*width, y: 3.14416*height), control1: CGPoint(x: 3.17523*width, y: 2.78285*height), control2: CGPoint(x: 3.15596*width, y: 3.04745*height))
                path.addLine(to: CGPoint(x: 3.15596*width, y: 3.19161*height))
                path.addLine(to: CGPoint(x: 3.19817*width, y: 3.20164*height))
                path.addCurve(to: CGPoint(x: 3.2844*width, y: 3.26277*height), control1: CGPoint(x: 3.25505*width, y: 3.21624*height), control2: CGPoint(x: 3.2844*width, y: 3.23631*height))
                path.addCurve(to: CGPoint(x: 3.33119*width, y: 3.34854*height), control1: CGPoint(x: 3.2844*width, y: 3.29836*height), control2: CGPoint(x: 3.31101*width, y: 3.34763*height))
                path.addCurve(to: CGPoint(x: 3.39358*width, y: 3.28741*height), control1: CGPoint(x: 3.33486*width, y: 3.34854*height), control2: CGPoint(x: 3.36239*width, y: 3.32117*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.75963*width, y: 3.28923*height))
                path.addCurve(to: CGPoint(x: 2.77064*width, y: 3.25365*height), control1: CGPoint(x: 2.76606*width, y: 3.27646*height), control2: CGPoint(x: 2.77064*width, y: 3.26004*height))
                path.addCurve(to: CGPoint(x: 2.84495*width, y: 3.19799*height), control1: CGPoint(x: 2.77064*width, y: 3.23175*height), control2: CGPoint(x: 2.80642*width, y: 3.20438*height))
                path.addLine(to: CGPoint(x: 2.88349*width, y: 3.19161*height))
                path.addLine(to: CGPoint(x: 2.87706*width, y: 3.12135*height))
                path.addCurve(to: CGPoint(x: 2.86606*width, y: 2.93339*height), control1: CGPoint(x: 2.87431*width, y: 3.08303*height), control2: CGPoint(x: 2.86881*width, y: 2.99909*height))
                path.addCurve(to: CGPoint(x: 2.82477*width, y: 2.62774*height), control1: CGPoint(x: 2.86147*width, y: 2.82755*height), control2: CGPoint(x: 2.85505*width, y: 2.78193*height))
                path.addCurve(to: CGPoint(x: 2.77431*width, y: 1.78832*height), control1: CGPoint(x: 2.76606*width, y: 2.33212*height), control2: CGPoint(x: 2.74771*width, y: 2.03011*height))
                path.addCurve(to: CGPoint(x: 2.8633*width, y: 1.25821*height), control1: CGPoint(x: 2.80917*width, y: 1.46259*height), control2: CGPoint(x: 2.82477*width, y: 1.37318*height))
                path.addCurve(to: CGPoint(x: 2.88073*width, y: 0.95164*height), control1: CGPoint(x: 2.8789*width, y: 1.2135*height), control2: CGPoint(x: 2.88073*width, y: 1.17883*height))
                path.addCurve(to: CGPoint(x: 2.86514*width, y: 0.68339*height), control1: CGPoint(x: 2.88073*width, y: 0.72445*height), control2: CGPoint(x: 2.8789*width, y: 0.69434*height))
                path.addCurve(to: CGPoint(x: 2.64771*width, y: 0.67062*height), control1: CGPoint(x: 2.85413*width, y: 0.67336*height), control2: CGPoint(x: 2.80642*width, y: 0.67062*height))
                path.addLine(to: CGPoint(x: 2.44495*width, y: 0.67062*height))
                path.addLine(to: CGPoint(x: 2.4422*width, y: 0.70255*height))
                path.addCurve(to: CGPoint(x: 2.54495*width, y: 0.84398*height), control1: CGPoint(x: 2.44037*width, y: 0.73175*height), control2: CGPoint(x: 2.44771*width, y: 0.7427*height))
                path.addCurve(to: CGPoint(x: 2.65138*width, y: 0.98814*height), control1: CGPoint(x: 2.64128*width, y: 0.94343*height), control2: CGPoint(x: 2.65046*width, y: 0.9562*height))
                path.addCurve(to: CGPoint(x: 2.62385*width, y: 1.04836*height), control1: CGPoint(x: 2.65138*width, y: 1.01551*height), control2: CGPoint(x: 2.64587*width, y: 1.02828*height))
                path.addLine(to: CGPoint(x: 2.59541*width, y: 1.07299*height))
                path.addLine(to: CGPoint(x: 2.61009*width, y: 1.1323*height))
                path.addCurve(to: CGPoint(x: 2.66239*width, y: 2.06387*height), control1: CGPoint(x: 2.66422*width, y: 1.34672*height), control2: CGPoint(x: 2.66055*width, y: 1.27737*height))
                path.addCurve(to: CGPoint(x: 2.64862*width, y: 2.83394*height), control1: CGPoint(x: 2.66422*width, y: 2.72719*height), control2: CGPoint(x: 2.66239*width, y: 2.79106*height))
                path.addCurve(to: CGPoint(x: 2.61101*width, y: 2.90055*height), control1: CGPoint(x: 2.63945*width, y: 2.85949*height), control2: CGPoint(x: 2.62294*width, y: 2.8896*height))
                path.addCurve(to: CGPoint(x: 2.53486*width, y: 2.91697*height), control1: CGPoint(x: 2.59174*width, y: 2.9188*height), control2: CGPoint(x: 2.58165*width, y: 2.92062*height))
                path.addCurve(to: CGPoint(x: 2.45963*width, y: 2.90602*height), control1: CGPoint(x: 2.5055*width, y: 2.91515*height), control2: CGPoint(x: 2.47156*width, y: 2.90967*height))
                path.addCurve(to: CGPoint(x: 2.44404*width, y: 2.92518*height), control1: CGPoint(x: 2.43945*width, y: 2.89964*height), control2: CGPoint(x: 2.43853*width, y: 2.90055*height))
                path.addCurve(to: CGPoint(x: 2.45872*width, y: 3.02281*height), control1: CGPoint(x: 2.44679*width, y: 2.93978*height), control2: CGPoint(x: 2.45413*width, y: 2.98358*height))
                path.addCurve(to: CGPoint(x: 2.56239*width, y: 3.1688*height), control1: CGPoint(x: 2.47156*width, y: 3.12682*height), control2: CGPoint(x: 2.4789*width, y: 3.13686*height))
                path.addCurve(to: CGPoint(x: 2.63853*width, y: 3.21807*height), control1: CGPoint(x: 2.61743*width, y: 3.19069*height), control2: CGPoint(x: 2.63486*width, y: 3.20073*height))
                path.addCurve(to: CGPoint(x: 2.73945*width, y: 3.31204*height), control1: CGPoint(x: 2.64404*width, y: 3.23996*height), control2: CGPoint(x: 2.7211*width, y: 3.31204*height))
                path.addCurve(to: CGPoint(x: 2.75963*width, y: 3.28923*height), control1: CGPoint(x: 2.74495*width, y: 3.31204*height), control2: CGPoint(x: 2.75413*width, y: 3.30201*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
