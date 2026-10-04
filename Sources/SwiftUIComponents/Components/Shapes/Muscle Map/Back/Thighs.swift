import SwiftUI

extension MuscleMap.Back {
    public struct Thighs: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Thighs().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.23119*width, y: 4.73266*height))
                path.addCurve(to: CGPoint(x: 6.09817*width, y: 4.4708*height), control1: CGPoint(x: 6.17798*width, y: 4.66423*height), control2: CGPoint(x: 6.1156*width, y: 4.54106*height))
                path.addCurve(to: CGPoint(x: 6.07339*width, y: 4.41788*height), control1: CGPoint(x: 6.09083*width, y: 4.44434*height), control2: CGPoint(x: 6.07982*width, y: 4.41971*height))
                path.addCurve(to: CGPoint(x: 6.06789*width, y: 4.55383*height), control1: CGPoint(x: 6.06422*width, y: 4.41423*height), control2: CGPoint(x: 6.0633*width, y: 4.44252*height))
                path.addCurve(to: CGPoint(x: 6.07431*width, y: 4.72628*height), control1: CGPoint(x: 6.07156*width, y: 4.63139*height), control2: CGPoint(x: 6.07431*width, y: 4.70894*height))
                path.addCurve(to: CGPoint(x: 6.10275*width, y: 4.98358*height), control1: CGPoint(x: 6.07431*width, y: 4.77737*height), control2: CGPoint(x: 6.09174*width, y: 4.93704*height))
                path.addLine(to: CGPoint(x: 6.11284*width, y: 5.02555*height))
                path.addLine(to: CGPoint(x: 6.1945*width, y: 4.90876*height))
                path.addLine(to: CGPoint(x: 6.27523*width, y: 4.79106*height))
                path.addLine(to: CGPoint(x: 6.23119*width, y: 4.73266*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.79174*width, y: 4.97993*height))
                path.addCurve(to: CGPoint(x: 7.81651*width, y: 4.40237*height), control1: CGPoint(x: 7.82477*width, y: 4.70712*height), control2: CGPoint(x: 7.8367*width, y: 4.41515*height))
                path.addCurve(to: CGPoint(x: 7.80734*width, y: 4.41515*height), control1: CGPoint(x: 7.81193*width, y: 4.39964*height), control2: CGPoint(x: 7.80734*width, y: 4.40511*height))
                path.addCurve(to: CGPoint(x: 7.66147*width, y: 4.74179*height), control1: CGPoint(x: 7.80734*width, y: 4.46715*height), control2: CGPoint(x: 7.71743*width, y: 4.6688*height))
                path.addCurve(to: CGPoint(x: 7.63761*width, y: 4.81478*height), control1: CGPoint(x: 7.62661*width, y: 4.78741*height), control2: CGPoint(x: 7.62477*width, y: 4.79106*height))
                path.addCurve(to: CGPoint(x: 7.77615*width, y: 5.01825*height), control1: CGPoint(x: 7.66789*width, y: 4.87318*height), control2: CGPoint(x: 7.76697*width, y: 5.01734*height))
                path.addCurve(to: CGPoint(x: 7.79174*width, y: 4.97993*height), control1: CGPoint(x: 7.78257*width, y: 5.01825*height), control2: CGPoint(x: 7.78899*width, y: 5.00091*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.91101*width, y: 4.66058*height))
                path.addCurve(to: CGPoint(x: 6.90183*width, y: 4.46168*height), control1: CGPoint(x: 6.90917*width, y: 4.55839*height), control2: CGPoint(x: 6.90459*width, y: 4.46898*height))
                path.addCurve(to: CGPoint(x: 6.87248*width, y: 4.51642*height), control1: CGPoint(x: 6.9*width, y: 4.45438*height), control2: CGPoint(x: 6.88624*width, y: 4.4781*height))
                path.addCurve(to: CGPoint(x: 6.76606*width, y: 4.73175*height), control1: CGPoint(x: 6.83394*width, y: 4.62044*height), control2: CGPoint(x: 6.80917*width, y: 4.67062*height))
                path.addCurve(to: CGPoint(x: 6.74404*width, y: 4.79745*height), control1: CGPoint(x: 6.73028*width, y: 4.78285*height), control2: CGPoint(x: 6.72844*width, y: 4.78832*height))
                path.addCurve(to: CGPoint(x: 6.80826*width, y: 4.81387*height), control1: CGPoint(x: 6.75229*width, y: 4.80292*height), control2: CGPoint(x: 6.78165*width, y: 4.81022*height))
                path.addCurve(to: CGPoint(x: 6.87982*width, y: 4.83212*height), control1: CGPoint(x: 6.83486*width, y: 4.81752*height), control2: CGPoint(x: 6.86697*width, y: 4.82573*height))
                path.addCurve(to: CGPoint(x: 6.91009*width, y: 4.84489*height), control1: CGPoint(x: 6.89266*width, y: 4.83942*height), control2: CGPoint(x: 6.90642*width, y: 4.84489*height))
                path.addCurve(to: CGPoint(x: 6.91101*width, y: 4.66058*height), control1: CGPoint(x: 6.91284*width, y: 4.84489*height), control2: CGPoint(x: 6.91376*width, y: 4.76186*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.02936*width, y: 4.83212*height))
                path.addCurve(to: CGPoint(x: 7.1211*width, y: 4.80474*height), control1: CGPoint(x: 7.05138*width, y: 4.82482*height), control2: CGPoint(x: 7.09266*width, y: 4.81296*height))
                path.addLine(to: CGPoint(x: 7.17339*width, y: 4.79015*height))
                path.addLine(to: CGPoint(x: 7.13394*width, y: 4.73266*height))
                path.addCurve(to: CGPoint(x: 7.02752*width, y: 4.51642*height), control1: CGPoint(x: 7.09083*width, y: 4.67153*height), control2: CGPoint(x: 7.06055*width, y: 4.6104*height))
                path.addCurve(to: CGPoint(x: 6.99174*width, y: 4.45803*height), control1: CGPoint(x: 7.00275*width, y: 4.44708*height), control2: CGPoint(x: 7.00183*width, y: 4.44708*height))
                path.addCurve(to: CGPoint(x: 6.98073*width, y: 4.84489*height), control1: CGPoint(x: 6.97982*width, y: 4.46989*height), control2: CGPoint(x: 6.96972*width, y: 4.84489*height))
                path.addCurve(to: CGPoint(x: 7.02936*width, y: 4.83212*height), control1: CGPoint(x: 6.98624*width, y: 4.84489*height), control2: CGPoint(x: 7.00826*width, y: 4.83942*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
