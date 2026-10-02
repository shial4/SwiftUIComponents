import SwiftUI

extension MuscleMap.Back {
    public struct Hands: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 5.33945*width, y: 5.31296*height))
                path.addCurve(to: CGPoint(x: 5.45596*width, y: 5.19161*height), control1: CGPoint(x: 5.33945*width, y: 5.29197*height), control2: CGPoint(x: 5.43578*width, y: 5.19161*height))
                path.addCurve(to: CGPoint(x: 5.48165*width, y: 5.18248*height), control1: CGPoint(x: 5.46697*width, y: 5.19161*height), control2: CGPoint(x: 5.4789*width, y: 5.18796*height))
                path.addCurve(to: CGPoint(x: 5.52294*width, y: 5.17336*height), control1: CGPoint(x: 5.4844*width, y: 5.17792*height), control2: CGPoint(x: 5.50367*width, y: 5.17336*height))
                path.addCurve(to: CGPoint(x: 5.57615*width, y: 5.1396*height), control1: CGPoint(x: 5.55596*width, y: 5.17336*height), control2: CGPoint(x: 5.56055*width, y: 5.16971*height))
                path.addCurve(to: CGPoint(x: 5.61009*width, y: 5.07391*height), control1: CGPoint(x: 5.58624*width, y: 5.12044*height), control2: CGPoint(x: 5.60092*width, y: 5.09124*height))
                path.addCurve(to: CGPoint(x: 5.59633*width, y: 4.88595*height), control1: CGPoint(x: 5.63211*width, y: 5.03193*height), control2: CGPoint(x: 5.62385*width, y: 4.91515*height))
                path.addCurve(to: CGPoint(x: 5.57798*width, y: 4.86131*height), control1: CGPoint(x: 5.58624*width, y: 4.875*height), control2: CGPoint(x: 5.57798*width, y: 4.86405*height))
                path.addCurve(to: CGPoint(x: 5.5367*width, y: 4.81387*height), control1: CGPoint(x: 5.57798*width, y: 4.85858*height), control2: CGPoint(x: 5.55963*width, y: 4.83668*height))
                path.addLine(to: CGPoint(x: 5.49541*width, y: 4.77099*height))
                path.addLine(to: CGPoint(x: 5.36514*width, y: 4.77372*height))
                path.addLine(to: CGPoint(x: 5.23394*width, y: 4.77646*height))
                path.addLine(to: CGPoint(x: 5.22018*width, y: 4.80383*height))
                path.addCurve(to: CGPoint(x: 5.23119*width, y: 5.10493*height), control1: CGPoint(x: 5.1945*width, y: 4.85675*height), control2: CGPoint(x: 5.20183*width, y: 5.07208*height))
                path.addCurve(to: CGPoint(x: 5.23853*width, y: 5.1469*height), control1: CGPoint(x: 5.23486*width, y: 5.10949*height), control2: CGPoint(x: 5.23853*width, y: 5.12865*height))
                path.addCurve(to: CGPoint(x: 5.24771*width, y: 5.18704*height), control1: CGPoint(x: 5.23853*width, y: 5.16606*height), control2: CGPoint(x: 5.2422*width, y: 5.18339*height))
                path.addCurve(to: CGPoint(x: 5.25138*width, y: 5.20438*height), control1: CGPoint(x: 5.25229*width, y: 5.18978*height), control2: CGPoint(x: 5.25413*width, y: 5.19799*height))
                path.addCurve(to: CGPoint(x: 5.29908*width, y: 5.36679*height), control1: CGPoint(x: 5.24771*width, y: 5.21533*height), control2: CGPoint(x: 5.28532*width, y: 5.34398*height))
                path.addCurve(to: CGPoint(x: 5.33945*width, y: 5.31296*height), control1: CGPoint(x: 5.3055*width, y: 5.37682*height), control2: CGPoint(x: 5.33945*width, y: 5.3312*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 8.62294*width, y: 5.2719*height))
                path.addCurve(to: CGPoint(x: 8.66972*width, y: 5.08942*height), control1: CGPoint(x: 8.63945*width, y: 5.21807*height), control2: CGPoint(x: 8.64862*width, y: 5.17974*height))
                path.addCurve(to: CGPoint(x: 8.65963*width, y: 4.79106*height), control1: CGPoint(x: 8.69541*width, y: 4.97354*height), control2: CGPoint(x: 8.69083*width, y: 4.82482*height))
                path.addCurve(to: CGPoint(x: 8.51835*width, y: 4.7719*height), control1: CGPoint(x: 8.64312*width, y: 4.77372*height), control2: CGPoint(x: 8.63119*width, y: 4.7719*height))
                path.addLine(to: CGPoint(x: 8.39541*width, y: 4.7719*height))
                path.addLine(to: CGPoint(x: 8.33028*width, y: 4.83759*height))
                path.addLine(to: CGPoint(x: 8.26606*width, y: 4.9042*height))
                path.addLine(to: CGPoint(x: 8.26606*width, y: 4.97445*height))
                path.addCurve(to: CGPoint(x: 8.29817*width, y: 5.11405*height), control1: CGPoint(x: 8.26606*width, y: 5.03467*height), control2: CGPoint(x: 8.27064*width, y: 5.05383*height))
                path.addCurve(to: CGPoint(x: 8.35321*width, y: 5.17701*height), control1: CGPoint(x: 8.32752*width, y: 5.17883*height), control2: CGPoint(x: 8.33119*width, y: 5.18248*height))
                path.addCurve(to: CGPoint(x: 8.54495*width, y: 5.31478*height), control1: CGPoint(x: 8.41009*width, y: 5.16332*height), control2: CGPoint(x: 8.5055*width, y: 5.23175*height))
                path.addCurve(to: CGPoint(x: 8.59908*width, y: 5.34124*height), control1: CGPoint(x: 8.56055*width, y: 5.34672*height), control2: CGPoint(x: 8.58716*width, y: 5.3604*height))
                path.addCurve(to: CGPoint(x: 8.62294*width, y: 5.2719*height), control1: CGPoint(x: 8.60275*width, y: 5.33485*height), control2: CGPoint(x: 8.61376*width, y: 5.30383*height))
                path.closeSubpath()
            })
            
            return paths
        }
    }
}
