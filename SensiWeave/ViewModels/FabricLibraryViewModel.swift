import SwiftUI
import CoreData

class FabricLibraryViewModel: ObservableObject {
    @Published var fabrics: [Fabric] = []
    @Published var searchText: String = ""
    
    private var viewContext: NSManagedObjectContext
    
    var filteredFabrics: [Fabric] {
        if searchText.isEmpty {
            return fabrics
        } else {
            return fabrics.filter { fabric in
                fabric.name.lowercased().contains(searchText.lowercased()) ||
                (fabric.properties as? [String])?.contains(where: { $0.lowercased().contains(searchText.lowercased()) }) ?? false
            }
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        loadFabrics()
    }
    
    private func loadFabrics() {
        let fetchRequest: NSFetchRequest<Fabric> = Fabric.fetchRequest()
        
        do {
            fabrics = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch fabrics: \(error)")
        }
    }
    
    func addFabric(name: String, properties: [String], careInstructions: String, imageName: String, origin: String, uses: [String], sustainabilityInfo: String) {
        let newFabric = Fabric(context: viewContext)
        newFabric.name = name
        newFabric.properties = properties as NSObject
        newFabric.careInstructions = careInstructions
        newFabric.imageName = imageName
        newFabric.origin = origin
        newFabric.uses = uses as NSObject
        newFabric.sustainabilityInfo = sustainabilityInfo
        
        saveContext()
    }
    
    func deleteFabric(_ fabric: Fabric) {
        viewContext.delete(fabric)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            loadFabrics()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
