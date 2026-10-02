import SwiftUI

extension MuscleMap.Front {
    public struct Hands: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 1.38991*width, y: 5.35675*height))
                path.addCurve(to: CGPoint(x: 1.43028*width, y: 5.28558*height), control1: CGPoint(x: 1.39266*width, y: 5.34763*height), control2: CGPoint(x: 1.41101*width, y: 5.31478*height))
                path.addCurve(to: CGPoint(x: 1.59083*width, y: 5.17336*height), control1: CGPoint(x: 1.47431*width, y: 5.21807*height), control2: CGPoint(x: 1.53761*width, y: 5.17336*height))
                path.addCurve(to: CGPoint(x: 1.65872*width, y: 5.11405*height), control1: CGPoint(x: 1.62752*width, y: 5.17336*height), control2: CGPoint(x: 1.62936*width, y: 5.17153*height))
                path.addCurve(to: CGPoint(x: 1.68807*width, y: 4.96533*height), control1: CGPoint(x: 1.68624*width, y: 5.06022*height), control2: CGPoint(x: 1.68807*width, y: 5.04927*height))
                path.addLine(to: CGPoint(x: 1.68807*width, y: 4.875*height))
                path.addLine(to: CGPoint(x: 1.61743*width, y: 4.82391*height))
                path.addLine(to: CGPoint(x: 1.54771*width, y: 4.7719*height))
                path.addLine(to: CGPoint(x: 1.43486*width, y: 4.7719*height))
                path.addCurve(to: CGPoint(x: 1.27982*width, y: 4.95438*height), control1: CGPoint(x: 1.28257*width, y: 4.7719*height), control2: CGPoint(x: 1.27982*width, y: 4.77464*height))
                path.addCurve(to: CGPoint(x: 1.3367*width, y: 5.2719*height), control1: CGPoint(x: 1.27982*width, y: 5.06934*height), control2: CGPoint(x: 1.28807*width, y: 5.1177*height))
                path.addCurve(to: CGPoint(x: 1.38991*width, y: 5.35675*height), control1: CGPoint(x: 1.36881*width, y: 5.37318*height), control2: CGPoint(x: 1.3789*width, y: 5.39051*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 4.69174*width, y: 5.2865*height))
                path.addCurve(to: CGPoint(x: 4.71468*width, y: 5.20438*height), control1: CGPoint(x: 4.7055*width, y: 5.24544*height), control2: CGPoint(x: 4.7156*width, y: 5.20894*height))
                path.addCurve(to: CGPoint(x: 4.71835*width, y: 5.18248*height), control1: CGPoint(x: 4.71376*width, y: 5.19982*height), control2: CGPoint(x: 4.71468*width, y: 5.18978*height))
                path.addCurve(to: CGPoint(x: 4.72844*width, y: 5.14142*height), control1: CGPoint(x: 4.7211*width, y: 5.17518*height), control2: CGPoint(x: 4.72569*width, y: 5.15693*height))
                path.addCurve(to: CGPoint(x: 4.74679*width, y: 5.05018*height), control1: CGPoint(x: 4.73119*width, y: 5.12682*height), control2: CGPoint(x: 4.73945*width, y: 5.08577*height))
                path.addCurve(to: CGPoint(x: 4.75596*width, y: 4.94069*height), control1: CGPoint(x: 4.75505*width, y: 5.01369*height), control2: CGPoint(x: 4.75872*width, y: 4.96624*height))
                path.addCurve(to: CGPoint(x: 4.74862*width, y: 4.85584*height), control1: CGPoint(x: 4.75413*width, y: 4.91606*height), control2: CGPoint(x: 4.75046*width, y: 4.87774*height))
                path.addCurve(to: CGPoint(x: 4.73028*width, y: 4.79562*height), control1: CGPoint(x: 4.74587*width, y: 4.83485*height), control2: CGPoint(x: 4.73853*width, y: 4.80748*height))
                path.addCurve(to: CGPoint(x: 4.5945*width, y: 4.77646*height), control1: CGPoint(x: 4.71651*width, y: 4.77372*height), control2: CGPoint(x: 4.71376*width, y: 4.77372*height))
                path.addLine(to: CGPoint(x: 4.47248*width, y: 4.78011*height))
                path.addLine(to: CGPoint(x: 4.40826*width, y: 4.82847*height))
                path.addLine(to: CGPoint(x: 4.34404*width, y: 4.87774*height))
                path.addLine(to: CGPoint(x: 4.34404*width, y: 4.97445*height))
                path.addCurve(to: CGPoint(x: 4.36055*width, y: 5.0885*height), control1: CGPoint(x: 4.34404*width, y: 5.05383*height), control2: CGPoint(x: 4.34679*width, y: 5.07391*height))
                path.addCurve(to: CGPoint(x: 4.37615*width, y: 5.11679*height), control1: CGPoint(x: 4.36881*width, y: 5.09854*height), control2: CGPoint(x: 4.37615*width, y: 5.11131*height))
                path.addCurve(to: CGPoint(x: 4.4422*width, y: 5.17336*height), control1: CGPoint(x: 4.37615*width, y: 5.1396*height), control2: CGPoint(x: 4.41651*width, y: 5.17336*height))
                path.addCurve(to: CGPoint(x: 4.62477*width, y: 5.32299*height), control1: CGPoint(x: 4.50275*width, y: 5.17336*height), control2: CGPoint(x: 4.58991*width, y: 5.24544*height))
                path.addCurve(to: CGPoint(x: 4.69174*width, y: 5.2865*height), control1: CGPoint(x: 4.65505*width, y: 5.39142*height), control2: CGPoint(x: 4.6578*width, y: 5.3896*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
