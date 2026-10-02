import SwiftUI

extension MuscleMap {
    public enum Structure: String, CaseIterable, Sendable {
        case contour
        case head
        case neck
        case trapezius
        case deltoid
        case pectoralisMajor
        case externalOblique
        case abdominals
        case biceps
        case forearms
        case hips
        case hands
        case quadriceps
        case calves
        case tibialisAnterior
        case tibiaAndFoot
        case infraspinatus
        case teresMajor
        case triceps
        case latissimusDorsi
        case lowerBack
        case gluteus
        case thighs
        case hamstrings
        
        public func has(target: String) -> Bool {
            let phrase = String(target.trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()
            guard !phrase.isEmpty else {
                return false
            }
            return phrase == rawValue.lowercased() || phrase == displayName.lowercased()
        }
        
        public var displayName: String {
            switch self {
            case .contour: return "contour"
            case .head: return "head"
            case .neck: return "neck"
            case .trapezius: return "trapezius"
            case .deltoid: return "deltoid"
            case .pectoralisMajor: return "pectoralis major"
            case .externalOblique: return "external oblique"
            case .abdominals: return "abdominals"
            case .biceps: return "biceps"
            case .forearms: return "forearms"
            case .hips: return "hips"
            case .hands: return "hands"
            case .quadriceps: return "quadriceps"
            case .calves: return "calves"
            case .tibialisAnterior: return "tibialis anterior"
            case .tibiaAndFoot: return "tibia and foot"
            case .infraspinatus: return "infraspinatus"
            case .teresMajor: return "teres major"
            case .triceps: return "triceps"
            case .latissimusDorsi: return "latissimus dorsi"
            case .lowerBack: return "lower back"
            case .gluteus: return "gluteus"
            case .thighs: return "thighs"
            case .hamstrings: return "hamstrings"
            }
        }
        
        public static func create(displayName: String) -> Structure? {
            let phrase = String(displayName.trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()
            return allCases.first { structure in
                phrase == structure.rawValue.lowercased() || phrase == structure.displayName.lowercased()
            }
        }
    }
}
