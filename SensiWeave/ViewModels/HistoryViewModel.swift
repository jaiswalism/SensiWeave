import SwiftUI
import CoreData

class HistoryViewModel: ObservableObject {
    @Published var recommendations: [FabricRecommendation] = []
    @Published var alertItem: AlertItem?
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchRecommendations()
    }
    
    func fetchRecommendations() {
        let fetchRequest: NSFetchRequest<FabricRecommendation> = FabricRecommendation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \FabricRecommendation.date, ascending: false)]
        
        do {
            recommendations = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recommendations: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to load recommendation history.")
        }
    }
    
    func deleteRecommendation(at offsets: IndexSet) {
        for index in offsets {
            let recommendation = recommendations[index]
            viewContext.delete(recommendation)
        }
        
        saveContext()
    }
    
    func clearHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FabricRecommendation.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            recommendations.removeAll()
            alertItem = AlertItem(title: "Success", message: "History cleared successfully.")
        } catch {
            print("Failed to clear history: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to clear history.")
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchRecommendations()
        } catch {
            print("Error saving context: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to save changes.")
        }
    }
}

