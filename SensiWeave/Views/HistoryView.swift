import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recommendations) { recommendation in
                    VStack(alignment: .leading) {
                        Text(recommendation.fabricName)
                            .font(.headline)
                        Text(recommendation.date, style: .date)
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: viewModel.deleteRecommendation)
            }
            .navigationTitle("Recommendation History")
            .toolbar {
                EditButton()
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
