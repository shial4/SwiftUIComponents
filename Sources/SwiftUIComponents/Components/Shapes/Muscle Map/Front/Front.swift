import SwiftUI

extension MuscleMap {
    public struct Front: View {
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
                    MuscleMap.Front.Contour(translationX: translationX)
                        .fill(configuration(.contour))
                    // Head
                    MuscleMap.Front.Head(translationX: translationX)
                        .fill(configuration(.head))
                    // Neck
                    MuscleMap.Front.Neck(translationX: translationX)
                        .fill(configuration(.neck))
                    // Trapezius
                    MuscleMap.Front.Trapezius(translationX: translationX)
                        .fill(configuration(.trapezius))
                    // Deltoid (Shoulders)
                    MuscleMap.Front.Deltoid(translationX: translationX)
                        .fill(configuration(.deltoid))
                    // Pectoralis Major
                    MuscleMap.Front.PectoralisMajor(translationX: translationX)
                        .fill(configuration(.pectoralisMajor))
                    // External Oblique (Side ABS)
                    MuscleMap.Front.ExternalOblique(translationX: translationX)
                        .fill(configuration(.externalOblique))
                    // Abdominals
                    MuscleMap.Front.Abdominals(translationX: translationX)
                        .fill(configuration(.abdominals))
                    // Biceps
                    MuscleMap.Front.Biceps(translationX: translationX)
                        .fill(configuration(.biceps))
                    // Forearms
                    MuscleMap.Front.Forearms(translationX: translationX)
                        .fill(configuration(.forearms))
                }
                ZStack {
                    // Hips
                    MuscleMap.Front.Hips(translationX: translationX)
                        .fill(configuration(.hips))
                    // Hands
                    MuscleMap.Front.Hands(translationX: translationX)
                        .fill(configuration(.hands))
                    // Quadriceps
                    MuscleMap.Front.Quadriceps(translationX: translationX)
                        .fill(configuration(.quadriceps))
                    // Calves
                    MuscleMap.Front.Calves(translationX: translationX)
                        .fill(configuration(.calves))
                    // TibialisAnterior
                    MuscleMap.Front.TibialisAnterior(translationX: translationX)
                        .fill(configuration(.tibialisAnterior))
                    // TibiaAndFoot
                    MuscleMap.Front.TibiaAndFoot(translationX: translationX)
                        .fill(configuration(.tibiaAndFoot))
                }
            }
        }
        
        func hitTargets(in rect: CGRect) -> [MuscleMap.HitTarget] {
            let shapes: [(shape: any MuscleMapShape, structure: MuscleMap.Structure)] = [
                (MuscleMap.Front.Neck(translationX: translationX), .neck),
                (MuscleMap.Front.Trapezius(translationX: translationX), .trapezius),
                (MuscleMap.Front.Deltoid(translationX: translationX), .deltoid),
                (MuscleMap.Front.Abdominals(translationX: translationX), .abdominals),
                (MuscleMap.Front.Hips(translationX: translationX), .hips),
                (MuscleMap.Front.ExternalOblique(translationX: translationX), .externalOblique),
                (MuscleMap.Front.Head(translationX: translationX), .head),
                (MuscleMap.Front.PectoralisMajor(translationX: translationX), .pectoralisMajor),
                (MuscleMap.Front.Biceps(translationX: translationX), .biceps),
                (MuscleMap.Front.Forearms(translationX: translationX), .forearms),
                (MuscleMap.Front.Hands(translationX: translationX), .hands),
                (MuscleMap.Front.Quadriceps(translationX: translationX), .quadriceps),
                (MuscleMap.Front.Calves(translationX: translationX), .calves),
                (MuscleMap.Front.TibialisAnterior(translationX: translationX), .tibialisAnterior),
                (MuscleMap.Front.TibiaAndFoot(translationX: translationX), .tibiaAndFoot),
                (MuscleMap.Front.Contour(translationX: translationX), .contour),
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
            onSelect(structure)
        }
        
        private func configuration(_ structure: MuscleMap.Structure) -> MuscleMap.Style {
            return styleRequest(structure) ?? MuscleMap.Style()
        }
        
        private func onSelect(_ structure: MuscleMap.Structure) {
            structureSelect(structure)
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
