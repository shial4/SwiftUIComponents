import SwiftUI

extension MuscleMap.Front {
    public struct TibialisAnterior: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.55872*width, y: 2.85949*height))
                path.addCurve(to: CGPoint(x: 2.62018*width, y: 2.05201*height), control1: CGPoint(x: 2.62385*width, y: 2.82117*height), control2: CGPoint(x: 2.62569*width, y: 2.79653*height))
                path.addCurve(to: CGPoint(x: 2.60917*width, y: 1.38321*height), control1: CGPoint(x: 2.61835*width, y: 1.70347*height), control2: CGPoint(x: 2.61284*width, y: 1.40237*height))
                path.addCurve(to: CGPoint(x: 2.57798*width, y: 1.44708*height), control1: CGPoint(x: 2.60275*width, y: 1.34854*height), control2: CGPoint(x: 2.60183*width, y: 1.35036*height))
                path.addCurve(to: CGPoint(x: 2.52936*width, y: 1.63321*height), control1: CGPoint(x: 2.56422*width, y: 1.50182*height), control2: CGPoint(x: 2.5422*width, y: 1.58577*height))
                path.addCurve(to: CGPoint(x: 2.38624*width, y: 2.22263*height), control1: CGPoint(x: 2.48991*width, y: 1.77555*height), control2: CGPoint(x: 2.40183*width, y: 2.1396*height))
                path.addCurve(to: CGPoint(x: 2.38624*width, y: 2.65693*height), control1: CGPoint(x: 2.37339*width, y: 2.29197*height), control2: CGPoint(x: 2.37339*width, y: 2.59215*height))
                path.addCurve(to: CGPoint(x: 2.47523*width, y: 2.85858*height), control1: CGPoint(x: 2.41101*width, y: 2.77737*height), control2: CGPoint(x: 2.43578*width, y: 2.83394*height))
                path.addCurve(to: CGPoint(x: 2.55872*width, y: 2.85949*height), control1: CGPoint(x: 2.50642*width, y: 2.87774*height), control2: CGPoint(x: 2.52752*width, y: 2.87774*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.55046*width, y: 2.85949*height))
                path.addCurve(to: CGPoint(x: 3.6422*width, y: 2.65055*height), control1: CGPoint(x: 3.59358*width, y: 2.83394*height), control2: CGPoint(x: 3.62202*width, y: 2.76916*height))
                path.addCurve(to: CGPoint(x: 3.6422*width, y: 2.2281*height), control1: CGPoint(x: 3.65596*width, y: 2.56661*height), control2: CGPoint(x: 3.65596*width, y: 2.30474*height))
                path.addCurve(to: CGPoint(x: 3.54128*width, y: 1.79745*height), control1: CGPoint(x: 3.63211*width, y: 2.17427*height), control2: CGPoint(x: 3.56514*width, y: 1.88686*height))
                path.addCurve(to: CGPoint(x: 3.52752*width, y: 1.7427*height), control1: CGPoint(x: 3.5367*width, y: 1.78011*height), control2: CGPoint(x: 3.53028*width, y: 1.75547*height))
                path.addCurve(to: CGPoint(x: 3.49817*width, y: 1.63321*height), control1: CGPoint(x: 3.52477*width, y: 1.72993*height), control2: CGPoint(x: 3.51193*width, y: 1.68066*height))
                path.addCurve(to: CGPoint(x: 3.44954*width, y: 1.44617*height), control1: CGPoint(x: 3.48532*width, y: 1.58577*height), control2: CGPoint(x: 3.4633*width, y: 1.50182*height))
                path.addCurve(to: CGPoint(x: 3.41743*width, y: 1.37774*height), control1: CGPoint(x: 3.42661*width, y: 1.3531*height), control2: CGPoint(x: 3.42385*width, y: 1.34854*height))
                path.addCurve(to: CGPoint(x: 3.40642*width, y: 2.04653*height), control1: CGPoint(x: 3.41376*width, y: 1.39507*height), control2: CGPoint(x: 3.40917*width, y: 1.69617*height))
                path.addCurve(to: CGPoint(x: 3.46697*width, y: 2.85858*height), control1: CGPoint(x: 3.40183*width, y: 2.79288*height), control2: CGPoint(x: 3.40367*width, y: 2.82026*height))
                path.addCurve(to: CGPoint(x: 3.55046*width, y: 2.85949*height), control1: CGPoint(x: 3.49725*width, y: 2.87774*height), control2: CGPoint(x: 3.51835*width, y: 2.87774*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
