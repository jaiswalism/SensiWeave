import SwiftUI
import CoreData
import Combine

class QuestionnaireViewModel: ObservableObject {
    @Published var skinType: String = ""
    @Published var allergies: Set<String> = []
    @Published var temperature: Double = 20.0
    @Published var extraNotes: String = ""
    @Published var currentStep: QuestionnaireStep = .skinType
    @Published var navigateToReview = false
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadProgress()
    }
    
    var canGoBack: Bool {
        currentStep != .skinType
    }
    
    var isLastStep: Bool {
        currentStep == .finalTouches
    }
    
    var isValid: Bool {
        !skinType.isEmpty && !allergies.isEmpty
    }
    
    var skinTypeEnum: SkinType? {
        get { return SkinType(rawValue: skinType) }
        set { skinType = newValue?.rawValue ?? "" }
    }

    var allergiesEnum: Set<Allergy> {
        get { return Set(allergies.compactMap { Allergy(rawValue: $0) }) }
        set { allergies = Set(newValue.map { $0.rawValue }) }
    }
    
    func saveUserPreference() {
        let newPreference = UserPreference(context: viewContext)
        newPreference.id = UUID()
        newPreference.skinType = SkinType(rawValue: skinType) ?? .normal
        newPreference.allergies = Set(allergies.compactMap { Allergy(rawValue: $0) })
        newPreference.temperature = temperature
        newPreference.extraNotes = extraNotes
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save user preference: \(error)")
        }
    }

    
    func goToNextStep() {
        switch currentStep {
        case .skinType:
            currentStep = .allergies
        case .allergies:
            currentStep = .climate
        case .climate:
            currentStep = .finalTouches
        case .finalTouches:
            navigateToReview = true
        }
        saveProgress()
    }
    
    func goToPreviousStep() {
        switch currentStep {
        case .skinType:
            break
        case .allergies:
            currentStep = .skinType
        case .climate:
            currentStep = .allergies
        case .finalTouches:
            currentStep = .climate
        }
        saveProgress()
    }
    
    func toggleAllergy(_ allergy: String) {
        if allergies.contains(allergy) {
            allergies.remove(allergy)
        } else {
            allergies.insert(allergy)
        }
        saveProgress()
    }
    
    private func saveProgress() {
        let progress = QuestionnaireProgress(
            currentStep: currentStep,
            skinType: skinType,
            allergies: allergies,
            temperature: temperature,
            extraNotes: extraNotes
        )
        do {
            let data = try JSONEncoder().encode(progress)
            UserDefaults.standard.set(data, forKey: "questionnaireProgress")
        } catch {
            print("Failed to save progress: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: "questionnaireProgress"),
              let progress = try? JSONDecoder().decode(QuestionnaireProgress.self, from: data) else {
            return
        }
        currentStep = progress.currentStep
        skinType = progress.skinType
        allergies = progress.allergies
        temperature = progress.temperature
        extraNotes = progress.extraNotes
    }
    
    func clearProgress() {
        UserDefaults.standard.removeObject(forKey: "questionnaireProgress")
        currentStep = .skinType
        skinType = ""
        allergies.removeAll()
        temperature = 20.0
        extraNotes = ""
    }
}

enum QuestionnaireStep: Codable {
    case skinType, allergies, climate, finalTouches
    
    var title: String {
        switch self {
        case .skinType:
            return "Your Skin, Your Story"
        case .allergies:
            return "Allergy Alchemy"
        case .climate:
            return "Your Climate, Your Fabric"
        case .finalTouches:
            return "Final Touches"
        }
    }
}

struct QuestionnaireProgress: Codable {
    let currentStep: QuestionnaireStep
    let skinType: String
    let allergies: Set<String>
    let temperature: Double
    let extraNotes: String
}
