import SwiftUI

extension MuscleMap.Back {
    public struct LowerBack: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(LowerBack().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.06422*width, y: 6.34945*height))
                path.addCurve(to: CGPoint(x: 7.17706*width, y: 6.2062*height), control1: CGPoint(x: 7.06881*width, y: 6.34215*height), control2: CGPoint(x: 7.11927*width, y: 6.27828*height))
                path.addLine(to: CGPoint(x: 7.28257*width, y: 6.07573*height))
                path.addLine(to: CGPoint(x: 7.29358*width, y: 5.96898*height))
                path.addCurve(to: CGPoint(x: 7.31193*width, y: 5.84398*height), control1: CGPoint(x: 7.29908*width, y: 5.91058*height), control2: CGPoint(x: 7.30734*width, y: 5.85401*height))
                path.addCurve(to: CGPoint(x: 7.36697*width, y: 5.77281*height), control1: CGPoint(x: 7.3156*width, y: 5.83394*height), control2: CGPoint(x: 7.34037*width, y: 5.80201*height))
                path.addCurve(to: CGPoint(x: 7.36972*width, y: 5.6615*height), control1: CGPoint(x: 7.41927*width, y: 5.71533*height), control2: CGPoint(x: 7.41927*width, y: 5.7135*height))
                path.addCurve(to: CGPoint(x: 7.19725*width, y: 5.46533*height), control1: CGPoint(x: 7.36055*width, y: 5.65146*height), control2: CGPoint(x: 7.28257*width, y: 5.56296*height))
                path.addCurve(to: CGPoint(x: 7.03211*width, y: 5.28102*height), control1: CGPoint(x: 7.11193*width, y: 5.3677*height), control2: CGPoint(x: 7.03761*width, y: 5.28467*height))
                path.addCurve(to: CGPoint(x: 6.94404*width, y: 5.27372*height), control1: CGPoint(x: 7.02752*width, y: 5.27737*height), control2: CGPoint(x: 6.98716*width, y: 5.27372*height))
                path.addLine(to: CGPoint(x: 6.86514*width, y: 5.27372*height))
                path.addLine(to: CGPoint(x: 6.82477*width, y: 5.31752*height))
                path.addCurve(to: CGPoint(x: 6.72936*width, y: 5.42427*height), control1: CGPoint(x: 6.80275*width, y: 5.34124*height), control2: CGPoint(x: 6.75963*width, y: 5.3896*height))
                path.addCurve(to: CGPoint(x: 6.6367*width, y: 5.5292*height), control1: CGPoint(x: 6.69908*width, y: 5.45894*height), control2: CGPoint(x: 6.6578*width, y: 5.50639*height))
                path.addCurve(to: CGPoint(x: 6.48349*width, y: 5.72445*height), control1: CGPoint(x: 6.51743*width, y: 5.6615*height), control2: CGPoint(x: 6.47706*width, y: 5.71259*height))
                path.addCurve(to: CGPoint(x: 6.51835*width, y: 5.76825*height), control1: CGPoint(x: 6.48716*width, y: 5.73175*height), control2: CGPoint(x: 6.50367*width, y: 5.75091*height))
                path.addCurve(to: CGPoint(x: 6.59174*width, y: 5.91971*height), control1: CGPoint(x: 6.58073*width, y: 5.83668*height), control2: CGPoint(x: 6.58532*width, y: 5.84672*height))
                path.addCurve(to: CGPoint(x: 6.62202*width, y: 6.09398*height), control1: CGPoint(x: 6.60183*width, y: 6.04562*height), control2: CGPoint(x: 6.60642*width, y: 6.07573*height))
                path.addCurve(to: CGPoint(x: 6.65138*width, y: 6.12865*height), control1: CGPoint(x: 6.63119*width, y: 6.1031*height), control2: CGPoint(x: 6.64404*width, y: 6.11953*height))
                path.addCurve(to: CGPoint(x: 6.75321*width, y: 6.25456*height), control1: CGPoint(x: 6.65872*width, y: 6.13777*height), control2: CGPoint(x: 6.70459*width, y: 6.19434*height))
                path.addLine(to: CGPoint(x: 6.8422*width, y: 6.36405*height))
                path.addLine(to: CGPoint(x: 6.94954*width, y: 6.36314*height))
                path.addCurve(to: CGPoint(x: 7.06422*width, y: 6.34945*height), control1: CGPoint(x: 7.03303*width, y: 6.36314*height), control2: CGPoint(x: 7.05872*width, y: 6.3604*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
