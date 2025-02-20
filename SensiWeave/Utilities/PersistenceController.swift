import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SensiWeave")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    func preloadData() {
        let context = container.viewContext
        
        guard let url = Bundle.main.url(forResource: "fabrics", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            print("Error: Unable to load or parse fabrics.json")
            return
        }
        
        for fabricDict in jsonArray {
            let fabric = Fabric(context: context)
            fabric.name = fabricDict["name"] as? String ?? ""
            fabric.properties = fabricDict["properties"] as? [String] ?? []
            fabric.careInstructions = fabricDict["careInstructions"] as? String ?? ""
            fabric.imageName = fabricDict["imageName"] as? String ?? ""
            fabric.origin = fabricDict["origin"] as? String ?? ""
            fabric.uses = fabricDict["uses"] as? [String] ?? []
            fabric.sustainabilityInfo = fabricDict["sustainabilityInfo"] as? String ?? ""
            fabric.suitableSkinTypes = fabricDict["suitableSkinTypes"] as? [String] ?? []
            fabric.suitableTemperatures = fabricDict["suitableTemperatures"] as? [String] ?? []
            fabric.allergyInfo = fabricDict["allergyInfo"] as? String ?? ""
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving preloaded data: \(error)")
        }
    }
}
