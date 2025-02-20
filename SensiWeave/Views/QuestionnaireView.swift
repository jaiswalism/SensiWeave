struct QuestionnaireView: View {
    enum Mode {
        case normal
        case newProfile
    }
    
    @StateObject private var viewModel = QuestionnaireViewModel()
    let mode: Mode
    var onProfileCreated: ((UserPreference) -> Void)?
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .skinType:
                skinTypeView
            case .allergies:
                allergiesView
            case .climate:
                climateView
            case .finalTouches:
                finalTouchesView
            }
            
            navigationButtons
        }
        .navigationTitle(viewModel.currentStep.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if mode == .newProfile && viewModel.isLastStep {
                    Button("Save Profile") {
                        onProfileCreated?(viewModel.userPreference)
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    private var skinTypeView: some View {
        VStack {
            Text("How would you describe your skin? Pick the texture that feels like you.")
                .padding()
            
            ForEach(SkinType.allCases, id: \.self) { type in
                Button(action: { viewModel.skinType = type }) {
                    Text(type.rawValue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.skinType == type ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(viewModel.skinType == type ? .white : .primary)
                        .cornerRadius(10)
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    private var allergiesView: some View {
        VStack {
            Text("Select the fabric sensitivities that need extra care:")
                .padding()
            
            ForEach(Allergy.allCases, id: \.self) { allergy in
                Toggle(allergy.rawValue, isOn: Binding(
                    get: { viewModel.allergies.contains(allergy) },
                    set: { viewModel.toggleAllergy(allergy, isOn: $0) }
                ))
                .padding()
            }
        }
    }
    
    private var climateView: some View {
        VStack {
            Text("Tell us about your surroundings. What's your current temperature?")
                .padding()
            
            Slider(value: $viewModel.temperature, in: -10...50, step: 1)
                .padding()
            
            Text("\(Int(viewModel.temperature))°C")
                .font(.title)
        }
    }
    
    private var finalTouchesView: some View {
        VStack {
            Text("Any extra details to share? Let your style preferences shine.")
                .padding()
            
            TextEditor(text: $viewModel.extraNotes)
                .frame(height: 150)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if viewModel.canGoBack {
                Button("Back") {
                    viewModel.goToPreviousStep()
                }
            }
            Spacer()
            Button(viewModel.isLastStep ? (mode == .normal ? "Review" : "Save Profile") : "Continue") {
                if viewModel.isLastStep {
                    if mode == .normal {
                        viewModel.navigateToReview = true
                    } else {
                        onProfileCreated?(viewModel.userPreference)
                    }
                } else {
                    viewModel.goToNextStep()
                }
            }
            .disabled(viewModel.isLastStep && !viewModel.isValid)
        }
        .padding()
        .background(
            Group {
                if mode == .normal {
                    NavigationLink(
                        destination: ReviewView(userPreference: viewModel.userPreference),
                        isActive: $viewModel.navigateToReview,
                        label: { EmptyView() }
                    )
                }
            }
        )
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QuestionnaireView(mode: .normal, onProfileCreated: nil)
        }
        NavigationView {
            QuestionnaireView(mode: .newProfile, onProfileCreated: { _ in })
        }
    }
}