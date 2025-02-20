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
    
    func deleteRecommendation(_ recommendation: FabricRecommendation) {
        viewContext.delete(recommendation)
        saveContext()
    }
    
    func deleteRecommendations(at offsets: IndexSet) {
        offsets.map { recommendations[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func clearHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FabricRecommendation.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let changes: [AnyHashable: Any] = [
                NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []
            ]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [viewContext])
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
