import SwiftUI

struct FabricLibraryView: View {
    @StateObject private var viewModel = FabricLibraryViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.filteredFabrics) { fabric in
                NavigationLink(destination: FabricDetailView(fabric: fabric)) {
                    Text(fabric.name)
                }
            }
        }
        .navigationTitle("Fabric Encyclopedia")
        .searchable(text: $viewModel.searchText, prompt: "Search fabrics")
    }
}

struct FabricDetailView: View {
    let fabric: Fabric
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(fabric.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Image placeholder
                // Image(fabric.imageName)
                //     .resizable()
                //     .scaledToFit()
                //     .frame(height: 200)
                //     .cornerRadius(10)
                
                Group {
                    Text("Properties:")
                        .font(.headline)
                    ForEach(fabric.properties, id: \.self) { property in
                        Text("• \(property)")
                    }
                }
                
                Group {
                    Text("Care Instructions:")
                        .font(.headline)
                    Text(fabric.careInstructions)
                }
                
                if !fabric.allergyInfo.isEmpty {
                    Group {
                        Text("Allergy Information:")
                            .font(.headline)
                        Text(fabric.allergyInfo)
                    }
                }
                
                if !fabric.sustainabilityInfo.isEmpty {
                    Group {
                        Text("Sustainability:")
                            .font(.headline)
                        Text(fabric.sustainabilityInfo)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(fabric.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FabricLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FabricLibraryView()
        }
    }
}
