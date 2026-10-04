import SwiftUI

extension MuscleMap.Front {
    public struct Quadriceps: MuscleMapShape, CachedMuscleMapShape {
        nonisolated static let geometry = MuscleMapGeometry(Quadriceps().paths(width: 1, height: 1))

        public var translationX: Double
        
        nonisolated public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.55505*width, y: 5.31113*height))
                path.addCurve(to: CGPoint(x: 2.63945*width, y: 5.22536*height), control1: CGPoint(x: 2.57798*width, y: 5.30292*height), control2: CGPoint(x: 2.6*width, y: 5.28011*height))
                path.addCurve(to: CGPoint(x: 2.7055*width, y: 5.12774*height), control1: CGPoint(x: 2.66881*width, y: 5.18431*height), control2: CGPoint(x: 2.69817*width, y: 5.14051*height))
                path.addCurve(to: CGPoint(x: 2.80734*width, y: 4.99818*height), control1: CGPoint(x: 2.71651*width, y: 5.10858*height), control2: CGPoint(x: 2.74128*width, y: 5.07573*height))
                path.addCurve(to: CGPoint(x: 2.82752*width, y: 4.98175*height), control1: CGPoint(x: 2.81468*width, y: 4.98905*height), control2: CGPoint(x: 2.82385*width, y: 4.98175*height))
                path.addCurve(to: CGPoint(x: 2.86789*width, y: 4.94526*height), control1: CGPoint(x: 2.83211*width, y: 4.98175*height), control2: CGPoint(x: 2.84954*width, y: 4.96533*height))
                path.addCurve(to: CGPoint(x: 2.94587*width, y: 4.87956*height), control1: CGPoint(x: 2.88624*width, y: 4.92518*height), control2: CGPoint(x: 2.9211*width, y: 4.89599*height))
                path.addCurve(to: CGPoint(x: 2.98165*width, y: 4.53467*height), control1: CGPoint(x: 2.99908*width, y: 4.8458*height), control2: CGPoint(x: 2.99541*width, y: 4.87774*height))
                path.addCurve(to: CGPoint(x: 2.91284*width, y: 3.25547*height), control1: CGPoint(x: 2.9422*width, y: 3.55292*height), control2: CGPoint(x: 2.92752*width, y: 3.29197*height))
                path.addCurve(to: CGPoint(x: 2.88165*width, y: 3.23905*height), control1: CGPoint(x: 2.90917*width, y: 3.24544*height), control2: CGPoint(x: 2.89633*width, y: 3.23905*height))
                path.addCurve(to: CGPoint(x: 2.80734*width, y: 3.28376*height), control1: CGPoint(x: 2.83303*width, y: 3.23905*height), control2: CGPoint(x: 2.81651*width, y: 3.24909*height))
                path.addCurve(to: CGPoint(x: 2.74037*width, y: 3.35766*height), control1: CGPoint(x: 2.79358*width, y: 3.33577*height), control2: CGPoint(x: 2.77339*width, y: 3.35766*height))
                path.addCurve(to: CGPoint(x: 2.64679*width, y: 3.29015*height), control1: CGPoint(x: 2.7156*width, y: 3.35766*height), control2: CGPoint(x: 2.7*width, y: 3.34672*height))
                path.addCurve(to: CGPoint(x: 2.54128*width, y: 3.20712*height), control1: CGPoint(x: 2.60367*width, y: 3.24544*height), control2: CGPoint(x: 2.56881*width, y: 3.21807*height))
                path.addCurve(to: CGPoint(x: 2.48899*width, y: 3.18704*height), control1: CGPoint(x: 2.51835*width, y: 3.19891*height), control2: CGPoint(x: 2.4945*width, y: 3.18978*height))
                path.addCurve(to: CGPoint(x: 2.47706*width, y: 3.21442*height), control1: CGPoint(x: 2.48073*width, y: 3.18339*height), control2: CGPoint(x: 2.47706*width, y: 3.19252*height))
                path.addCurve(to: CGPoint(x: 2.33486*width, y: 3.57208*height), control1: CGPoint(x: 2.47706*width, y: 3.27737*height), control2: CGPoint(x: 2.41284*width, y: 3.43978*height))
                path.addCurve(to: CGPoint(x: 2.16239*width, y: 3.96442*height), control1: CGPoint(x: 2.26514*width, y: 3.69069*height), control2: CGPoint(x: 2.22569*width, y: 3.78102*height))
                path.addLine(to: CGPoint(x: 2.12385*width, y: 4.07391*height))
                path.addLine(to: CGPoint(x: 2.12569*width, y: 4.21533*height))
                path.addCurve(to: CGPoint(x: 2.16697*width, y: 4.65785*height), control1: CGPoint(x: 2.12752*width, y: 4.34945*height), control2: CGPoint(x: 2.14495*width, y: 4.5365*height))
                path.addCurve(to: CGPoint(x: 2.25596*width, y: 4.79106*height), control1: CGPoint(x: 2.17615*width, y: 4.70985*height), control2: CGPoint(x: 2.17982*width, y: 4.71624*height))
                path.addCurve(to: CGPoint(x: 2.43119*width, y: 5.04288*height), control1: CGPoint(x: 2.38349*width, y: 4.91788*height), control2: CGPoint(x: 2.43119*width, y: 4.98631*height))
                path.addCurve(to: CGPoint(x: 2.44954*width, y: 5.11588*height), control1: CGPoint(x: 2.43119*width, y: 5.05657*height), control2: CGPoint(x: 2.43945*width, y: 5.09033*height))
                path.addCurve(to: CGPoint(x: 2.47156*width, y: 5.19343*height), control1: CGPoint(x: 2.45963*width, y: 5.14234*height), control2: CGPoint(x: 2.46972*width, y: 5.17701*height))
                path.addCurve(to: CGPoint(x: 2.50826*width, y: 5.33303*height), control1: CGPoint(x: 2.47706*width, y: 5.23723*height), control2: CGPoint(x: 2.49633*width, y: 5.31204*height))
                path.addCurve(to: CGPoint(x: 2.52018*width, y: 5.33668*height), control1: CGPoint(x: 2.5156*width, y: 5.34763*height), control2: CGPoint(x: 2.51835*width, y: 5.34854*height))
                path.addCurve(to: CGPoint(x: 2.55505*width, y: 5.31113*height), control1: CGPoint(x: 2.52202*width, y: 5.32938*height), control2: CGPoint(x: 2.53761*width, y: 5.31752*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.53486*width, y: 5.30839*height))
                path.addCurve(to: CGPoint(x: 3.55046*width, y: 5.24179*height), control1: CGPoint(x: 3.53761*width, y: 5.29197*height), control2: CGPoint(x: 3.54404*width, y: 5.26186*height))
                path.addCurve(to: CGPoint(x: 3.59633*width, y: 5.02099*height), control1: CGPoint(x: 3.57523*width, y: 5.1542*height), control2: CGPoint(x: 3.59633*width, y: 5.05657*height))
                path.addCurve(to: CGPoint(x: 3.6055*width, y: 4.97719*height), control1: CGPoint(x: 3.59633*width, y: 5.0*height), control2: CGPoint(x: 3.60092*width, y: 4.97993*height))
                path.addCurve(to: CGPoint(x: 3.61468*width, y: 4.9562*height), control1: CGPoint(x: 3.61101*width, y: 4.97445*height), control2: CGPoint(x: 3.61468*width, y: 4.96442*height))
                path.addCurve(to: CGPoint(x: 3.63486*width, y: 4.90237*height), control1: CGPoint(x: 3.61468*width, y: 4.94799*height), control2: CGPoint(x: 3.62385*width, y: 4.92336*height))
                path.addCurve(to: CGPoint(x: 3.68165*width, y: 4.85949*height), control1: CGPoint(x: 3.64954*width, y: 4.875*height), control2: CGPoint(x: 3.66239*width, y: 4.86314*height))
                path.addCurve(to: CGPoint(x: 3.7844*width, y: 4.7792*height), control1: CGPoint(x: 3.69908*width, y: 4.85584*height), control2: CGPoint(x: 3.73578*width, y: 4.82664*height))
                path.addCurve(to: CGPoint(x: 3.86697*width, y: 4.64872*height), control1: CGPoint(x: 3.85963*width, y: 4.70438*height), control2: CGPoint(x: 3.86055*width, y: 4.70255*height))
                path.addCurve(to: CGPoint(x: 3.88073*width, y: 4.54653*height), control1: CGPoint(x: 3.86972*width, y: 4.61861*height), control2: CGPoint(x: 3.87615*width, y: 4.57299*height))
                path.addCurve(to: CGPoint(x: 3.9055*width, y: 4.13777*height), control1: CGPoint(x: 3.89633*width, y: 4.45803*height), control2: CGPoint(x: 3.91009*width, y: 4.21989*height))
                path.addCurve(to: CGPoint(x: 3.86422*width, y: 3.95073*height), control1: CGPoint(x: 3.90183*width, y: 4.07391*height), control2: CGPoint(x: 3.89266*width, y: 4.03193*height))
                path.addCurve(to: CGPoint(x: 3.69908*width, y: 3.57847*height), control1: CGPoint(x: 3.80092*width, y: 3.77007*height), control2: CGPoint(x: 3.75413*width, y: 3.66515*height))
                path.addCurve(to: CGPoint(x: 3.55872*width, y: 3.24544*height), control1: CGPoint(x: 3.63761*width, y: 3.48084*height), control2: CGPoint(x: 3.57706*width, y: 3.3385*height))
                path.addCurve(to: CGPoint(x: 3.53303*width, y: 3.18978*height), control1: CGPoint(x: 3.54954*width, y: 3.19526*height), control2: CGPoint(x: 3.54404*width, y: 3.18522*height))
                path.addCurve(to: CGPoint(x: 3.50275*width, y: 3.19982*height), control1: CGPoint(x: 3.52477*width, y: 3.19252*height), control2: CGPoint(x: 3.51101*width, y: 3.19799*height))
                path.addCurve(to: CGPoint(x: 3.48624*width, y: 3.22536*height), control1: CGPoint(x: 3.49358*width, y: 3.20255*height), control2: CGPoint(x: 3.48624*width, y: 3.2135*height))
                path.addCurve(to: CGPoint(x: 3.4633*width, y: 3.2719*height), control1: CGPoint(x: 3.48624*width, y: 3.23631*height), control2: CGPoint(x: 3.47615*width, y: 3.2573*height))
                path.addCurve(to: CGPoint(x: 3.40275*width, y: 3.34124*height), control1: CGPoint(x: 3.45046*width, y: 3.2865*height), control2: CGPoint(x: 3.42294*width, y: 3.31752*height))
                path.addCurve(to: CGPoint(x: 3.30642*width, y: 3.39051*height), control1: CGPoint(x: 3.36239*width, y: 3.38777*height), control2: CGPoint(x: 3.34128*width, y: 3.39872*height))
                path.addCurve(to: CGPoint(x: 3.25688*width, y: 3.30748*height), control1: CGPoint(x: 3.28165*width, y: 3.38412*height), control2: CGPoint(x: 3.25688*width, y: 3.34307*height))
                path.addCurve(to: CGPoint(x: 3.17798*width, y: 3.2427*height), control1: CGPoint(x: 3.25688*width, y: 3.27464*height), control2: CGPoint(x: 3.22752*width, y: 3.25*height))
                path.addCurve(to: CGPoint(x: 3.09266*width, y: 3.55383*height), control1: CGPoint(x: 3.10826*width, y: 3.23266*height), control2: CGPoint(x: 3.11009*width, y: 3.22628*height))
                path.addCurve(to: CGPoint(x: 3.05505*width, y: 4.39781*height), control1: CGPoint(x: 3.08073*width, y: 3.77007*height), control2: CGPoint(x: 3.06697*width, y: 4.08303*height))
                path.addCurve(to: CGPoint(x: 3.04037*width, y: 4.74453*height), control1: CGPoint(x: 3.04954*width, y: 4.53102*height), control2: CGPoint(x: 3.04312*width, y: 4.68704*height))
                path.addLine(to: CGPoint(x: 3.03578*width, y: 4.84945*height))
                path.addLine(to: CGPoint(x: 3.07156*width, y: 4.86679*height))
                path.addCurve(to: CGPoint(x: 3.34954*width, y: 5.16058*height), control1: CGPoint(x: 3.12018*width, y: 4.8896*height), control2: CGPoint(x: 3.28349*width, y: 5.06204*height))
                path.addCurve(to: CGPoint(x: 3.48165*width, y: 5.31752*height), control1: CGPoint(x: 3.43211*width, y: 5.28376*height), control2: CGPoint(x: 3.44587*width, y: 5.30018*height))
                path.addCurve(to: CGPoint(x: 3.53486*width, y: 5.30839*height), control1: CGPoint(x: 3.53119*width, y: 5.34124*height), control2: CGPoint(x: 3.52936*width, y: 5.34124*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
