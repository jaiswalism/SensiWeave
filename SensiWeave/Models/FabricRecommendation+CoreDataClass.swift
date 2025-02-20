import Foundation
import CoreData

@objc(FabricRecommendation)
public class FabricRecommendation: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var descriptionText: String
    @NSManaged public var date: Date
    @NSManaged public var fabric: Fabric
}
