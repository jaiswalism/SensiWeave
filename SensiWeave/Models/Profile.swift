import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var skinType: String
    @NSManaged public var allergies: [String]
    @NSManaged public var extraNotes: String
}

extension Profile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }
    
    convenience init(context: NSManagedObjectContext,
                     id: UUID = UUID(),
                     name: String,
                     skinType: SkinType,
                     allergies: Set<Allergy>,
                     extraNotes: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.name = name
        self.skinType = skinType.rawValue
        self.allergies = allergies.map { $0.rawValue }
        self.extraNotes = extraNotes
    }
    
    var allergiesDescription: String {
        allergies.isEmpty ? "None" : allergies.joined(separator: ", ")
    }
}

enum SkinType: String, Codable, CaseIterable {
    case oily = "Oily"
    case dry = "Dry"
    case combination = "Combination"
    case sensitive = "Sensitive"
    case normal = "Normal"
}

enum Allergy: String, Codable, CaseIterable {
    case wool = "Wool"
    case synthetics = "Synthetics"
    case latex = "Latex"
    case dyes = "Dyes"
    case none = "None"
}
