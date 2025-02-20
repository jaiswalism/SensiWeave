import Foundation

struct UserPreference: Codable, Identifiable {
    let id: UUID
    var skinType: SkinType
    var allergies: Set<Allergy>
    var temperature: Double
    var extraNotes: String
    
    init(id: UUID = UUID(), skinType: SkinType, allergies: Set<Allergy>, temperature: Double, extraNotes: String) {
        self.id = id
        self.skinType = skinType
        self.allergies = allergies
        self.temperature = temperature
        self.extraNotes = extraNotes
    }
    
    var allergiesDescription: String {
        allergies.isEmpty ? "None" : allergies.map { $0.rawValue }.joined(separator: ", ")
    }
}

enum SkinType: String, Codable, CaseIterable {
    case oily = "Oily"
    case dry = "Dry"
    case combination = "Combination"
    case sensitive = "Sensitive"
    case normal = "Normal"
}

enum Allergy: String, Codable, CaseIterable {
    case wool = "Wool"
    case synthetics = "Synthetics"
    case latex = "Latex"
    case dyes = "Dyes"
    case none = "None"
}
