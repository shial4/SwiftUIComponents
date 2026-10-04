import SwiftUI

extension MuscleMap.Front {
    public struct Neck: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Neck().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.88624*width, y: 8.20164*height))
                path.addCurve(to: CGPoint(x: 3.0367*width, y: 8.18522*height), control1: CGPoint(x: 2.9211*width, y: 8.18796*height), control2: CGPoint(x: 2.95413*width, y: 8.18431*height))
                path.addCurve(to: CGPoint(x: 3.15688*width, y: 8.19161*height), control1: CGPoint(x: 3.0945*width, y: 8.18522*height), control2: CGPoint(x: 3.14862*width, y: 8.18796*height))
                path.addCurve(to: CGPoint(x: 3.21101*width, y: 8.24361*height), control1: CGPoint(x: 3.16514*width, y: 8.19526*height), control2: CGPoint(x: 3.18899*width, y: 8.21898*height))
                path.addCurve(to: CGPoint(x: 3.25963*width, y: 8.29288*height), control1: CGPoint(x: 3.23303*width, y: 8.26916*height), control2: CGPoint(x: 3.25413*width, y: 8.29106*height))
                path.addCurve(to: CGPoint(x: 3.26239*width, y: 8.23358*height), control1: CGPoint(x: 3.26606*width, y: 8.29471*height), control2: CGPoint(x: 3.26697*width, y: 8.27464*height))
                path.addCurve(to: CGPoint(x: 3.24771*width, y: 7.99544*height), control1: CGPoint(x: 3.25872*width, y: 8.19891*height), control2: CGPoint(x: 3.25229*width, y: 8.09215*height))
                path.addCurve(to: CGPoint(x: 3.23394*width, y: 7.81113*height), control1: CGPoint(x: 3.24404*width, y: 7.89964*height), control2: CGPoint(x: 3.23761*width, y: 7.81569*height))
                path.addCurve(to: CGPoint(x: 3.19541*width, y: 7.80109*height), control1: CGPoint(x: 3.23119*width, y: 7.80566*height), control2: CGPoint(x: 3.21376*width, y: 7.80109*height))
                path.addCurve(to: CGPoint(x: 3.13394*width, y: 7.78376*height), control1: CGPoint(x: 3.17706*width, y: 7.80109*height), control2: CGPoint(x: 3.14954*width, y: 7.79288*height))
                path.addCurve(to: CGPoint(x: 3.07064*width, y: 7.76004*height), control1: CGPoint(x: 3.11835*width, y: 7.77372*height), control2: CGPoint(x: 3.08991*width, y: 7.76277*height))
                path.addCurve(to: CGPoint(x: 3.03028*width, y: 7.74088*height), control1: CGPoint(x: 3.05138*width, y: 7.75639*height), control2: CGPoint(x: 3.03303*width, y: 7.74726*height))
                path.addCurve(to: CGPoint(x: 3.0*width, y: 7.74179*height), control1: CGPoint(x: 3.02385*width, y: 7.72354*height), control2: CGPoint(x: 3.0*width, y: 7.72445*height))
                path.addCurve(to: CGPoint(x: 2.96147*width, y: 7.76551*height), control1: CGPoint(x: 3.0*width, y: 7.74909*height), control2: CGPoint(x: 2.9844*width, y: 7.75912*height))
                path.addCurve(to: CGPoint(x: 2.89174*width, y: 7.78832*height), control1: CGPoint(x: 2.93945*width, y: 7.77099*height), control2: CGPoint(x: 2.90826*width, y: 7.78102*height))
                path.addCurve(to: CGPoint(x: 2.83119*width, y: 7.80109*height), control1: CGPoint(x: 2.87523*width, y: 7.79562*height), control2: CGPoint(x: 2.84771*width, y: 7.80109*height))
                path.addCurve(to: CGPoint(x: 2.7945*width, y: 7.82482*height), control1: CGPoint(x: 2.8055*width, y: 7.80109*height), control2: CGPoint(x: 2.79908*width, y: 7.80474*height))
                path.addCurve(to: CGPoint(x: 2.77156*width, y: 8.28011*height), control1: CGPoint(x: 2.78991*width, y: 7.84307*height), control2: CGPoint(x: 2.77064*width, y: 8.21168*height))
                path.addCurve(to: CGPoint(x: 2.8055*width, y: 8.25821*height), control1: CGPoint(x: 2.77156*width, y: 8.29471*height), control2: CGPoint(x: 2.77798*width, y: 8.29015*height))
                path.addCurve(to: CGPoint(x: 2.88624*width, y: 8.20164*height), control1: CGPoint(x: 2.82844*width, y: 8.23266*height), control2: CGPoint(x: 2.85688*width, y: 8.21259*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
