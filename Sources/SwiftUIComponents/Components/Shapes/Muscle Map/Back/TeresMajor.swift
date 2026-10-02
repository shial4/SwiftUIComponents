import SwiftUI

extension MuscleMap.Back {
    public struct TeresMajor: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.68899*width, y: 7.16423*height))
                path.addCurve(to: CGPoint(x: 7.67798*width, y: 7.01095*height), control1: CGPoint(x: 7.68807*width, y: 7.08577*height), control2: CGPoint(x: 7.68257*width, y: 7.01642*height))
                path.addCurve(to: CGPoint(x: 7.5844*width, y: 6.99544*height), control1: CGPoint(x: 7.67339*width, y: 7.00547*height), control2: CGPoint(x: 7.63119*width, y: 6.99818*height))
                path.addCurve(to: CGPoint(x: 7.47615*width, y: 6.97993*height), control1: CGPoint(x: 7.53853*width, y: 6.9927*height), control2: CGPoint(x: 7.48899*width, y: 6.9854*height))
                path.addCurve(to: CGPoint(x: 7.43211*width, y: 6.97901*height), control1: CGPoint(x: 7.4578*width, y: 6.97172*height), control2: CGPoint(x: 7.44679*width, y: 6.97172*height))
                path.addCurve(to: CGPoint(x: 7.49266*width, y: 7.08759*height), control1: CGPoint(x: 7.41284*width, y: 6.98996*height), control2: CGPoint(x: 7.4156*width, y: 6.99361*height))
                path.addCurve(to: CGPoint(x: 7.68624*width, y: 7.31296*height), control1: CGPoint(x: 7.66514*width, y: 7.29745*height), control2: CGPoint(x: 7.68165*width, y: 7.31752*height))
                path.addCurve(to: CGPoint(x: 7.68899*width, y: 7.16423*height), control1: CGPoint(x: 7.68899*width, y: 7.31022*height), control2: CGPoint(x: 7.68991*width, y: 7.24361*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.32936*width, y: 7.14872*height))
                path.addCurve(to: CGPoint(x: 6.44862*width, y: 7.00456*height), control1: CGPoint(x: 6.38716*width, y: 7.07847*height), control2: CGPoint(x: 6.44037*width, y: 7.01369*height))
                path.addCurve(to: CGPoint(x: 6.44954*width, y: 6.97901*height), control1: CGPoint(x: 6.46055*width, y: 6.98996*height), control2: CGPoint(x: 6.46055*width, y: 6.98723*height))
                path.addCurve(to: CGPoint(x: 6.41743*width, y: 6.97628*height), control1: CGPoint(x: 6.4422*width, y: 6.97445*height), control2: CGPoint(x: 6.42752*width, y: 6.97263*height))
                path.addCurve(to: CGPoint(x: 6.33945*width, y: 6.98996*height), control1: CGPoint(x: 6.40734*width, y: 6.97901*height), control2: CGPoint(x: 6.37248*width, y: 6.9854*height))
                path.addCurve(to: CGPoint(x: 6.23028*width, y: 7.02646*height), control1: CGPoint(x: 6.25413*width, y: 7.00091*height), control2: CGPoint(x: 6.24495*width, y: 7.00456*height))
                path.addCurve(to: CGPoint(x: 6.19266*width, y: 7.29836*height), control1: CGPoint(x: 6.2211*width, y: 7.04288*height), control2: CGPoint(x: 6.19358*width, y: 7.23996*height))
                path.addCurve(to: CGPoint(x: 6.32936*width, y: 7.14872*height), control1: CGPoint(x: 6.19266*width, y: 7.31569*height), control2: CGPoint(x: 6.19817*width, y: 7.31022*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
