////
////  OnboardingScreen.swift
////  SensiWeave
////
////  Created by user on 10/02/25.
////
//
//import SwiftUI
//
//struct OnboardingScreen: View {
//    let imageName: String
//    let title : String
//    let description : String
//    
//    var body: some View {
//        VStack(spacing : 30){
//            Spacer()
//            
//            Text(title)
//                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                .fontWeight(.semibold)
//                .foregroundColor(.darkBlue)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//            
//            Spacer()
//            
//            Image(imageName)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 250)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//            
//            Spacer()
//            
//            Text(description)
//                .font(.body)
//                .foregroundColor(.darkBlue)
////                .multilineTextAlignment(.center)
//                .padding(.horizontal, 40)
//            
//                Spacer()
//                Spacer()
//        }
//        .background(Color.offWhite.ignoresSafeArea())
//    }
//}
