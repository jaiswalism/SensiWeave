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
                    return FabricRecommendation(
                        id: UUID(),
                        fabricName: fabric.name,
                        description: generateDescription(for: fabric, score: score),
                        date: Date(),
                        fabric: fabric
                    )
                }
                return nil
            }.sorted { $0.score > $1.score }
            
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
        
        // Temperature score
        if let suitableTemperatures = fabric.suitableTemperatures as? [String] {
            if userPreference.temperature > 25 && suitableTemperatures.contains("Hot") {
                score += 2
            } else if userPreference.temperature <= 25 && suitableTemperatures.contains("Cold") {
                score += 2
            }
        }
        
        // Allergy score
        if let userAllergies = userPreference.allergies as? [String] {
            if !userAllergies.contains(where: { fabric.allergyInfo.lowercased().contains($0.lowercased()) }) {
                score += 3
            }
        }
        
        // Skin type score
        if let suitableSkinTypes = fabric.suitableSkinTypes as? [String],
           let userSkinType = userPreference.skinType as? String {
            if suitableSkinTypes.contains(userSkinType) {
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
        let newFavorite = FabricRecommendation(context: viewContext)
        newFavorite.id = recommendation.id
        newFavorite.fabricName = recommendation.fabricName
        newFavorite.desc = recommendation.description
        newFavorite.date = recommendation.date
        newFavorite.fabric = recommendation.fabric
        
        do {
            try viewContext.save()
            alertItem = AlertItem(
                title: "Saved to Favorites",
                message: "\(recommendation.fabricName) has been added to your favorites."
            )
        } catch {
            print("Failed to save favorite: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to save to favorites.")
        }
    }
}
