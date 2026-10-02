import SwiftUI

public struct MuscleMap: View {
    public enum Visibility: Equatable, CaseIterable, Sendable { case front, back, both }

    struct HitTarget {
        let region: MuscleMapHitRegion
        let structure: MuscleMap.Structure
    }
    
    private var structureSelect: (MuscleMap.Structure) -> Void = { _ in }
    private var styleRequest: (MuscleMap.Structure) -> MuscleMap.Style? = { _ in return nil }
    
    private let size: Double
    private let visibility: Visibility
    private var userInteractionEnabled: Bool
    
    private var offset: Double {
        switch visibility {
        case .front: return 5.0
        case .back: return -5.2
        case .both: return 0.0
        }
    }
    
    public init(size: Double, visibility: Visibility = .both, userInteractionEnabled: Bool = false) {
        self.size = size.isFinite ? max(0, size) : 0
        self.visibility = visibility
        self.userInteractionEnabled = userInteractionEnabled
    }
    
    @ViewBuilder public var body: some View {
        mapBody
            .componentAccessibilityChildren(.ignore)
            .accessibilityLabel("Muscle map")
            #if !os(Android)
            .accessibilityActions {
                if userInteractionEnabled {
                    ForEach(Structure.allCases, id: \.self) { structure in
                        Button(structure.displayName) { structureSelect(structure) }
                    }
                }
            }
            #endif
    }

    var mapBody: some View {
        ZStack {
            switch visibility {
            case .front:
                MuscleMap.Front(translationX: offset, styleRequest: styleRequest)
                    .frame(width: size, height: size)
            case .back:
                MuscleMap.Back(translationX: offset, styleRequest: styleRequest)
                    .frame(width: size, height: size)
            case .both:
                MuscleMap.Front(styleRequest: styleRequest)
                    .frame(width: size, height: size)
                MuscleMap.Back(styleRequest: styleRequest)
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
        .componentHitArea(Rectangle())
        #if os(tvOS)
        .overlay(alignment: .bottom) {
            if userInteractionEnabled {
                Menu("Select region") {
                    ForEach(Structure.allCases, id: \.self) { structure in
                        Button(structure.displayName) { structureSelect(structure) }
                    }
                }
            }
        }
        #else
        .if(userInteractionEnabled) { content in
            content.onTapGesture(coordinateSpace: .local) { location in
                selectStructure(at: location)
            }
        }
        #endif
    }
    private var hitTargets: [MuscleMap.HitTarget] {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        switch visibility {
        case .front:
            return MuscleMap.Front(translationX: offset).hitTargets(in: frame)
        case .back:
            return MuscleMap.Back(translationX: offset).hitTargets(in: frame)
        case .both:
            return MuscleMap.Front().hitTargets(in: frame)
                + MuscleMap.Back().hitTargets(in: frame)
        }
    }

    private func selectStructure(at location: CGPoint) {
        guard let structure = MuscleMap.resolveStructure(
            at: location,
            targets: hitTargets,
            size: CGSize(width: size, height: size)
        ) else {
            return
        }
        structureSelect(structure)
    }

    static func resolveStructure(
        at location: CGPoint,
        targets: [MuscleMap.HitTarget],
        size: CGSize
    ) -> MuscleMap.Structure? {
        let smallMusclePadding = max(3.0, min(size.width, size.height) * 0.018)
        var closestSmallMuscle: (structure: MuscleMap.Structure, score: Double)?

        for target in targets where target.structure == .teresMajor || target.structure == .infraspinatus {
            let score = target.region.contains(location) ? 0.0 : target.region.distance(to: location)
            if score <= smallMusclePadding,
               score < (closestSmallMuscle?.score ?? .infinity) {
                closestSmallMuscle = (target.structure, score)
            }
        }
        if let closestSmallMuscle {
            return closestSmallMuscle.structure
        }

        if let exactTarget = targets.first(where: { $0.region.contains(location) }) {
            return exactTarget.structure
        }

        let generalPadding = max(3.0, min(size.width, size.height) * 0.016)
        var closestTarget: (structure: MuscleMap.Structure, distance: Double)?
        for target in targets {
            let distance = target.region.distance(to: location)
            if distance <= generalPadding,
               distance < (closestTarget?.distance ?? .infinity) {
                closestTarget = (target.structure, distance)
            }
        }
        return closestTarget?.structure
    }
    
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
