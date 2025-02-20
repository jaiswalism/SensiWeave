struct RecommendationView: View {
    @StateObject private var viewModel: RecommendationViewModel
    
    init(userPreference: UserPreference) {
        _viewModel = StateObject(wrappedValue: RecommendationViewModel(userPreference: userPreference))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Textile Matches")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ForEach(viewModel.recommendations) { recommendation in
                    FabricRecommendationCard(recommendation: recommendation)
                }
                
                Button("Start Over") {
                    viewModel.startOver = true
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Recommendations")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .background(
            NavigationLink(
                destination: QuestionnaireView(),
                isActive: $viewModel.startOver,
                label: { EmptyView() }
            )
        )
    }
}

struct FabricRecommendationCard: View {
    let recommendation: FabricRecommendation
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recommendation.fabricName)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(recommendation.description)
                .font(.body)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Properties:")
                    .font(.headline)
                ForEach(recommendation.fabric.properties, id: \.self) { property in
                    Text("• \(property)")
                }
                
                Text("Care Instructions:")
                    .font(.headline)
                    .padding(.top, 5)
                Text(recommendation.fabric.careInstructions)
            }
            .padding(.vertical)
            
            Button(action: {
                isFavorite.toggle()
                // Implement save to favorites logic here
            }) {
                Label(
                    isFavorite ? "Remove from Favorites" : "Save to Favorites",
                    systemImage: isFavorite ? "star.fill" : "star"
                )
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
