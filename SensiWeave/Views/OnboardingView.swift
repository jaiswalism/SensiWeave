//
//  OnboardingView.swift
//  SensiWeave
//
//  Created by user on 10/02/25.
//

//import SwiftUI
//
//struct OnboardingView: View {
//    @State private var currentPage = 0
//    
//    var body: some View {
//        ZStack{
//            Color.offWhite.ignoresSafeArea()
//            
//            TabView(selection: $currentPage){
//                OnboardingScreen(
//                    imageName: "Story",
//                    title: "Discover Your Story",
//                    description: """
//                    Every skin has a tale.
//                    Let’s uncover the fabric that speaks to you.
//                    """
//                ).tag(0)
//                
//                OnboardingScreen(
//                    imageName: "Uncover",
//                    title: "Uncover Your Touch",
//                    description: "From the softness of cotton to the cool calm of linen—"+"find the texture that feels just right."
//                ).tag(1)
//                
//                OnboardingScreen(
//                    imageName: "Embrace",
//                    title: "Embrace Your Comfort",
//                    description: "Ready to transform how you feel? Begin your journey to effortless style."
//                ).tag(02)
//                
//            }
//            .tabViewStyle(PageTabViewStyle())
//            
//            VStack{
//                Spacer()
//                if currentPage == 2 {
//                    Button(action: {
//                        
//                    }){
//                        Text("Get Started")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//                            .background(Color.darkBlue)
//                            .cornerRadius(15)
//                            .padding(.horizontal)
//                    }
//                    .transition(.opacity)
//                    .padding(.bottom, 40)
//                }else{
//                    Button(action: {
//                        
//                    }){
//                        Image("arrow")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 25)
////                            .clipShape(RoundedRectangle(cornerRadius: 50))
////                            .cornerRadius(25)
//                            .padding(25)
//                            .frame(maxWidth: 75)
//                            .background(Color.darkBlue)
//                    }.padding(.bottom,40)
//                }
//            }
//        }
//    }
//}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View{
//        OnboardingView()
//    }
//}


import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.offWhite.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingScreen(
                    imageName: "Story",
                    title: "Discover Your Story",
                    description: "Every skin has a tale. Let's uncover the fabric that speaks to you."
                ).tag(0)
                
                OnboardingScreen(
                    imageName: "Uncover",
                    title: "Uncover Your Touch",
                    description: "From the softness of cotton to the cool calm of linen—find the texture that feels just right."
                ).tag(1)
                
                OnboardingScreen(
                    imageName: "Embrace",
                    title: "Embrace Your Comfort",
                    description: "Ready to transform how you feel? Begin your journey to effortless style."
                ).tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            
            VStack {
                Spacer()
                if currentPage == 2 {
                    Button(action: {
                        hasCompletedOnboarding = true
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.darkBlue)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    .transition(.opacity)
                    .padding(.bottom, 40)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Image("arrow")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                            .padding(25)
                            .frame(maxWidth: 75)
                            .background(Color.darkBlue)
                            .cornerRadius(37.5)  // Half of 75 to make it circular
                    }.padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingScreen: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.darkBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            Text(description)
                .font(.body)
                .foregroundColor(.darkBlue)
                .padding(.horizontal, 40)
            
            Spacer()
            Spacer()
        }
        .background(Color.offWhite.ignoresSafeArea())
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
    }
}
