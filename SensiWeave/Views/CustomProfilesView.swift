import SwiftUI

struct CustomProfilesView: View {
    @StateObject private var viewModel = CustomProfilesViewModel()
    @State private var showingAddProfile = false
    
    var body: some View {
        List {
            ForEach(viewModel.profiles) { profile in
                NavigationLink(destination: ProfileDetailView(profile: profile)) {
                    Text(profile.name)
                }
            }
            .onDelete(perform: viewModel.deleteProfile)
            
            Button("Add Profile") {
                showingAddProfile = true
            }
        }
        .navigationTitle("Custom Profiles")
        .toolbar {
            EditButton()
        }
        .sheet(isPresented: $showingAddProfile) {
            NavigationView {
                QuestionnaireView(mode: .newProfile) { userPreference in
                    viewModel.addProfile(from: userPreference)
                    showingAddProfile = false
                }
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ProfileDetailView: View {
    let profile: Profile
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(profile.name)
            }
            Section(header: Text("Skin Type")) {
                Text(profile.skinType.rawValue)
            }
            Section(header: Text("Allergies")) {
                ForEach(profile.allergies, id: \.self) { allergy in
                    Text(allergy.rawValue)
                }
            }
            if !profile.extraNotes.isEmpty {
                Section(header: Text("Extra Notes")) {
                    Text(profile.extraNotes)
                }
            }
        }
        .navigationTitle(profile.name)
    }
}

struct CustomProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomProfilesView()
        }
    }
}
