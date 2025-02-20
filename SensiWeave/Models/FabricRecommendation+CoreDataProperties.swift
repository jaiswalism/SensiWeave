import Foundation
import CoreData

extension FabricRecommendation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FabricRecommendation> {
        return NSFetchRequest<FabricRecommendation>(entityName: "FabricRecommendation")
    }
}
