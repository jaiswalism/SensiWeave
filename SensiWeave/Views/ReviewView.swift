import SwiftUI

struct ReviewView: View {
    let userPreference: UserPreference
    @State private var navigateToRecommendation = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Fabric Story")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    InfoRow(title: "Skin Type", value: userPreference.skinType.rawValue)
                    InfoRow(title: "Allergies", value: userPreference.allergiesDescription)
                    InfoRow(title: "Temperature", value: "\(Int(userPreference.temperature))°C")
                    InfoRow(title: "Extra Notes", value: userPreference.extraNotes.isEmpty ? "None" : userPreference.extraNotes)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                HStack {
                    Button("Edit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                    Button("Reveal My Fabric") {
                        navigateToRecommendation = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: RecommendationView(userPreference: userPreference),
                isActive: $navigateToRecommendation,
                label: { EmptyView() }
            )
        )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.body)
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReviewView(userPreference: UserPreference(
                skinType: .normal,
                allergies: [.wool, .latex],
                temperature: 25,
                extraNotes: "I prefer breathable fabrics."
            ))
        }
    }
}
