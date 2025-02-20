import SwiftUI
import CoreData

class CustomProfilesViewModel: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var alertItem: AlertItem?
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchProfiles()
    }
    
    func fetchProfiles() {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Profile.name, ascending: true)]
        
        do {
            profiles = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch profiles: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to load profiles.")
        }
    }
    
    func addProfile(name: String, skinType: SkinType, allergies: Set<Allergy>, extraNotes: String) {
        let newProfile = Profile(context: viewContext)
        newProfile.id = UUID()
        newProfile.name = name
        newProfile.skinType = skinType.rawValue
        newProfile.allergies = allergies.map { $0.rawValue }
        newProfile.extraNotes = extraNotes
        
        saveContext()
    }
    
    func updateProfile(_ profile: Profile, name: String, skinType: SkinType, allergies: Set<Allergy>, extraNotes: String) {
        profile.name = name
        profile.skinType = skinType.rawValue
        profile.allergies = allergies.map { $0.rawValue }
        profile.extraNotes = extraNotes
        
        saveContext()
    }
    
    func deleteProfile(_ profile: Profile) {
        viewContext.delete(profile)
        saveContext()
    }
    
    func deleteProfile(at offsets: IndexSet) {
        offsets.map { profiles[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchProfiles()
        } catch {
            print("Error saving context: \(error)")
            alertItem = AlertItem(title: "Error", message: "Failed to save changes.")
        }
    }
}
