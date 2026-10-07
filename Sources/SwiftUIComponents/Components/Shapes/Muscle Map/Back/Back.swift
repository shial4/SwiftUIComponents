import SwiftUI

extension MuscleMap {
    public struct Back: View {
        var structureSelect: (MuscleMap.Structure) -> Void
        var styleRequest: (MuscleMap.Structure) -> MuscleMap.Style?
        var translationX: Double
        
        public init(
            translationX: Double = 0,
            structureSelect: @escaping (MuscleMap.Structure) -> Void = { _ in },
            styleRequest: @escaping (MuscleMap.Structure) -> MuscleMap.Style? = { _ in return nil }
        ) {
            self.translationX = translationX
            self.structureSelect = structureSelect
            self.styleRequest = styleRequest
        }
        
        public var body: some View {
            ZStack {
                ZStack {
                    // Contour
                    MuscleMap.Back.Contour(translationX: translationX)
                        .fill(configuration(.contour))
                    // Head
                    MuscleMap.Back.Head(translationX: translationX)
                        .fill(configuration(.head))
                    // Trapezius
                    MuscleMap.Back.Trapezius(translationX: translationX)
                        .fill(configuration(.trapezius))
                    // Deltoid (Shoulders)
                    MuscleMap.Back.Deltoid(translationX: translationX)
                        .fill(configuration(.deltoid))
                    // Infraspinatus (Rotator cuff)
                    MuscleMap.Back.Infraspinatus(translationX: translationX)
                        .fill(configuration(.infraspinatus))
                    // TeresMajor (Rotator cuff)
                    MuscleMap.Back.TeresMajor(translationX: translationX)
                        .fill(configuration(.teresMajor))
                    // Triceps
                    MuscleMap.Back.Triceps(translationX: translationX)
                        .fill(configuration(.triceps))
                    // LatissimusDorsi
                    MuscleMap.Back.LatissimusDorsi(translationX: translationX)
                        .fill(configuration(.latissimusDorsi))
                    // Forearms
                    MuscleMap.Back.Forearms(translationX: translationX)
                        .fill(configuration(.forearms))
                    // LowerBack
                    MuscleMap.Back.LowerBack(translationX: translationX)
                        .fill(configuration(.lowerBack))
                }
                ZStack {
                    // Gluteus
                    MuscleMap.Back.Gluteus(translationX: translationX)
                        .fill(configuration(.gluteus))
                    // Hands
                    MuscleMap.Back.Hands(translationX: translationX)
                        .fill(configuration(.hands))
                    // Thighs
                    MuscleMap.Back.Thighs(translationX: translationX)
                        .fill(configuration(.thighs))
                    // Hamstrings
                    MuscleMap.Back.Hamstrings(translationX: translationX)
                        .fill(configuration(.hamstrings))
                    // Calves
                    MuscleMap.Back.Calves(translationX: translationX)
                        .fill(configuration(.calves))
                    // Foot
                    MuscleMap.Back.Foot(translationX: translationX)
                        .fill(configuration(.tibiaAndFoot))
                }
            }
        }
        
        func hitTargets(in rect: CGRect) -> [MuscleMap.HitTarget] {
            let shapes: [(shape: any MuscleMapShape, structure: MuscleMap.Structure)] = [
                (MuscleMap.Back.Head(translationX: translationX), .head),
                (MuscleMap.Back.TeresMajor(translationX: translationX), .teresMajor),
                (MuscleMap.Back.Infraspinatus(translationX: translationX), .infraspinatus),
                (MuscleMap.Back.LatissimusDorsi(translationX: translationX), .latissimusDorsi),
                (MuscleMap.Back.Deltoid(translationX: translationX), .deltoid),
                (MuscleMap.Back.Triceps(translationX: translationX), .triceps),
                (MuscleMap.Back.Forearms(translationX: translationX), .forearms),
                (MuscleMap.Back.Trapezius(translationX: translationX), .trapezius),
                (MuscleMap.Back.LowerBack(translationX: translationX), .lowerBack),
                (MuscleMap.Back.Gluteus(translationX: translationX), .gluteus),
                (MuscleMap.Back.Hands(translationX: translationX), .hands),
                (MuscleMap.Back.Thighs(translationX: translationX), .thighs),
                (MuscleMap.Back.Hamstrings(translationX: translationX), .hamstrings),
                (MuscleMap.Back.Calves(translationX: translationX), .calves),
                (MuscleMap.Back.Foot(translationX: translationX), .tibiaAndFoot),
                (MuscleMap.Back.Contour(translationX: translationX), .contour),
            ]

            return shapes.map { shape, structure in
                MuscleMap.HitTarget(region: shape.hitRegion(in: rect), structure: structure)
            }
        }

        func structure(at location: CGPoint, in rect: CGRect) -> MuscleMap.Structure? {
            MuscleMap.resolveStructure(at: location, targets: hitTargets(in: rect), size: rect.size)
        }

        public func handleTap(location: CGPoint, in rect: CGRect) {
            guard let structure = structure(at: location, in: rect) else {
                return
            }
            structureSelect(structure)
        }
        
        private func configuration(_ structure: MuscleMap.Structure) -> MuscleMap.Style {
            return styleRequest(structure) ?? MuscleMap.Style()
        }
        
        // MARK: Modifiers
        
        public func onStyleRequest(_ closure: @escaping (MuscleMap.Structure) -> MuscleMap.Style?) -> Self {
            var view = self
            view.styleRequest = closure
            return view
        }
        
        public func onStructureSelect(_ closure: @escaping (MuscleMap.Structure) -> Void) -> Self {
            var view = self
            view.structureSelect = closure
            return view
        }
    }
}
 
