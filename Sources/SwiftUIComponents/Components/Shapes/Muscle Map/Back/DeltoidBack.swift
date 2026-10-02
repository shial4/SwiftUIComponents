import SwiftUI

extension MuscleMap.Back {
    public struct Deltoid: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.27615*width, y: 7.6688*height))
                path.addCurve(to: CGPoint(x: 6.42202*width, y: 7.56934*height), control1: CGPoint(x: 6.35596*width, y: 7.61588*height), control2: CGPoint(x: 6.42202*width, y: 7.57117*height))
                path.addCurve(to: CGPoint(x: 6.22661*width, y: 7.39964*height), control1: CGPoint(x: 6.42202*width, y: 7.56661*height), control2: CGPoint(x: 6.30367*width, y: 7.4635*height))
                path.addCurve(to: CGPoint(x: 6.18165*width, y: 7.36131*height), control1: CGPoint(x: 6.21743*width, y: 7.39234*height), control2: CGPoint(x: 6.19725*width, y: 7.375*height))
                path.addCurve(to: CGPoint(x: 6.1422*width, y: 7.33577*height), control1: CGPoint(x: 6.16514*width, y: 7.34672*height), control2: CGPoint(x: 6.14771*width, y: 7.33577*height))
                path.addCurve(to: CGPoint(x: 5.95872*width, y: 7.25182*height), control1: CGPoint(x: 6.11835*width, y: 7.33577*height), control2: CGPoint(x: 6.01009*width, y: 7.2865*height))
                path.addCurve(to: CGPoint(x: 5.85596*width, y: 7.1688*height), control1: CGPoint(x: 5.92844*width, y: 7.23175*height), control2: CGPoint(x: 5.88165*width, y: 7.19434*height))
                path.addCurve(to: CGPoint(x: 5.8*width, y: 7.13047*height), control1: CGPoint(x: 5.82661*width, y: 7.14051*height), control2: CGPoint(x: 5.80459*width, y: 7.12591*height))
                path.addCurve(to: CGPoint(x: 5.76789*width, y: 7.2062*height), control1: CGPoint(x: 5.79541*width, y: 7.13595*height), control2: CGPoint(x: 5.78073*width, y: 7.16971*height))
                path.addCurve(to: CGPoint(x: 5.78991*width, y: 7.56478*height), control1: CGPoint(x: 5.72844*width, y: 7.31296*height), control2: CGPoint(x: 5.73761*width, y: 7.46442*height))
                path.addCurve(to: CGPoint(x: 6.0945*width, y: 7.76369*height), control1: CGPoint(x: 5.84312*width, y: 7.66971*height), control2: CGPoint(x: 5.98349*width, y: 7.76095*height))
                path.addCurve(to: CGPoint(x: 6.27615*width, y: 7.6688*height), control1: CGPoint(x: 6.12477*width, y: 7.7646*height), control2: CGPoint(x: 6.15138*width, y: 7.75*height))
                path.closeSubpath()
            })
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.8633*width, y: 7.75182*height))
                path.addCurve(to: CGPoint(x: 8.03303*width, y: 7.65328*height), control1: CGPoint(x: 7.93211*width, y: 7.73084*height), control2: CGPoint(x: 7.99266*width, y: 7.69617*height))
                path.addCurve(to: CGPoint(x: 8.1422*width, y: 7.35401*height), control1: CGPoint(x: 8.12018*width, y: 7.56204*height), control2: CGPoint(x: 8.1422*width, y: 7.50182*height))
                path.addCurve(to: CGPoint(x: 8.09817*width, y: 7.14234*height), control1: CGPoint(x: 8.1422*width, y: 7.24909*height), control2: CGPoint(x: 8.14037*width, y: 7.23814*height))
                path.addLine(to: CGPoint(x: 8.08807*width, y: 7.1177*height))
                path.addLine(to: CGPoint(x: 8.03211*width, y: 7.16971*height))
                path.addCurve(to: CGPoint(x: 7.95688*width, y: 7.23631*height), control1: CGPoint(x: 8.00092*width, y: 7.19799*height), control2: CGPoint(x: 7.96789*width, y: 7.2281*height))
                path.addCurve(to: CGPoint(x: 7.77615*width, y: 7.32755*height), control1: CGPoint(x: 7.9211*width, y: 7.2646*height), control2: CGPoint(x: 7.8211*width, y: 7.31569*height))
                path.addCurve(to: CGPoint(x: 7.57982*width, y: 7.4708*height), control1: CGPoint(x: 7.73303*width, y: 7.34033*height), control2: CGPoint(x: 7.70917*width, y: 7.35766*height))
                path.addCurve(to: CGPoint(x: 7.5*width, y: 7.53832*height), control1: CGPoint(x: 7.54771*width, y: 7.49818*height), control2: CGPoint(x: 7.51193*width, y: 7.52828*height))
                path.addCurve(to: CGPoint(x: 7.47706*width, y: 7.56661*height), control1: CGPoint(x: 7.48716*width, y: 7.54836*height), control2: CGPoint(x: 7.47706*width, y: 7.56113*height))
                path.addCurve(to: CGPoint(x: 7.61743*width, y: 7.67062*height), control1: CGPoint(x: 7.47706*width, y: 7.57299*height), control2: CGPoint(x: 7.54037*width, y: 7.61953*height))
                path.addCurve(to: CGPoint(x: 7.8633*width, y: 7.75182*height), control1: CGPoint(x: 7.76881*width, y: 7.7719*height), control2: CGPoint(x: 7.78165*width, y: 7.77646*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
