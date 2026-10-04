import SwiftUI

extension MuscleMap.Back {
    public struct Foot: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Foot().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.65872*width, y: 2.26095*height))
                path.addCurve(to: CGPoint(x: 6.82477*width, y: 2.18066*height), control1: CGPoint(x: 6.73119*width, y: 2.20529*height), control2: CGPoint(x: 6.78257*width, y: 2.18157*height))
                path.addLine(to: CGPoint(x: 6.85596*width, y: 2.18066*height))
                path.addLine(to: CGPoint(x: 6.84954*width, y: 2.11131*height))
                path.addCurve(to: CGPoint(x: 6.79817*width, y: 1.87956*height), control1: CGPoint(x: 6.8422*width, y: 2.0365*height), control2: CGPoint(x: 6.82569*width, y: 1.96077*height))
                path.addCurve(to: CGPoint(x: 6.80183*width, y: 1.26369*height), control1: CGPoint(x: 6.75046*width, y: 1.74088*height), control2: CGPoint(x: 6.75138*width, y: 1.55201*height))
                path.addCurve(to: CGPoint(x: 6.81651*width, y: 0.94252*height), control1: CGPoint(x: 6.81193*width, y: 1.20347*height), control2: CGPoint(x: 6.81651*width, y: 1.11679*height))
                path.addLine(to: CGPoint(x: 6.81651*width, y: 0.70255*height))
                path.addLine(to: CGPoint(x: 6.79174*width, y: 0.68704*height))
                path.addCurve(to: CGPoint(x: 6.58073*width, y: 0.6688*height), control1: CGPoint(x: 6.77064*width, y: 0.67245*height), control2: CGPoint(x: 6.74128*width, y: 0.67062*height))
                path.addCurve(to: CGPoint(x: 6.38073*width, y: 0.67245*height), control1: CGPoint(x: 6.47798*width, y: 0.66788*height), control2: CGPoint(x: 6.38807*width, y: 0.6688*height))
                path.addCurve(to: CGPoint(x: 6.36697*width, y: 0.7062*height), control1: CGPoint(x: 6.37248*width, y: 0.67518*height), control2: CGPoint(x: 6.36697*width, y: 0.68887*height))
                path.addCurve(to: CGPoint(x: 6.42294*width, y: 0.78923*height), control1: CGPoint(x: 6.36697*width, y: 0.72993*height), control2: CGPoint(x: 6.37798*width, y: 0.74544*height))
                path.addCurve(to: CGPoint(x: 6.53211*width, y: 0.9042*height), control1: CGPoint(x: 6.45413*width, y: 0.81934*height), control2: CGPoint(x: 6.50275*width, y: 0.87135*height))
                path.addCurve(to: CGPoint(x: 6.57798*width, y: 1.00456*height), control1: CGPoint(x: 6.5844*width, y: 0.96442*height), control2: CGPoint(x: 6.58532*width, y: 0.96624*height))
                path.addCurve(to: CGPoint(x: 6.56055*width, y: 1.04745*height), control1: CGPoint(x: 6.57339*width, y: 1.02646*height), control2: CGPoint(x: 6.56606*width, y: 1.04562*height))
                path.addCurve(to: CGPoint(x: 6.53578*width, y: 1.06478*height), control1: CGPoint(x: 6.55505*width, y: 1.04927*height), control2: CGPoint(x: 6.54404*width, y: 1.05748*height))
                path.addCurve(to: CGPoint(x: 6.54679*width, y: 1.17518*height), control1: CGPoint(x: 6.5211*width, y: 1.08029*height), control2: CGPoint(x: 6.52294*width, y: 1.10401*height))
                path.addCurve(to: CGPoint(x: 6.53578*width, y: 1.60128*height), control1: CGPoint(x: 6.57615*width, y: 1.26551*height), control2: CGPoint(x: 6.57156*width, y: 1.46807*height))
                path.addCurve(to: CGPoint(x: 6.46055*width, y: 1.79106*height), control1: CGPoint(x: 6.51376*width, y: 1.68613*height), control2: CGPoint(x: 6.50642*width, y: 1.70438*height))
                path.addCurve(to: CGPoint(x: 6.39541*width, y: 1.93066*height), control1: CGPoint(x: 6.43578*width, y: 1.8385*height), control2: CGPoint(x: 6.4055*width, y: 1.90146*height))
                path.addCurve(to: CGPoint(x: 6.33028*width, y: 2.18339*height), control1: CGPoint(x: 6.36881*width, y: 1.99909*height), control2: CGPoint(x: 6.33028*width, y: 2.15055*height))
                path.addLine(to: CGPoint(x: 6.33028*width, y: 2.20894*height))
                path.addLine(to: CGPoint(x: 6.36422*width, y: 2.18339*height))
                path.addCurve(to: CGPoint(x: 6.44128*width, y: 2.15785*height), control1: CGPoint(x: 6.38991*width, y: 2.16332*height), control2: CGPoint(x: 6.40734*width, y: 2.15785*height))
                path.addCurve(to: CGPoint(x: 6.51835*width, y: 2.18978*height), control1: CGPoint(x: 6.4789*width, y: 2.15785*height), control2: CGPoint(x: 6.48991*width, y: 2.16241*height))
                path.addCurve(to: CGPoint(x: 6.57064*width, y: 2.2646*height), control1: CGPoint(x: 6.53578*width, y: 2.20712*height), control2: CGPoint(x: 6.55963*width, y: 2.24088*height))
                path.addCurve(to: CGPoint(x: 6.59358*width, y: 2.30839*height), control1: CGPoint(x: 6.58165*width, y: 2.28832*height), control2: CGPoint(x: 6.59174*width, y: 2.30839*height))
                path.addCurve(to: CGPoint(x: 6.65872*width, y: 2.26095*height), control1: CGPoint(x: 6.59541*width, y: 2.30839*height), control2: CGPoint(x: 6.62477*width, y: 2.28741*height))
                path.closeSubpath()
            })
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.32385*width, y: 2.25912*height))
                path.addCurve(to: CGPoint(x: 7.44862*width, y: 2.15785*height), control1: CGPoint(x: 7.3633*width, y: 2.18431*height), control2: CGPoint(x: 7.39541*width, y: 2.15785*height))
                path.addCurve(to: CGPoint(x: 7.52844*width, y: 2.18248*height), control1: CGPoint(x: 7.48257*width, y: 2.15785*height), control2: CGPoint(x: 7.50183*width, y: 2.16423*height))
                path.addCurve(to: CGPoint(x: 7.56514*width, y: 2.20529*height), control1: CGPoint(x: 7.54771*width, y: 2.19617*height), control2: CGPoint(x: 7.56422*width, y: 2.2062*height))
                path.addCurve(to: CGPoint(x: 7.53578*width, y: 2.06661*height), control1: CGPoint(x: 7.56789*width, y: 2.20255*height), control2: CGPoint(x: 7.56422*width, y: 2.18431*height))
                path.addCurve(to: CGPoint(x: 7.41468*width, y: 1.75912*height), control1: CGPoint(x: 7.51651*width, y: 1.98175*height), control2: CGPoint(x: 7.47156*width, y: 1.8677*height))
                path.addCurve(to: CGPoint(x: 7.36422*width, y: 1.64507*height), control1: CGPoint(x: 7.38991*width, y: 1.71077*height), control2: CGPoint(x: 7.36697*width, y: 1.65967*height))
                path.addCurve(to: CGPoint(x: 7.34404*width, y: 1.55109*height), control1: CGPoint(x: 7.36147*width, y: 1.63139*height), control2: CGPoint(x: 7.35229*width, y: 1.5885*height))
                path.addCurve(to: CGPoint(x: 7.32844*width, y: 1.3458*height), control1: CGPoint(x: 7.33303*width, y: 1.50365*height), control2: CGPoint(x: 7.32844*width, y: 1.43978*height))
                path.addCurve(to: CGPoint(x: 7.34771*width, y: 1.15876*height), control1: CGPoint(x: 7.32844*width, y: 1.22901*height), control2: CGPoint(x: 7.33119*width, y: 1.20164*height))
                path.addCurve(to: CGPoint(x: 7.34404*width, y: 1.05657*height), control1: CGPoint(x: 7.37339*width, y: 1.09215*height), control2: CGPoint(x: 7.37248*width, y: 1.06934*height))
                path.addCurve(to: CGPoint(x: 7.30826*width, y: 0.9927*height), control1: CGPoint(x: 7.32202*width, y: 1.04653*height), control2: CGPoint(x: 7.31927*width, y: 1.04197*height))
                path.addCurve(to: CGPoint(x: 7.44037*width, y: 0.81843*height), control1: CGPoint(x: 7.30183*width, y: 0.96442*height), control2: CGPoint(x: 7.31376*width, y: 0.94891*height))
                path.addCurve(to: CGPoint(x: 7.5211*width, y: 0.69526*height), control1: CGPoint(x: 7.52018*width, y: 0.7354*height), control2: CGPoint(x: 7.52477*width, y: 0.7281*height))
                path.addLine(to: CGPoint(x: 7.51835*width, y: 0.67062*height))
                path.addLine(to: CGPoint(x: 7.3211*width, y: 0.67062*height))
                path.addCurve(to: CGPoint(x: 7.10275*width, y: 0.68248*height), control1: CGPoint(x: 7.17706*width, y: 0.67062*height), control2: CGPoint(x: 7.11835*width, y: 0.67427*height))
                path.addLine(to: CGPoint(x: 7.08165*width, y: 0.69434*height))
                path.addLine(to: CGPoint(x: 7.08532*width, y: 0.9927*height))
                path.addCurve(to: CGPoint(x: 7.1*width, y: 1.34124*height), control1: CGPoint(x: 7.08807*width, y: 1.15693*height), control2: CGPoint(x: 7.0945*width, y: 1.31387*height))
                path.addCurve(to: CGPoint(x: 7.11927*width, y: 1.52555*height), control1: CGPoint(x: 7.1055*width, y: 1.36861*height), control2: CGPoint(x: 7.11468*width, y: 1.45164*height))
                path.addCurve(to: CGPoint(x: 7.08807*width, y: 1.89781*height), control1: CGPoint(x: 7.13119*width, y: 1.68522*height), control2: CGPoint(x: 7.12294*width, y: 1.78741*height))
                path.addCurve(to: CGPoint(x: 7.0367*width, y: 2.14234*height), control1: CGPoint(x: 7.05688*width, y: 1.99726*height), control2: CGPoint(x: 7.0367*width, y: 2.09307*height))
                path.addCurve(to: CGPoint(x: 7.06697*width, y: 2.18066*height), control1: CGPoint(x: 7.0367*width, y: 2.17974*height), control2: CGPoint(x: 7.03761*width, y: 2.18066*height))
                path.addCurve(to: CGPoint(x: 7.23853*width, y: 2.26642*height), control1: CGPoint(x: 7.1055*width, y: 2.18066*height), control2: CGPoint(x: 7.17431*width, y: 2.21533*height))
                path.addCurve(to: CGPoint(x: 7.29358*width, y: 2.30748*height), control1: CGPoint(x: 7.26606*width, y: 2.28923*height), control2: CGPoint(x: 7.29083*width, y: 2.30748*height))
                path.addCurve(to: CGPoint(x: 7.32385*width, y: 2.25912*height), control1: CGPoint(x: 7.29633*width, y: 2.30839*height), control2: CGPoint(x: 7.31009*width, y: 2.2865*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
