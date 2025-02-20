import SwiftUI
import CoreData
import Combine

class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [FabricRecommendation] = []
    @Published var startOver = false
    @Published var alertItem: AlertItem?
    @Published var showFabricDetails = false
    
    private let userPreference: UserPreference
    private var viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(userPreference: UserPreference, context: NSManagedObjectContext) {
        self.userPreference = userPreference
        self.viewContext = context
        generateRecommendations()
    }
    
    private func generateRecommendations() {
        let fetchRequest: NSFetchRequest<Fabric> = Fabric.fetchRequest()
        
        do {
            let allFabrics = try viewContext.fetch(fetchRequest)
            
            recommendations = allFabrics.compactMap { fabric in
                let score = calculateFabricScore(fabric)
                if score > 0 {
                    let newRecommendation = FabricRecommendation(context: self.viewContext)
                    newRecommendation.id = UUID()
                    newRecommendation.fabricName = fabric.name
                    newRecommendation.descriptionText = generateDescription(for: fabric, score: score)
                    newRecommendation.date = Date()
                    newRecommendation.fabric = fabric
                    return newRecommendation
                }
                return nil
            }
            
            recommendations.sort { (rec1, rec2) -> Bool in
                let score1 = calculateFabricScore(rec1.fabric)
                let score2 = calculateFabricScore(rec2.fabric)
                return score1 > score2
            }
            
            if recommendations.isEmpty {
                alertItem = AlertItem(
                    title: "No Recommendations",
                    message: "We couldn't find any fabrics matching your preferences. Try adjusting your criteria."
                )
            }
        } catch {
            print("Failed to fetch fabrics: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to generate recommendations.")
        }
    }
    
    private func calculateFabricScore(_ fabric: Fabric) -> Double {
        var score: Double = 0
        
        if let suitableTemperatures = fabric.suitableTemperatures as? [String] {
            if userPreference.temperature > 25 && suitableTemperatures.contains("Hot") {
                score += 2
            } else if userPreference.temperature <= 25 && suitableTemperatures.contains("Cold") {
                score += 2
            }
        }
        
        if let userAllergies = userPreference.allergies as? Set<Allergy> {
            if !userAllergies.contains(where: { fabric.allergyInfo.lowercased().contains($0.rawValue.lowercased()) }) {
                score += 3
            }
        }
        
        if let suitableSkinTypes = fabric.suitableSkinTypes as? [String] {
            if suitableSkinTypes.contains(userPreference.skinType?.rawValue ?? "") {
                score += 2
            }
        }
        
        return score
    }
    
    private func generateDescription(for fabric: Fabric, score: Double) -> String {
        var description = "This \(fabric.name) fabric "
        
        if score > 5 {
            description += "is an excellent match for your preferences! "
        } else if score > 3 {
            description += "is a good choice based on your preferences. "
        } else {
            description += "could be suitable for you. "
        }
        
        if let suitableTemperatures = fabric.suitableTemperatures as? [String] {
            if suitableTemperatures.contains("Hot") {
                description += "It's suitable for hot weather, "
            }
            if suitableTemperatures.contains("Cold") {
                description += "it's good for cold weather, "
            }
        }
        
        description += "and it's suitable for your skin type and sensitivities."
        
        return description
    }
    
    func saveToFavorites(_ recommendation: FabricRecommendation) {
        do {
            try viewContext.save()
            alertItem = AlertItem(
                title: "Saved to Favorites",
                message: "\(recommendation.fabricName ?? "") has been added to your favorites."
            )
        } catch {
            print("Failed to save favorite: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to save to favorites.")
        }
    }
}
