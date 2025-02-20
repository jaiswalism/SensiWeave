import Foundation
import CoreData

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
    @NSManaged public var suitableSkinTypes: [String]
    @NSManaged public var suitableTemperatures: [String]
    @NSManaged public var allergyInfo: String
    @NSManaged public var recommendations: NSSet?
}
