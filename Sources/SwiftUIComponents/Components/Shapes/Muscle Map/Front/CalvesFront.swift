import SwiftUI

extension MuscleMap.Front {
    public struct Calves: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.16514*width, y: 2.58394*height))
                path.addCurve(to: CGPoint(x: 3.17431*width, y: 2.52737*height), control1: CGPoint(x: 3.16514*width, y: 2.57026*height), control2: CGPoint(x: 3.16881*width, y: 2.54471*height))
                path.addCurve(to: CGPoint(x: 3.2211*width, y: 2.16423*height), control1: CGPoint(x: 3.18899*width, y: 2.47445*height), control2: CGPoint(x: 3.20917*width, y: 2.31204*height))
                path.addCurve(to: CGPoint(x: 3.22018*width, y: 1.89234*height), control1: CGPoint(x: 3.22936*width, y: 2.05474*height), control2: CGPoint(x: 3.22936*width, y: 1.99544*height))
                path.addCurve(to: CGPoint(x: 3.20459*width, y: 1.76369*height), control1: CGPoint(x: 3.21376*width, y: 1.81934*height), control2: CGPoint(x: 3.20734*width, y: 1.76186*height))
                path.addCurve(to: CGPoint(x: 3.17706*width, y: 1.83029*height), control1: CGPoint(x: 3.20275*width, y: 1.76642*height), control2: CGPoint(x: 3.18991*width, y: 1.79562*height))
                path.addCurve(to: CGPoint(x: 3.10917*width, y: 2.35675*height), control1: CGPoint(x: 3.11376*width, y: 1.99818*height), control2: CGPoint(x: 3.09083*width, y: 2.17245*height))
                path.addCurve(to: CGPoint(x: 3.13394*width, y: 2.5438*height), control1: CGPoint(x: 3.1156*width, y: 2.42336*height), control2: CGPoint(x: 3.12661*width, y: 2.5073*height))
                path.addCurve(to: CGPoint(x: 3.14679*width, y: 2.61496*height), control1: CGPoint(x: 3.14128*width, y: 2.5812*height), control2: CGPoint(x: 3.14679*width, y: 2.61314*height))
                path.addCurve(to: CGPoint(x: 3.15596*width, y: 2.61405*height), control1: CGPoint(x: 3.14679*width, y: 2.6177*height), control2: CGPoint(x: 3.15138*width, y: 2.61679*height))
                path.addCurve(to: CGPoint(x: 3.16514*width, y: 2.58394*height), control1: CGPoint(x: 3.16147*width, y: 2.61131*height), control2: CGPoint(x: 3.16514*width, y: 2.59763*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.89358*width, y: 2.57117*height))
                path.addCurve(to: CGPoint(x: 2.87431*width, y: 1.89325*height), control1: CGPoint(x: 2.9422*width, y: 2.25639*height), control2: CGPoint(x: 2.9367*width, y: 2.06569*height))
                path.addCurve(to: CGPoint(x: 2.84679*width, y: 1.80931*height), control1: CGPoint(x: 2.86147*width, y: 1.85858*height), control2: CGPoint(x: 2.84954*width, y: 1.82026*height))
                path.addCurve(to: CGPoint(x: 2.83028*width, y: 1.7792*height), control1: CGPoint(x: 2.84404*width, y: 1.79836*height), control2: CGPoint(x: 2.8367*width, y: 1.78467*height))
                path.addCurve(to: CGPoint(x: 2.81193*width, y: 1.89507*height), control1: CGPoint(x: 2.8211*width, y: 1.77099*height), control2: CGPoint(x: 2.81743*width, y: 1.79471*height))
                path.addCurve(to: CGPoint(x: 2.86789*width, y: 2.58942*height), control1: CGPoint(x: 2.8*width, y: 2.11496*height), control2: CGPoint(x: 2.82018*width, y: 2.36861*height))
                path.addCurve(to: CGPoint(x: 2.89358*width, y: 2.57117*height), control1: CGPoint(x: 2.87431*width, y: 2.62135*height), control2: CGPoint(x: 2.88716*width, y: 2.61314*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
