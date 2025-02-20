import Foundation
import CoreData

extension Fabric {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fabric> {
        return NSFetchRequest<Fabric>(entityName: "Fabric")
    }
}
