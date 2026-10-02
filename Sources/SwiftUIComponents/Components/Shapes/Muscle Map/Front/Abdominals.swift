import SwiftUI

extension MuscleMap.Front {
    public struct Abdominals: MuscleMapShape {
        public var translationX: Double
        
        public init(translationX: Double = 0) {
            self.translationX = translationX
        }
        
        nonisolated public func paths(width: Double, height: Double) -> [MuscleMapVectorPath] {
            var paths: [MuscleMapVectorPath] = []
            
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.97523*width, y: 6.93887*height))
                path.addCurve(to: CGPoint(x: 2.98899*width, y: 6.80566*height), control1: CGPoint(x: 2.98899*width, y: 6.91971*height), control2: CGPoint(x: 2.99083*width, y: 6.90055*height))
                path.addLine(to: CGPoint(x: 2.98624*width, y: 6.69526*height))
                path.addLine(to: CGPoint(x: 2.88991*width, y: 6.64507*height))
                path.addCurve(to: CGPoint(x: 2.62202*width, y: 6.5146*height), control1: CGPoint(x: 2.7*width, y: 6.54562*height), control2: CGPoint(x: 2.63486*width, y: 6.5146*height))
                path.addCurve(to: CGPoint(x: 2.61009*width, y: 6.71989*height), control1: CGPoint(x: 2.59358*width, y: 6.5146*height), control2: CGPoint(x: 2.58807*width, y: 6.6177*height))
                path.addCurve(to: CGPoint(x: 2.65321*width, y: 6.86223*height), control1: CGPoint(x: 2.63578*width, y: 6.83668*height), control2: CGPoint(x: 2.64037*width, y: 6.85493*height))
                path.addCurve(to: CGPoint(x: 2.7844*width, y: 6.90693*height), control1: CGPoint(x: 2.65963*width, y: 6.86679*height), control2: CGPoint(x: 2.71835*width, y: 6.88686*height))
                path.addCurve(to: CGPoint(x: 2.92202*width, y: 6.95255*height), control1: CGPoint(x: 2.84954*width, y: 6.92792*height), control2: CGPoint(x: 2.91193*width, y: 6.94799*height))
                path.addCurve(to: CGPoint(x: 2.97523*width, y: 6.93887*height), control1: CGPoint(x: 2.95046*width, y: 6.96442*height), control2: CGPoint(x: 2.9578*width, y: 6.96259*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.17431*width, y: 6.92974*height))
                path.addCurve(to: CGPoint(x: 3.30275*width, y: 6.89051*height), control1: CGPoint(x: 3.21743*width, y: 6.91606*height), control2: CGPoint(x: 3.27523*width, y: 6.89872*height))
                path.addCurve(to: CGPoint(x: 3.40367*width, y: 6.79927*height), control1: CGPoint(x: 3.3789*width, y: 6.86861*height), control2: CGPoint(x: 3.38991*width, y: 6.85858*height))
                path.addCurve(to: CGPoint(x: 3.42294*width, y: 6.7208*height), control1: CGPoint(x: 3.40917*width, y: 6.77099*height), control2: CGPoint(x: 3.41835*width, y: 6.7354*height))
                path.addCurve(to: CGPoint(x: 3.43119*width, y: 6.60858*height), control1: CGPoint(x: 3.42752*width, y: 6.7062*height), control2: CGPoint(x: 3.43119*width, y: 6.65602*height))
                path.addCurve(to: CGPoint(x: 3.41651*width, y: 6.51734*height), control1: CGPoint(x: 3.43119*width, y: 6.53832*height), control2: CGPoint(x: 3.42844*width, y: 6.5219*height))
                path.addCurve(to: CGPoint(x: 3.09908*width, y: 6.66697*height), control1: CGPoint(x: 3.40275*width, y: 6.51277*height), control2: CGPoint(x: 3.3633*width, y: 6.53102*height))
                path.addLine(to: CGPoint(x: 3.0367*width, y: 6.69891*height))
                path.addLine(to: CGPoint(x: 3.0367*width, y: 6.80201*height))
                path.addCurve(to: CGPoint(x: 3.05321*width, y: 6.93431*height), control1: CGPoint(x: 3.0367*width, y: 6.88321*height), control2: CGPoint(x: 3.04037*width, y: 6.9115*height))
                path.addCurve(to: CGPoint(x: 3.08257*width, y: 6.95803*height), control1: CGPoint(x: 3.06239*width, y: 6.95073*height), control2: CGPoint(x: 3.07431*width, y: 6.96077*height))
                path.addCurve(to: CGPoint(x: 3.17431*width, y: 6.92974*height), control1: CGPoint(x: 3.08991*width, y: 6.9562*height), control2: CGPoint(x: 3.13119*width, y: 6.94343*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.38991*width, y: 6.44526*height))
                path.addCurve(to: CGPoint(x: 3.39541*width, y: 6.32391*height), control1: CGPoint(x: 3.40459*width, y: 6.41332*height), control2: CGPoint(x: 3.40826*width, y: 6.34398*height))
                path.addCurve(to: CGPoint(x: 3.27798*width, y: 6.32208*height), control1: CGPoint(x: 3.38807*width, y: 6.31296*height), control2: CGPoint(x: 3.37064*width, y: 6.31204*height))
                path.addCurve(to: CGPoint(x: 3.04862*width, y: 6.36131*height), control1: CGPoint(x: 3.14404*width, y: 6.33485*height), control2: CGPoint(x: 3.0633*width, y: 6.34945*height))
                path.addCurve(to: CGPoint(x: 3.0367*width, y: 6.47445*height), control1: CGPoint(x: 3.04037*width, y: 6.3677*height), control2: CGPoint(x: 3.0367*width, y: 6.40237*height))
                path.addCurve(to: CGPoint(x: 3.06147*width, y: 6.60036*height), control1: CGPoint(x: 3.0367*width, y: 6.57482*height), control2: CGPoint(x: 3.03761*width, y: 6.57847*height))
                path.addLine(to: CGPoint(x: 3.08624*width, y: 6.62318*height))
                path.addLine(to: CGPoint(x: 3.23028*width, y: 6.54927*height))
                path.addCurve(to: CGPoint(x: 3.38991*width, y: 6.44526*height), control1: CGPoint(x: 3.35229*width, y: 6.48723*height), control2: CGPoint(x: 3.37798*width, y: 6.46989*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.97615*width, y: 6.59763*height))
                path.addCurve(to: CGPoint(x: 2.98899*width, y: 6.46898*height), control1: CGPoint(x: 2.98899*width, y: 6.58394*height), control2: CGPoint(x: 2.99083*width, y: 6.56387*height))
                path.addLine(to: CGPoint(x: 2.98624*width, y: 6.35584*height))
                path.addLine(to: CGPoint(x: 2.95872*width, y: 6.34854*height))
                path.addCurve(to: CGPoint(x: 2.84404*width, y: 6.33212*height), control1: CGPoint(x: 2.94404*width, y: 6.34398*height), control2: CGPoint(x: 2.89174*width, y: 6.33668*height))
                path.addCurve(to: CGPoint(x: 2.7*width, y: 6.31752*height), control1: CGPoint(x: 2.79633*width, y: 6.32755*height), control2: CGPoint(x: 2.73119*width, y: 6.32026*height))
                path.addCurve(to: CGPoint(x: 2.63211*width, y: 6.33485*height), control1: CGPoint(x: 2.64495*width, y: 6.31204*height), control2: CGPoint(x: 2.6422*width, y: 6.31204*height))
                path.addCurve(to: CGPoint(x: 2.65872*width, y: 6.46715*height), control1: CGPoint(x: 2.6156*width, y: 6.37135*height), control2: CGPoint(x: 2.62936*width, y: 6.44069*height))
                path.addCurve(to: CGPoint(x: 2.94128*width, y: 6.61405*height), control1: CGPoint(x: 2.69174*width, y: 6.49635*height), control2: CGPoint(x: 2.91651*width, y: 6.61405*height))
                path.addCurve(to: CGPoint(x: 2.97615*width, y: 6.59763*height), control1: CGPoint(x: 2.95138*width, y: 6.61496*height), control2: CGPoint(x: 2.96697*width, y: 6.60766*height))
                path.closeSubpath()
            })
            // tendinous intersections
            paths.append(MuscleMapVectorPath { path in
                
                path.move(to: CGPoint(x: 2.97615*width, y: 6.27555*height))
                path.addCurve(to: CGPoint(x: 2.97706*width, y: 5.9854*height), control1: CGPoint(x: 2.99725*width, y: 6.24635*height), control2: CGPoint(x: 2.99725*width, y: 6.00182*height))
                path.addCurve(to: CGPoint(x: 2.81468*width, y: 5.98175*height), control1: CGPoint(x: 2.96697*width, y: 5.97719*height), control2: CGPoint(x: 2.92936*width, y: 5.97628*height))
                path.addLine(to: CGPoint(x: 2.66514*width, y: 5.98996*height))
                path.addLine(to: CGPoint(x: 2.64954*width, y: 6.02372*height))
                path.addCurve(to: CGPoint(x: 2.62752*width, y: 6.13504*height), control1: CGPoint(x: 2.64037*width, y: 6.04288*height), control2: CGPoint(x: 2.63028*width, y: 6.09307*height))
                path.addCurve(to: CGPoint(x: 2.63578*width, y: 6.2354*height), control1: CGPoint(x: 2.62202*width, y: 6.19799*height), control2: CGPoint(x: 2.62385*width, y: 6.21715*height))
                path.addCurve(to: CGPoint(x: 2.82569*width, y: 6.28558*height), control1: CGPoint(x: 2.65138*width, y: 6.25821*height), control2: CGPoint(x: 2.64771*width, y: 6.2573*height))
                path.addCurve(to: CGPoint(x: 2.97615*width, y: 6.27555*height), control1: CGPoint(x: 2.92018*width, y: 6.30018*height), control2: CGPoint(x: 2.96055*width, y: 6.29745*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.19541*width, y: 6.28558*height))
                path.addCurve(to: CGPoint(x: 3.39633*width, y: 6.23814*height), control1: CGPoint(x: 3.38807*width, y: 6.2573*height), control2: CGPoint(x: 3.38532*width, y: 6.25821*height))
                path.addCurve(to: CGPoint(x: 3.36881*width, y: 6.00091*height), control1: CGPoint(x: 3.41927*width, y: 6.19708*height), control2: CGPoint(x: 3.39908*width, y: 6.02737*height))
                path.addCurve(to: CGPoint(x: 3.05596*width, y: 5.98449*height), control1: CGPoint(x: 3.34771*width, y: 5.98266*height), control2: CGPoint(x: 3.08532*width, y: 5.96898*height))
                path.addCurve(to: CGPoint(x: 3.0367*width, y: 6.12318*height), control1: CGPoint(x: 3.03761*width, y: 5.99453*height), control2: CGPoint(x: 3.0367*width, y: 6.00274*height))
                path.addCurve(to: CGPoint(x: 3.19541*width, y: 6.28558*height), control1: CGPoint(x: 3.0367*width, y: 6.30383*height), control2: CGPoint(x: 3.04128*width, y: 6.30839*height))
                path.closeSubpath()
            })
            // Rectus Abdominis
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 2.94771*width, y: 5.91423*height))
                path.addLine(to: CGPoint(x: 2.99083*width, y: 5.89507*height))
                path.addLine(to: CGPoint(x: 2.99083*width, y: 5.40146*height))
                path.addCurve(to: CGPoint(x: 2.9844*width, y: 4.90876*height), control1: CGPoint(x: 2.99083*width, y: 5.13047*height), control2: CGPoint(x: 2.98807*width, y: 4.90876*height))
                path.addCurve(to: CGPoint(x: 2.82477*width, y: 5.07299*height), control1: CGPoint(x: 2.95688*width, y: 4.91058*height), control2: CGPoint(x: 2.8367*width, y: 5.03376*height))
                path.addCurve(to: CGPoint(x: 2.79817*width, y: 5.14142*height), control1: CGPoint(x: 2.81927*width, y: 5.09033*height), control2: CGPoint(x: 2.80734*width, y: 5.12135*height))
                path.addCurve(to: CGPoint(x: 2.76606*width, y: 5.22354*height), control1: CGPoint(x: 2.78899*width, y: 5.1615*height), control2: CGPoint(x: 2.77431*width, y: 5.19891*height))
                path.addCurve(to: CGPoint(x: 2.7422*width, y: 5.28467*height), control1: CGPoint(x: 2.7578*width, y: 5.24909*height), control2: CGPoint(x: 2.74679*width, y: 5.27646*height))
                path.addCurve(to: CGPoint(x: 2.73394*width, y: 5.31752*height), control1: CGPoint(x: 2.73761*width, y: 5.2938*height), control2: CGPoint(x: 2.73394*width, y: 5.30839*height))
                path.addCurve(to: CGPoint(x: 2.72661*width, y: 5.34307*height), control1: CGPoint(x: 2.73394*width, y: 5.32664*height), control2: CGPoint(x: 2.73028*width, y: 5.33759*height))
                path.addCurve(to: CGPoint(x: 2.66881*width, y: 5.57482*height), control1: CGPoint(x: 2.71284*width, y: 5.35766*height), control2: CGPoint(x: 2.68991*width, y: 5.45164*height))
                path.addCurve(to: CGPoint(x: 2.6633*width, y: 5.90693*height), control1: CGPoint(x: 2.65505*width, y: 5.65237*height), control2: CGPoint(x: 2.65229*width, y: 5.8531*height))
                path.addLine(to: CGPoint(x: 2.67064*width, y: 5.94252*height))
                path.addLine(to: CGPoint(x: 2.78716*width, y: 5.93796*height))
                path.addCurve(to: CGPoint(x: 2.94771*width, y: 5.91423*height), control1: CGPoint(x: 2.87798*width, y: 5.93431*height), control2: CGPoint(x: 2.91284*width, y: 5.92883*height))
                path.closeSubpath()
            })
            paths.append(MuscleMapVectorPath { path in
                path.move(to: CGPoint(x: 3.37248*width, y: 5.86953*height))
                path.addCurve(to: CGPoint(x: 3.3578*width, y: 5.54015*height), control1: CGPoint(x: 3.37982*width, y: 5.78832*height), control2: CGPoint(x: 3.37156*width, y: 5.60401*height))
                path.addCurve(to: CGPoint(x: 3.33853*width, y: 5.45164*height), control1: CGPoint(x: 3.35229*width, y: 5.51642*height), control2: CGPoint(x: 3.34404*width, y: 5.47719*height))
                path.addCurve(to: CGPoint(x: 3.26697*width, y: 5.21442*height), control1: CGPoint(x: 3.32385*width, y: 5.38321*height), control2: CGPoint(x: 3.28532*width, y: 5.25547*height))
                path.addCurve(to: CGPoint(x: 3.23853*width, y: 5.14599*height), control1: CGPoint(x: 3.2578*width, y: 5.19434*height), control2: CGPoint(x: 3.24495*width, y: 5.16332*height))
                path.addCurve(to: CGPoint(x: 3.14771*width, y: 4.9927*height), control1: CGPoint(x: 3.2156*width, y: 5.08029*height), control2: CGPoint(x: 3.18807*width, y: 5.03376*height))
                path.addCurve(to: CGPoint(x: 3.0422*width, y: 4.90876*height), control1: CGPoint(x: 3.10734*width, y: 4.95164*height), control2: CGPoint(x: 3.05321*width, y: 4.90876*height))
                path.addCurve(to: CGPoint(x: 3.0367*width, y: 5.40146*height), control1: CGPoint(x: 3.03945*width, y: 4.90876*height), control2: CGPoint(x: 3.0367*width, y: 5.13047*height))
                path.addCurve(to: CGPoint(x: 3.05413*width, y: 5.90328*height), control1: CGPoint(x: 3.0367*width, y: 5.87956*height), control2: CGPoint(x: 3.03761*width, y: 5.89416*height))
                path.addCurve(to: CGPoint(x: 3.26789*width, y: 5.93887*height), control1: CGPoint(x: 3.09633*width, y: 5.92518*height), control2: CGPoint(x: 3.17615*width, y: 5.93887*height))
                path.addLine(to: CGPoint(x: 3.36514*width, y: 5.93978*height))
                path.addLine(to: CGPoint(x: 3.37248*width, y: 5.86953*height))
                path.closeSubpath()
            })
            return paths
        }
    }
}
