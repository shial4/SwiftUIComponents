import SwiftUI
import Testing
@testable import SwiftUIComponents

@Suite("Muscle Map names and selection")
struct MuscleMapTests {
    @Test("Names round trip and match case-insensitively", arguments: MuscleMap.Structure.allCases)
    func names(structure: MuscleMap.Structure) {
        #expect(MuscleMap.Structure.create(displayName: structure.displayName) == structure)
        #expect(MuscleMap.Structure.create(displayName: "  \(structure.rawValue.uppercased())\n") == structure)
        #expect(structure.has(target: structure.displayName.uppercased()))
        #expect(!structure.has(target: ""))
    }

    @Test("Unknown structure names are rejected")
    func unknownNames() {
        #expect(MuscleMap.Structure.create(displayName: "unknown") == nil)
        #expect(MuscleMap.Structure.create(displayName: "  ") == nil)
    }

    @MainActor @Test("Small muscles win nearby overlapping hit targets")
    func smallTargets() {
        let large = MuscleMap.HitTarget(region: MuscleMapHitRegion(polygons: [polygon(0, 0, 100)]), structure: .latissimusDorsi)
        let small = MuscleMap.HitTarget(region: MuscleMapHitRegion(polygons: [polygon(40, 40, 5)]), structure: .teresMajor)
        #expect(MuscleMap.resolveStructure(at: CGPoint(x: 46, y: 42), targets: [large, small], size: CGSize(width: 200, height: 200)) == .teresMajor)
        #expect(MuscleMap.resolveStructure(at: CGPoint(x: 20, y: 20), targets: [large, small], size: CGSize(width: 200, height: 200)) == .latissimusDorsi)
        #expect(MuscleMap.resolveStructure(at: CGPoint(x: 300, y: 300), targets: [large, small], size: CGSize(width: 200, height: 200)) == nil)
    }

    @MainActor @Test("A public front-side tap reports the resolved structure")
    func frontCallback() throws {
        var selected: MuscleMap.Structure?
        let front = MuscleMap.Front(translationX: 5).onStructureSelect { selected = $0 }
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let target = try #require(front.hitTargets(in: rect).first { $0.structure == .biceps })
        let point = try #require(target.region.polygons.first?.first)
        front.handleTap(location: point, in: rect)
        #expect(selected == .biceps)
        selected = nil
        front.handleTap(location: CGPoint(x: -100, y: -100), in: rect)
        #expect(selected == nil)
    }

    @MainActor @Test("Every named structure has a selectable hit region")
    func allStructuresSelectable() {
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let targets = MuscleMap.Front().hitTargets(in: rect) + MuscleMap.Back().hitTargets(in: rect)
        #expect(Set(targets.map(\.structure)) == Set(MuscleMap.Structure.allCases))
        #expect(targets.allSatisfy { !$0.region.polygons.isEmpty })
        let back = MuscleMap.Back().hitTargets(in: rect).map(\.structure)
        #expect(Set(back).count == back.count, "A structure should not repeat in one side's hit targets")
    }

    private func polygon(_ x: Double, _ y: Double, _ size: Double) -> [CGPoint] {
        [CGPoint(x: x, y: y), CGPoint(x: x + size, y: y), CGPoint(x: x + size, y: y + size), CGPoint(x: x, y: y + size)]
    }
}
