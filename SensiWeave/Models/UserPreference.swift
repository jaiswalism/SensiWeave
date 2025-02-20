import Foundation
import CoreData

@objc(UserPreference)
public class UserPreference: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var skinTypeRawValue: String
    @NSManaged public var allergiesRawValues: [String]
    @NSManaged public var temperature: Double
    @NSManaged public var extraNotes: String
    
    var skinType: SkinType {
        get { return SkinType(rawValue: skinTypeRawValue) ?? .normal }
        set { skinTypeRawValue = newValue.rawValue }
    }
    
    var allergies: Set<Allergy> {
        get { return Set(allergiesRawValues.compactMap { Allergy(rawValue: $0) }) }
        set { allergiesRawValues = Array(newValue.map { $0.rawValue }) }
    }
    
    var allergiesDescription: String {
        allergies.isEmpty ? "None" : allergies.map { $0.rawValue }.joined(separator: ", ")
    }
}

extension UserPreference {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPreference> {
        return NSFetchRequest<UserPreference>(entityName: "UserPreference")
    }
    
    convenience init(context: NSManagedObjectContext, id: UUID = UUID(), skinType: SkinType, allergies: Set<Allergy>, temperature: Double, extraNotes: String) {
        let entity = NSEntityDescription.entity(forEntityName: "UserPreference", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.skinType = skinType
        self.allergies = allergies
        self.temperature = temperature
        self.extraNotes = extraNotes
    }
}
