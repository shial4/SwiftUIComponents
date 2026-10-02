import SwiftUI

extension MuscleMap.Front {
    public struct Hips: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.41284*width, y: 5.54653*height))
                path.addLine(to: CGPoint(x: 2.48807*width, y: 5.44526*height))
                path.addLine(to: CGPoint(x: 2.46972*width, y: 5.37591*height))
                path.addCurve(to: CGPoint(x: 2.41284*width, y: 5.18248*height), control1: CGPoint(x: 2.43028*width, y: 5.22719*height), control2: CGPoint(x: 2.42202*width, y: 5.19891*height))
                path.addCurve(to: CGPoint(x: 2.40367*width, y: 5.14234*height), control1: CGPoint(x: 2.40734*width, y: 5.17336*height), control2: CGPoint(x: 2.40367*width, y: 5.15511*height))
                path.addCurve(to: CGPoint(x: 2.3945*width, y: 5.11405*height), control1: CGPoint(x: 2.40367*width, y: 5.12956*height), control2: CGPoint(x: 2.4*width, y: 5.1177*height))
                path.addCurve(to: CGPoint(x: 2.39083*width, y: 5.0958*height), control1: CGPoint(x: 2.38991*width, y: 5.11131*height), control2: CGPoint(x: 2.38807*width, y: 5.1031*height))
                path.addCurve(to: CGPoint(x: 2.32477*width, y: 4.92062*height), control1: CGPoint(x: 2.39908*width, y: 5.07482*height), control2: CGPoint(x: 2.34954*width, y: 4.94252*height))
                path.addCurve(to: CGPoint(x: 2.30275*width, y: 4.89142*height), control1: CGPoint(x: 2.31284*width, y: 4.90967*height), control2: CGPoint(x: 2.30275*width, y: 4.8969*height))
                path.addCurve(to: CGPoint(x: 2.2945*width, y: 4.87956*height), control1: CGPoint(x: 2.30275*width, y: 4.88686*height), control2: CGPoint(x: 2.29908*width, y: 4.88139*height))
                path.addCurve(to: CGPoint(x: 2.23303*width, y: 4.82755*height), control1: CGPoint(x: 2.28991*width, y: 4.87865*height), control2: CGPoint(x: 2.26239*width, y: 4.85493*height))
                path.addLine(to: CGPoint(x: 2.1789*width, y: 4.77737*height))
                path.addLine(to: CGPoint(x: 2.17615*width, y: 4.8458*height))
                path.addCurve(to: CGPoint(x: 2.20275*width, y: 5.15055*height), control1: CGPoint(x: 2.17248*width, y: 4.9115*height), control2: CGPoint(x: 2.1844*width, y: 5.04015*height))
                path.addCurve(to: CGPoint(x: 2.26606*width, y: 5.43796*height), control1: CGPoint(x: 2.2156*width, y: 5.22263*height), control2: CGPoint(x: 2.25596*width, y: 5.40876*height))
                path.addCurve(to: CGPoint(x: 2.29358*width, y: 5.5292*height), control1: CGPoint(x: 2.26972*width, y: 5.45073*height), control2: CGPoint(x: 2.28257*width, y: 5.49179*height))
                path.addCurve(to: CGPoint(x: 2.33486*width, y: 5.64781*height), control1: CGPoint(x: 2.31376*width, y: 5.60036*height), control2: CGPoint(x: 2.33028*width, y: 5.64781*height))
                path.addCurve(to: CGPoint(x: 2.41284*width, y: 5.54653*height), control1: CGPoint(x: 2.3367*width, y: 5.64781*height), control2: CGPoint(x: 2.37156*width, y: 5.60219*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.72936*width, y: 5.56022*height))
                path.addCurve(to: CGPoint(x: 3.81743*width, y: 5.19617*height), control1: CGPoint(x: 3.76972*width, y: 5.43157*height), control2: CGPoint(x: 3.80826*width, y: 5.27464*height))
                path.addCurve(to: CGPoint(x: 3.84312*width, y: 4.89325*height), control1: CGPoint(x: 3.83853*width, y: 5.03193*height), control2: CGPoint(x: 3.84312*width, y: 4.98175*height))
                path.addCurve(to: CGPoint(x: 3.83486*width, y: 4.79927*height), control1: CGPoint(x: 3.84404*width, y: 4.83577*height), control2: CGPoint(x: 3.84037*width, y: 4.79927*height))
                path.addCurve(to: CGPoint(x: 3.75596*width, y: 4.86679*height), control1: CGPoint(x: 3.82936*width, y: 4.79927*height), control2: CGPoint(x: 3.7945*width, y: 4.82938*height))
                path.addCurve(to: CGPoint(x: 3.66789*width, y: 5.00091*height), control1: CGPoint(x: 3.69083*width, y: 4.92883*height), control2: CGPoint(x: 3.68532*width, y: 4.93796*height))
                path.addCurve(to: CGPoint(x: 3.64495*width, y: 5.09854*height), control1: CGPoint(x: 3.6578*width, y: 5.03832*height), control2: CGPoint(x: 3.64679*width, y: 5.08212*height))
                path.addCurve(to: CGPoint(x: 3.63211*width, y: 5.12774*height), control1: CGPoint(x: 3.6422*width, y: 5.11405*height), control2: CGPoint(x: 3.6367*width, y: 5.12774*height))
                path.addCurve(to: CGPoint(x: 3.62385*width, y: 5.15328*height), control1: CGPoint(x: 3.62752*width, y: 5.12774*height), control2: CGPoint(x: 3.62385*width, y: 5.1396*height))
                path.addCurve(to: CGPoint(x: 3.6156*width, y: 5.18796*height), control1: CGPoint(x: 3.62385*width, y: 5.16697*height), control2: CGPoint(x: 3.62018*width, y: 5.18248*height))
                path.addCurve(to: CGPoint(x: 3.54679*width, y: 5.43796*height), control1: CGPoint(x: 3.60734*width, y: 5.19617*height), control2: CGPoint(x: 3.54771*width, y: 5.41332*height))
                path.addCurve(to: CGPoint(x: 3.69817*width, y: 5.64234*height), control1: CGPoint(x: 3.54679*width, y: 5.45438*height), control2: CGPoint(x: 3.68991*width, y: 5.64781*height))
                path.addCurve(to: CGPoint(x: 3.72936*width, y: 5.56022*height), control1: CGPoint(x: 3.70183*width, y: 5.64051*height), control2: CGPoint(x: 3.7156*width, y: 5.6031*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
