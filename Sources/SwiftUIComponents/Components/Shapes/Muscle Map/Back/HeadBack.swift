import SwiftUI

extension MuscleMap.Back {
    public struct Head: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Head().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.06422*width, y: 9.33029*height))
                path.addCurve(to: CGPoint(x: 7.32018*width, y: 8.92883*height), control1: CGPoint(x: 7.24679*width, y: 9.28741*height), control2: CGPoint(x: 7.32844*width, y: 9.15876*height))
                path.addLine(to: CGPoint(x: 7.31651*width, y: 8.83668*height))
                path.addLine(to: CGPoint(x: 7.34128*width, y: 8.83668*height))
                path.addCurve(to: CGPoint(x: 7.37523*width, y: 8.7719*height), control1: CGPoint(x: 7.38165*width, y: 8.83577*height), control2: CGPoint(x: 7.38807*width, y: 8.82299*height))
                path.addCurve(to: CGPoint(x: 7.30826*width, y: 8.64051*height), control1: CGPoint(x: 7.35596*width, y: 8.69617*height), control2: CGPoint(x: 7.33303*width, y: 8.64964*height))
                path.addCurve(to: CGPoint(x: 7.2633*width, y: 8.53558*height), control1: CGPoint(x: 7.27706*width, y: 8.62956*height), control2: CGPoint(x: 7.26972*width, y: 8.6104*height))
                path.addCurve(to: CGPoint(x: 7.25229*width, y: 8.4562*height), control1: CGPoint(x: 7.26055*width, y: 8.50091*height), control2: CGPoint(x: 7.25505*width, y: 8.46442*height))
                path.addCurve(to: CGPoint(x: 7.2211*width, y: 8.45712*height), control1: CGPoint(x: 7.24587*width, y: 8.44069*height), control2: CGPoint(x: 7.24404*width, y: 8.44069*height))
                path.addCurve(to: CGPoint(x: 7.11651*width, y: 8.51734*height), control1: CGPoint(x: 7.20826*width, y: 8.46624*height), control2: CGPoint(x: 7.16055*width, y: 8.4927*height))
                path.addCurve(to: CGPoint(x: 6.98991*width, y: 8.55657*height), control1: CGPoint(x: 7.04312*width, y: 8.55657*height), control2: CGPoint(x: 7.03119*width, y: 8.56022*height))
                path.addCurve(to: CGPoint(x: 6.90642*width, y: 8.55839*height), control1: CGPoint(x: 6.96422*width, y: 8.55383*height), control2: CGPoint(x: 6.92752*width, y: 8.55474*height))
                path.addCurve(to: CGPoint(x: 6.78073*width, y: 8.52007*height), control1: CGPoint(x: 6.87248*width, y: 8.56478*height), control2: CGPoint(x: 6.86055*width, y: 8.56113*height))
                path.addCurve(to: CGPoint(x: 6.67431*width, y: 8.46168*height), control1: CGPoint(x: 6.73211*width, y: 8.49453*height), control2: CGPoint(x: 6.6844*width, y: 8.46807*height))
                path.addCurve(to: CGPoint(x: 6.63303*width, y: 8.48175*height), control1: CGPoint(x: 6.64404*width, y: 8.44069*height), control2: CGPoint(x: 6.63303*width, y: 8.44617*height))
                path.addCurve(to: CGPoint(x: 6.62202*width, y: 8.57299*height), control1: CGPoint(x: 6.63303*width, y: 8.5*height), control2: CGPoint(x: 6.62844*width, y: 8.54106*height))
                path.addCurve(to: CGPoint(x: 6.58624*width, y: 8.6396*height), control1: CGPoint(x: 6.61284*width, y: 8.62318*height), control2: CGPoint(x: 6.60826*width, y: 8.63139*height))
                path.addCurve(to: CGPoint(x: 6.51376*width, y: 8.79927*height), control1: CGPoint(x: 6.55229*width, y: 8.65146*height), control2: CGPoint(x: 6.51376*width, y: 8.7354*height))
                path.addCurve(to: CGPoint(x: 6.54404*width, y: 8.83759*height), control1: CGPoint(x: 6.51376*width, y: 8.8385*height), control2: CGPoint(x: 6.51468*width, y: 8.83942*height))
                path.addLine(to: CGPoint(x: 6.57339*width, y: 8.83668*height))
                path.addLine(to: CGPoint(x: 6.57064*width, y: 8.92792*height))
                path.addCurve(to: CGPoint(x: 6.71101*width, y: 9.28467*height), control1: CGPoint(x: 6.56422*width, y: 9.09854*height), control2: CGPoint(x: 6.61101*width, y: 9.21807*height))
                path.addCurve(to: CGPoint(x: 6.8578*width, y: 9.33668*height), control1: CGPoint(x: 6.73486*width, y: 9.30109*height), control2: CGPoint(x: 6.80092*width, y: 9.32482*height))
                path.addCurve(to: CGPoint(x: 7.06422*width, y: 9.33029*height), control1: CGPoint(x: 6.89725*width, y: 9.3458*height), control2: CGPoint(x: 7.01651*width, y: 9.34215*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
