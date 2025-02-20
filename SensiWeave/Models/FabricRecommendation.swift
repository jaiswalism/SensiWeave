import Foundation
import CoreData

@objc(FabricRecommendation)
public class FabricRecommendation: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var fabricName: String
    @NSManaged public var desc: String // 'description' is a reserved keyword, so we use 'desc'
    @NSManaged public var date: Date
    @NSManaged public var fabric: Fabric
}

extension FabricRecommendation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FabricRecommendation> {
        return NSFetchRequest<FabricRecommendation>(entityName: "FabricRecommendation")
    }
    
    convenience init(context: NSManagedObjectContext,
                     id: UUID = UUID(),
                     fabricName: String,
                     description: String,
                     date: Date = Date(),
                     fabric: Fabric) {
        let entity = NSEntityDescription.entity(forEntityName: "FabricRecommendation", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.fabricName = fabricName
        self.desc = description
        self.date = date
        self.fabric = fabric
    }
}

@objc(Fabric)
public class Fabric: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var properties: [String]
    @NSManaged public var careInstructions: String
    @NSManaged public var imageName: String
    @NSManaged public var origin: String
    @NSManaged public var uses: [String]
    @NSManaged public var sustainabilityInfo: String
}

extension Fabric {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fabric> {
        return NSFetchRequest<Fabric>(entityName: "Fabric")
    }
    
    convenience init(context: NSManagedObjectContext,
                     id: UUID = UUID(),
                     name: String,
                     properties: [String],
                     careInstructions: String,
                     imageName: String,
                     origin: String,
                     uses: [String],
                     sustainabilityInfo: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Fabric", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
        self.properties = properties
        self.careInstructions = careInstructions
        self.imageName = imageName
        self.origin = origin
        self.uses = uses
        self.sustainabilityInfo = sustainabilityInfo
    }
}
