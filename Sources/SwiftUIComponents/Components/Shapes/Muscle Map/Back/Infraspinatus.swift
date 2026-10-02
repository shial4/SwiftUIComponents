import SwiftUI

extension MuscleMap.Back {
    public struct Infraspinatus: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.46239*width, y: 7.30839*height))
                path.addCurve(to: CGPoint(x: 6.47339*width, y: 7.11679*height), control1: CGPoint(x: 6.46514*width, y: 7.23084*height), control2: CGPoint(x: 6.47064*width, y: 7.14416*height))
                path.addLine(to: CGPoint(x: 6.4789*width, y: 7.06661*height))
                path.addLine(to: CGPoint(x: 6.44312*width, y: 7.1031*height))
                path.addCurve(to: CGPoint(x: 6.35688*width, y: 7.19891*height), control1: CGPoint(x: 6.42385*width, y: 7.12318*height), control2: CGPoint(x: 6.38532*width, y: 7.16606*height))
                path.addCurve(to: CGPoint(x: 6.26697*width, y: 7.30018*height), control1: CGPoint(x: 6.32844*width, y: 7.23175*height), control2: CGPoint(x: 6.28807*width, y: 7.27737*height))
                path.addLine(to: CGPoint(x: 6.22936*width, y: 7.34307*height))
                path.addLine(to: CGPoint(x: 6.33211*width, y: 7.43066*height))
                path.addLine(to: CGPoint(x: 6.43486*width, y: 7.51825*height))
                path.addLine(to: CGPoint(x: 6.44587*width, y: 7.48449*height))
                path.addCurve(to: CGPoint(x: 6.46239*width, y: 7.30839*height), control1: CGPoint(x: 6.45138*width, y: 7.46533*height), control2: CGPoint(x: 6.45963*width, y: 7.38595*height))
                path.closeSubpath()
            })
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.46972*width, y: 7.51095*height))
                path.addCurve(to: CGPoint(x: 7.55688*width, y: 7.42883*height), control1: CGPoint(x: 7.47156*width, y: 7.5073*height), control2: CGPoint(x: 7.51101*width, y: 7.4708*height))
                path.addCurve(to: CGPoint(x: 7.64404*width, y: 7.35036*height), control1: CGPoint(x: 7.60367*width, y: 7.38777*height), control2: CGPoint(x: 7.64312*width, y: 7.35219*height))
                path.addCurve(to: CGPoint(x: 7.62385*width, y: 7.32026*height), control1: CGPoint(x: 7.64587*width, y: 7.34854*height), control2: CGPoint(x: 7.6367*width, y: 7.33485*height))
                path.addCurve(to: CGPoint(x: 7.51376*width, y: 7.19526*height), control1: CGPoint(x: 7.61101*width, y: 7.30657*height), control2: CGPoint(x: 7.56147*width, y: 7.25*height))
                path.addLine(to: CGPoint(x: 7.42661*width, y: 7.0958*height))
                path.addLine(to: CGPoint(x: 7.42385*width, y: 7.14964*height))
                path.addCurve(to: CGPoint(x: 7.43028*width, y: 7.29288*height), control1: CGPoint(x: 7.42202*width, y: 7.17883*height), control2: CGPoint(x: 7.42569*width, y: 7.24361*height))
                path.addCurve(to: CGPoint(x: 7.44037*width, y: 7.44434*height), control1: CGPoint(x: 7.43578*width, y: 7.34215*height), control2: CGPoint(x: 7.44037*width, y: 7.40967*height))
                path.addCurve(to: CGPoint(x: 7.44679*width, y: 7.51186*height), control1: CGPoint(x: 7.44037*width, y: 7.4781*height), control2: CGPoint(x: 7.44312*width, y: 7.50912*height))
                path.addCurve(to: CGPoint(x: 7.46972*width, y: 7.51095*height), control1: CGPoint(x: 7.45505*width, y: 7.52007*height), control2: CGPoint(x: 7.46606*width, y: 7.52007*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
