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
    
    func addProfile(name: String, skinType: String, allergies: [String], extraNotes: String) {
        let newProfile = Profile(context: viewContext)
        newProfile.id = UUID()
        newProfile.name = name
        newProfile.skinType = skinType
        newProfile.allergies = allergies as NSObject
        newProfile.extraNotes = extraNotes
        
        saveContext()
    }
    
    func updateProfile(_ profile: Profile, name: String, skinType: String, allergies: [String], extraNotes: String) {
        profile.name = name
        profile.skinType = skinType
        profile.allergies = allergies as NSObject
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

