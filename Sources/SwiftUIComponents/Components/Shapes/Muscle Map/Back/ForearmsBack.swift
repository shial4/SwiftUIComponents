import SwiftUI

extension MuscleMap.Back {
    public struct Forearms: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Forearms().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 8.40092*width, y: 6.39781*height))
                path.addCurve(to: CGPoint(x: 8.44495*width, y: 6.29106*height), control1: CGPoint(x: 8.43028*width, y: 6.33485*height), control2: CGPoint(x: 8.4422*width, y: 6.30748*height))
                path.addCurve(to: CGPoint(x: 8.44954*width, y: 6.27555*height), control1: CGPoint(x: 8.44587*width, y: 6.2865*height), control2: CGPoint(x: 8.44771*width, y: 6.2792*height))
                path.addCurve(to: CGPoint(x: 8.46239*width, y: 6.20438*height), control1: CGPoint(x: 8.45321*width, y: 6.26369*height), control2: CGPoint(x: 8.45505*width, y: 6.25639*height))
                path.addCurve(to: CGPoint(x: 8.47615*width, y: 6.14507*height), control1: CGPoint(x: 8.46697*width, y: 6.17701*height), control2: CGPoint(x: 8.47248*width, y: 6.15055*height))
                path.addCurve(to: CGPoint(x: 8.48532*width, y: 6.10401*height), control1: CGPoint(x: 8.47982*width, y: 6.14051*height), control2: CGPoint(x: 8.48349*width, y: 6.12135*height))
                path.addCurve(to: CGPoint(x: 8.52202*width, y: 5.80748*height), control1: CGPoint(x: 8.48991*width, y: 6.05109*height), control2: CGPoint(x: 8.51284*width, y: 5.86588*height))
                path.addCurve(to: CGPoint(x: 8.54679*width, y: 5.38777*height), control1: CGPoint(x: 8.5633*width, y: 5.55657*height), control2: CGPoint(x: 8.56972*width, y: 5.44343*height))
                path.addCurve(to: CGPoint(x: 8.41835*width, y: 5.23631*height), control1: CGPoint(x: 8.51193*width, y: 5.30566*height), control2: CGPoint(x: 8.47615*width, y: 5.26369*height))
                path.addCurve(to: CGPoint(x: 8.34679*width, y: 5.20985*height), control1: CGPoint(x: 8.38716*width, y: 5.22172*height), control2: CGPoint(x: 8.35505*width, y: 5.20985*height))
                path.addCurve(to: CGPoint(x: 8.3156*width, y: 5.32847*height), control1: CGPoint(x: 8.31835*width, y: 5.20985*height), control2: CGPoint(x: 8.30917*width, y: 5.24361*height))
                path.addLine(to: CGPoint(x: 8.3211*width, y: 5.40785*height))
                path.addLine(to: CGPoint(x: 8.27431*width, y: 5.47993*height))
                path.addCurve(to: CGPoint(x: 8.22661*width, y: 5.56387*height), control1: CGPoint(x: 8.24771*width, y: 5.51916*height), control2: CGPoint(x: 8.22661*width, y: 5.55748*height))
                path.addCurve(to: CGPoint(x: 8.21927*width, y: 5.57482*height), control1: CGPoint(x: 8.22661*width, y: 5.56934*height), control2: CGPoint(x: 8.22294*width, y: 5.57482*height))
                path.addCurve(to: CGPoint(x: 8.19817*width, y: 5.60949*height), control1: CGPoint(x: 8.2156*width, y: 5.57482*height), control2: CGPoint(x: 8.20642*width, y: 5.59033*height))
                path.addCurve(to: CGPoint(x: 8.14771*width, y: 5.70712*height), control1: CGPoint(x: 8.18991*width, y: 5.62774*height), control2: CGPoint(x: 8.16697*width, y: 5.67245*height))
                path.addCurve(to: CGPoint(x: 8.09174*width, y: 5.80839*height), control1: CGPoint(x: 8.12752*width, y: 5.7427*height), control2: CGPoint(x: 8.10275*width, y: 5.78741*height))
                path.addCurve(to: CGPoint(x: 8.05688*width, y: 5.86405*height), control1: CGPoint(x: 8.08165*width, y: 5.82938*height), control2: CGPoint(x: 8.06514*width, y: 5.85401*height))
                path.addCurve(to: CGPoint(x: 8.03119*width, y: 5.89964*height), control1: CGPoint(x: 8.04862*width, y: 5.87318*height), control2: CGPoint(x: 8.0367*width, y: 5.8896*height))
                path.addCurve(to: CGPoint(x: 7.98991*width, y: 5.97172*height), control1: CGPoint(x: 8.02569*width, y: 5.90876*height), control2: CGPoint(x: 8.00734*width, y: 5.94161*height))
                path.addLine(to: CGPoint(x: 7.95872*width, y: 6.02646*height))
                path.addLine(to: CGPoint(x: 7.95872*width, y: 6.15146*height))
                path.addCurve(to: CGPoint(x: 7.96514*width, y: 6.28193*height), control1: CGPoint(x: 7.95872*width, y: 6.21989*height), control2: CGPoint(x: 7.96147*width, y: 6.27828*height))
                path.addCurve(to: CGPoint(x: 8.12844*width, y: 6.32391*height), control1: CGPoint(x: 7.97248*width, y: 6.28923*height), control2: CGPoint(x: 8.01101*width, y: 6.29927*height))
                path.addCurve(to: CGPoint(x: 8.23578*width, y: 6.34763*height), control1: CGPoint(x: 8.17615*width, y: 6.33485*height), control2: CGPoint(x: 8.22477*width, y: 6.34489*height))
                path.addCurve(to: CGPoint(x: 8.27798*width, y: 6.38139*height), control1: CGPoint(x: 8.24679*width, y: 6.35036*height), control2: CGPoint(x: 8.26606*width, y: 6.36496*height))
                path.addCurve(to: CGPoint(x: 8.35963*width, y: 6.45894*height), control1: CGPoint(x: 8.31651*width, y: 6.42974*height), control2: CGPoint(x: 8.34771*width, y: 6.45985*height))
                path.addCurve(to: CGPoint(x: 8.40092*width, y: 6.39781*height), control1: CGPoint(x: 8.36606*width, y: 6.45894*height), control2: CGPoint(x: 8.3844*width, y: 6.43157*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 5.5578*width, y: 6.42609*height))
                path.addCurve(to: CGPoint(x: 5.60734*width, y: 6.38595*height), control1: CGPoint(x: 5.57615*width, y: 6.41241*height), control2: CGPoint(x: 5.59908*width, y: 6.39416*height))
                path.addCurve(to: CGPoint(x: 5.71193*width, y: 6.32299*height), control1: CGPoint(x: 5.64679*width, y: 6.34672*height), control2: CGPoint(x: 5.68716*width, y: 6.32299*height))
                path.addCurve(to: CGPoint(x: 5.79817*width, y: 6.31022*height), control1: CGPoint(x: 5.72661*width, y: 6.32391*height), control2: CGPoint(x: 5.76514*width, y: 6.31752*height))
                path.addCurve(to: CGPoint(x: 5.88257*width, y: 6.29562*height), control1: CGPoint(x: 5.83119*width, y: 6.30292*height), control2: CGPoint(x: 5.86881*width, y: 6.29653*height))
                path.addCurve(to: CGPoint(x: 5.93394*width, y: 6.14325*height), control1: CGPoint(x: 5.92752*width, y: 6.29562*height), control2: CGPoint(x: 5.93761*width, y: 6.26551*height))
                path.addLine(to: CGPoint(x: 5.93119*width, y: 6.03558*height))
                path.addLine(to: CGPoint(x: 5.86789*width, y: 5.93066*height))
                path.addCurve(to: CGPoint(x: 5.77431*width, y: 5.7792*height), control1: CGPoint(x: 5.83303*width, y: 5.87318*height), control2: CGPoint(x: 5.79083*width, y: 5.80474*height))
                path.addCurve(to: CGPoint(x: 5.72018*width, y: 5.68431*height), control1: CGPoint(x: 5.75872*width, y: 5.75365*height), control2: CGPoint(x: 5.73394*width, y: 5.71077*height))
                path.addCurve(to: CGPoint(x: 5.67339*width, y: 5.60219*height), control1: CGPoint(x: 5.70642*width, y: 5.65693*height), control2: CGPoint(x: 5.68532*width, y: 5.62044*height))
                path.addCurve(to: CGPoint(x: 5.59083*width, y: 5.34854*height), control1: CGPoint(x: 5.63119*width, y: 5.53741*height), control2: CGPoint(x: 5.59633*width, y: 5.43248*height))
                path.addCurve(to: CGPoint(x: 5.53394*width, y: 5.21077*height), control1: CGPoint(x: 5.5844*width, y: 5.24818*height), control2: CGPoint(x: 5.56789*width, y: 5.20985*height))
                path.addCurve(to: CGPoint(x: 5.42569*width, y: 5.25547*height), control1: CGPoint(x: 5.48532*width, y: 5.2135*height), control2: CGPoint(x: 5.45872*width, y: 5.22354*height))
                path.addCurve(to: CGPoint(x: 5.33761*width, y: 5.43522*height), control1: CGPoint(x: 5.38165*width, y: 5.29653*height), control2: CGPoint(x: 5.32569*width, y: 5.4115*height))
                path.addCurve(to: CGPoint(x: 5.35046*width, y: 5.66697*height), control1: CGPoint(x: 5.34771*width, y: 5.45438*height), control2: CGPoint(x: 5.35413*width, y: 5.56478*height))
                path.addCurve(to: CGPoint(x: 5.35872*width, y: 5.76277*height), control1: CGPoint(x: 5.34954*width, y: 5.70529*height), control2: CGPoint(x: 5.35321*width, y: 5.74909*height))
                path.addCurve(to: CGPoint(x: 5.37615*width, y: 5.89781*height), control1: CGPoint(x: 5.36422*width, y: 5.77737*height), control2: CGPoint(x: 5.37248*width, y: 5.83759*height))
                path.addCurve(to: CGPoint(x: 5.39358*width, y: 6.01551*height), control1: CGPoint(x: 5.38073*width, y: 5.95712*height), control2: CGPoint(x: 5.38807*width, y: 6.01004*height))
                path.addCurve(to: CGPoint(x: 5.40367*width, y: 6.05018*height), control1: CGPoint(x: 5.39908*width, y: 6.02099*height), control2: CGPoint(x: 5.40367*width, y: 6.0365*height))
                path.addCurve(to: CGPoint(x: 5.43119*width, y: 6.16332*height), control1: CGPoint(x: 5.40367*width, y: 6.06296*height), control2: CGPoint(x: 5.4156*width, y: 6.11405*height))
                path.addCurve(to: CGPoint(x: 5.47798*width, y: 6.33577*height), control1: CGPoint(x: 5.44587*width, y: 6.21168*height), control2: CGPoint(x: 5.46789*width, y: 6.28923*height))
                path.addCurve(to: CGPoint(x: 5.51927*width, y: 6.45073*height), control1: CGPoint(x: 5.49725*width, y: 6.41697*height), control2: CGPoint(x: 5.50917*width, y: 6.45073*height))
                path.addCurve(to: CGPoint(x: 5.5578*width, y: 6.42609*height), control1: CGPoint(x: 5.52202*width, y: 6.45073*height), control2: CGPoint(x: 5.53945*width, y: 6.43978*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
