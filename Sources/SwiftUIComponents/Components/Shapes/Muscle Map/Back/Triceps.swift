import SwiftUI

extension MuscleMap.Back {
    public struct Triceps: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Triceps().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.15688*width, y: 7.17792*height))
                path.addCurve(to: CGPoint(x: 6.16881*width, y: 7.04015*height), control1: CGPoint(x: 6.16055*width, y: 7.11861*height), control2: CGPoint(x: 6.16606*width, y: 7.05657*height))
                path.addCurve(to: CGPoint(x: 5.97339*width, y: 6.40146*height), control1: CGPoint(x: 6.18073*width, y: 6.97901*height), control2: CGPoint(x: 6.05688*width, y: 6.57755*height))
                path.addCurve(to: CGPoint(x: 5.86606*width, y: 6.32391*height), control1: CGPoint(x: 5.93394*width, y: 6.31934*height), control2: CGPoint(x: 5.9211*width, y: 6.31113*height))
                path.addCurve(to: CGPoint(x: 5.8*width, y: 6.34215*height), control1: CGPoint(x: 5.84128*width, y: 6.32938*height), control2: CGPoint(x: 5.81193*width, y: 6.33759*height))
                path.addCurve(to: CGPoint(x: 5.75413*width, y: 6.35128*height), control1: CGPoint(x: 5.78807*width, y: 6.34672*height), control2: CGPoint(x: 5.76789*width, y: 6.35036*height))
                path.addCurve(to: CGPoint(x: 5.6055*width, y: 6.43613*height), control1: CGPoint(x: 5.70642*width, y: 6.35219*height), control2: CGPoint(x: 5.66881*width, y: 6.37409*height))
                path.addCurve(to: CGPoint(x: 5.54954*width, y: 6.56204*height), control1: CGPoint(x: 5.54037*width, y: 6.50091*height), control2: CGPoint(x: 5.53211*width, y: 6.51916*height))
                path.addCurve(to: CGPoint(x: 5.57431*width, y: 6.63777*height), control1: CGPoint(x: 5.55413*width, y: 6.57391*height), control2: CGPoint(x: 5.56514*width, y: 6.60766*height))
                path.addCurve(to: CGPoint(x: 5.60275*width, y: 6.73358*height), control1: CGPoint(x: 5.58257*width, y: 6.66788*height), control2: CGPoint(x: 5.59541*width, y: 6.71077*height))
                path.addCurve(to: CGPoint(x: 5.62385*width, y: 6.80201*height), control1: CGPoint(x: 5.61101*width, y: 6.75639*height), control2: CGPoint(x: 5.62018*width, y: 6.78741*height))
                path.addCurve(to: CGPoint(x: 5.69725*width, y: 7.04836*height), control1: CGPoint(x: 5.63486*width, y: 6.84215*height), control2: CGPoint(x: 5.67431*width, y: 6.97445*height))
                path.addCurve(to: CGPoint(x: 5.72385*width, y: 7.1396*height), control1: CGPoint(x: 5.70826*width, y: 7.08394*height), control2: CGPoint(x: 5.72018*width, y: 7.12409*height))
                path.addLine(to: CGPoint(x: 5.73028*width, y: 7.16606*height))
                path.addLine(to: CGPoint(x: 5.74495*width, y: 7.13504*height))
                path.addCurve(to: CGPoint(x: 5.77431*width, y: 7.06752*height), control1: CGPoint(x: 5.75321*width, y: 7.1177*height), control2: CGPoint(x: 5.76606*width, y: 7.08668*height))
                path.addLine(to: CGPoint(x: 5.78899*width, y: 7.03193*height))
                path.addLine(to: CGPoint(x: 5.85321*width, y: 7.10036*height))
                path.addCurve(to: CGPoint(x: 6.1422*width, y: 7.2865*height), control1: CGPoint(x: 5.93394*width, y: 7.18796*height), control2: CGPoint(x: 6.10367*width, y: 7.29745*height))
                path.addCurve(to: CGPoint(x: 6.15688*width, y: 7.17792*height), control1: CGPoint(x: 6.14771*width, y: 7.28558*height), control2: CGPoint(x: 6.15413*width, y: 7.23631*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.79083*width, y: 7.27464*height))
                path.addCurve(to: CGPoint(x: 8.07615*width, y: 7.05383*height), control1: CGPoint(x: 7.88624*width, y: 7.23814*height), control2: CGPoint(x: 7.99817*width, y: 7.15146*height))
                path.addCurve(to: CGPoint(x: 8.13119*width, y: 7.10128*height), control1: CGPoint(x: 8.09725*width, y: 7.02828*height), control2: CGPoint(x: 8.10367*width, y: 7.03376*height))
                path.addCurve(to: CGPoint(x: 8.17706*width, y: 7.10766*height), control1: CGPoint(x: 8.15413*width, y: 7.15693*height), control2: CGPoint(x: 8.16606*width, y: 7.15785*height))
                path.addCurve(to: CGPoint(x: 8.22477*width, y: 6.94343*height), control1: CGPoint(x: 8.17982*width, y: 7.09489*height), control2: CGPoint(x: 8.20092*width, y: 7.02099*height))
                path.addCurve(to: CGPoint(x: 8.30734*width, y: 6.66971*height), control1: CGPoint(x: 8.24771*width, y: 6.86588*height), control2: CGPoint(x: 8.28532*width, y: 6.7427*height))
                path.addCurve(to: CGPoint(x: 8.34954*width, y: 6.52737*height), control1: CGPoint(x: 8.32844*width, y: 6.59672*height), control2: CGPoint(x: 8.34771*width, y: 6.53285*height))
                path.addCurve(to: CGPoint(x: 8.30092*width, y: 6.45985*height), control1: CGPoint(x: 8.35138*width, y: 6.5219*height), control2: CGPoint(x: 8.32936*width, y: 6.49179*height))
                path.addCurve(to: CGPoint(x: 8.24771*width, y: 6.39599*height), control1: CGPoint(x: 8.27156*width, y: 6.42883*height), control2: CGPoint(x: 8.24771*width, y: 6.39964*height))
                path.addCurve(to: CGPoint(x: 7.95688*width, y: 6.33303*height), control1: CGPoint(x: 8.24771*width, y: 6.37591*height), control2: CGPoint(x: 7.97615*width, y: 6.31843*height))
                path.addCurve(to: CGPoint(x: 7.87615*width, y: 6.49635*height), control1: CGPoint(x: 7.94495*width, y: 6.34398*height), control2: CGPoint(x: 7.89908*width, y: 6.43613*height))
                path.addCurve(to: CGPoint(x: 7.85229*width, y: 6.55566*height), control1: CGPoint(x: 7.86789*width, y: 6.51916*height), control2: CGPoint(x: 7.85688*width, y: 6.54562*height))
                path.addCurve(to: CGPoint(x: 7.77156*width, y: 6.81113*height), control1: CGPoint(x: 7.83945*width, y: 6.58668*height), control2: CGPoint(x: 7.80183*width, y: 6.70529*height))
                path.addCurve(to: CGPoint(x: 7.73211*width, y: 6.94526*height), control1: CGPoint(x: 7.75596*width, y: 6.86679*height), control2: CGPoint(x: 7.73853*width, y: 6.92701*height))
                path.addCurve(to: CGPoint(x: 7.74862*width, y: 7.29015*height), control1: CGPoint(x: 7.71835*width, y: 6.99088*height), control2: CGPoint(x: 7.73211*width, y: 7.29015*height))
                path.addCurve(to: CGPoint(x: 7.79083*width, y: 7.27464*height), control1: CGPoint(x: 7.75046*width, y: 7.29015*height), control2: CGPoint(x: 7.76972*width, y: 7.28285*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
