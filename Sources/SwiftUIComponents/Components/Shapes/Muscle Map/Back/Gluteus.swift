import SwiftUI

extension MuscleMap.Back {
    public struct Gluteus: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Gluteus().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 6.35688*width, y: 5.74635*height))
                path.addCurve(to: CGPoint(x: 6.49083*width, y: 5.625*height), control1: CGPoint(x: 6.42294*width, y: 5.70438*height), control2: CGPoint(x: 6.4367*width, y: 5.69252*height))
                path.addCurve(to: CGPoint(x: 6.53211*width, y: 5.57482*height), control1: CGPoint(x: 6.51009*width, y: 5.59945*height), control2: CGPoint(x: 6.52936*width, y: 5.57755*height))
                path.addCurve(to: CGPoint(x: 6.68165*width, y: 5.39507*height), control1: CGPoint(x: 6.53486*width, y: 5.57208*height), control2: CGPoint(x: 6.60275*width, y: 5.49088*height))
                path.addLine(to: CGPoint(x: 6.82661*width, y: 5.21898*height))
                path.addLine(to: CGPoint(x: 6.87431*width, y: 5.21898*height))
                path.addLine(to: CGPoint(x: 6.92202*width, y: 5.21898*height))
                path.addLine(to: CGPoint(x: 6.92202*width, y: 5.05748*height))
                path.addCurve(to: CGPoint(x: 6.90367*width, y: 4.89234*height), control1: CGPoint(x: 6.92202*width, y: 4.90237*height), control2: CGPoint(x: 6.9211*width, y: 4.89507*height))
                path.addCurve(to: CGPoint(x: 6.77523*width, y: 4.85493*height), control1: CGPoint(x: 6.88165*width, y: 4.88869*height), control2: CGPoint(x: 6.80092*width, y: 4.86496*height))
                path.addCurve(to: CGPoint(x: 6.73394*width, y: 4.83759*height), control1: CGPoint(x: 6.76514*width, y: 4.85036*height), control2: CGPoint(x: 6.74679*width, y: 4.84307*height))
                path.addCurve(to: CGPoint(x: 6.48165*width, y: 4.81113*height), control1: CGPoint(x: 6.69174*width, y: 4.82026*height), control2: CGPoint(x: 6.64862*width, y: 4.81569*height))
                path.addLine(to: CGPoint(x: 6.31651*width, y: 4.80748*height))
                path.addLine(to: CGPoint(x: 6.29358*width, y: 4.84215*height))
                path.addCurve(to: CGPoint(x: 6.25872*width, y: 4.89964*height), control1: CGPoint(x: 6.28165*width, y: 4.86131*height), control2: CGPoint(x: 6.26606*width, y: 4.88686*height))
                path.addCurve(to: CGPoint(x: 6.22936*width, y: 4.93796*height), control1: CGPoint(x: 6.25229*width, y: 4.91241*height), control2: CGPoint(x: 6.23945*width, y: 4.92883*height))
                path.addCurve(to: CGPoint(x: 6.21101*width, y: 4.95894*height), control1: CGPoint(x: 6.21927*width, y: 4.94617*height), control2: CGPoint(x: 6.21101*width, y: 4.95529*height))
                path.addCurve(to: CGPoint(x: 6.16881*width, y: 5.02555*height), control1: CGPoint(x: 6.21101*width, y: 4.96259*height), control2: CGPoint(x: 6.19174*width, y: 4.9927*height))
                path.addCurve(to: CGPoint(x: 6.13303*width, y: 5.10858*height), control1: CGPoint(x: 6.13578*width, y: 5.07299*height), control2: CGPoint(x: 6.12844*width, y: 5.09033*height))
                path.addCurve(to: CGPoint(x: 6.14679*width, y: 5.17792*height), control1: CGPoint(x: 6.13578*width, y: 5.12135*height), control2: CGPoint(x: 6.1422*width, y: 5.15328*height))
                path.addCurve(to: CGPoint(x: 6.21927*width, y: 5.47445*height), control1: CGPoint(x: 6.15321*width, y: 5.21898*height), control2: CGPoint(x: 6.19633*width, y: 5.39325*height))
                path.addCurve(to: CGPoint(x: 6.28073*width, y: 5.74179*height), control1: CGPoint(x: 6.23761*width, y: 5.53741*height), control2: CGPoint(x: 6.27431*width, y: 5.69891*height))
                path.addCurve(to: CGPoint(x: 6.29174*width, y: 5.78467*height), control1: CGPoint(x: 6.28349*width, y: 5.76551*height), control2: CGPoint(x: 6.28899*width, y: 5.78467*height))
                path.addCurve(to: CGPoint(x: 6.35688*width, y: 5.74635*height), control1: CGPoint(x: 6.2945*width, y: 5.78467*height), control2: CGPoint(x: 6.32385*width, y: 5.76734*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 7.60917*width, y: 5.74179*height))
                path.addCurve(to: CGPoint(x: 7.67523*width, y: 5.45985*height), control1: CGPoint(x: 7.61284*width, y: 5.71715*height), control2: CGPoint(x: 7.6422*width, y: 5.59124*height))
                path.addCurve(to: CGPoint(x: 7.73394*width, y: 5.19891*height), control1: CGPoint(x: 7.70734*width, y: 5.32938*height), control2: CGPoint(x: 7.73394*width, y: 5.21168*height))
                path.addCurve(to: CGPoint(x: 7.7422*width, y: 5.17153*height), control1: CGPoint(x: 7.73394*width, y: 5.18522*height), control2: CGPoint(x: 7.73761*width, y: 5.17336*height))
                path.addCurve(to: CGPoint(x: 7.75596*width, y: 5.12774*height), control1: CGPoint(x: 7.74587*width, y: 5.17062*height), control2: CGPoint(x: 7.75229*width, y: 5.15055*height))
                path.addCurve(to: CGPoint(x: 7.70092*width, y: 4.99544*height), control1: CGPoint(x: 7.76147*width, y: 5.0885*height), control2: CGPoint(x: 7.75963*width, y: 5.08303*height))
                path.addCurve(to: CGPoint(x: 7.60367*width, y: 4.85584*height), control1: CGPoint(x: 7.66789*width, y: 4.94526*height), control2: CGPoint(x: 7.62385*width, y: 4.8823*height))
                path.addLine(to: CGPoint(x: 7.56606*width, y: 4.80748*height))
                path.addLine(to: CGPoint(x: 7.4*width, y: 4.81113*height))
                path.addCurve(to: CGPoint(x: 7.20183*width, y: 4.82391*height), control1: CGPoint(x: 7.30826*width, y: 4.81296*height), control2: CGPoint(x: 7.21927*width, y: 4.81843*height))
                path.addCurve(to: CGPoint(x: 7.07156*width, y: 4.86405*height), control1: CGPoint(x: 7.1844*width, y: 4.82938*height), control2: CGPoint(x: 7.12569*width, y: 4.84763*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 4.89416*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 5.05657*height))
                path.addLine(to: CGPoint(x: 6.97248*width, y: 5.21898*height))
                path.addLine(to: CGPoint(x: 7.01743*width, y: 5.21898*height))
                path.addCurve(to: CGPoint(x: 7.10183*width, y: 5.26734*height), control1: CGPoint(x: 7.06055*width, y: 5.21898*height), control2: CGPoint(x: 7.06422*width, y: 5.2208*height))
                path.addCurve(to: CGPoint(x: 7.14771*width, y: 5.31934*height), control1: CGPoint(x: 7.12385*width, y: 5.29288*height), control2: CGPoint(x: 7.14404*width, y: 5.31661*height))
                path.addCurve(to: CGPoint(x: 7.28349*width, y: 5.48358*height), control1: CGPoint(x: 7.15046*width, y: 5.32208*height), control2: CGPoint(x: 7.21193*width, y: 5.39599*height))
                path.addCurve(to: CGPoint(x: 7.44128*width, y: 5.67245*height), control1: CGPoint(x: 7.35596*width, y: 5.57117*height), control2: CGPoint(x: 7.42661*width, y: 5.65693*height))
                path.addCurve(to: CGPoint(x: 7.59725*width, y: 5.78467*height), control1: CGPoint(x: 7.46422*width, y: 5.69891*height), control2: CGPoint(x: 7.58257*width, y: 5.78285*height))
                path.addCurve(to: CGPoint(x: 7.60917*width, y: 5.74179*height), control1: CGPoint(x: 7.60092*width, y: 5.78467*height), control2: CGPoint(x: 7.60642*width, y: 5.76551*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
