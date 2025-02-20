import SwiftUI
import CoreData

class SettingsViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    
    private var viewContext: NSManagedObjectContext
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func clearHistory() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FabricRecommendation.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
            alertItem = AlertItem(title: "Success", message: "History cleared successfully.")
        } catch {
            print("Failed to clear history: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to clear history.")
        }
    }
    
    func resetPreferences() {
        // Clear UserDefaults
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        // Clear Core Data UserPreference entities
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserPreference.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(batchDeleteRequest)
            try viewContext.save()
            alertItem = AlertItem(title: "Success", message: "Preferences reset successfully.")
        } catch {
            print("Failed to reset preferences: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to reset preferences.")
        }
    }
}
