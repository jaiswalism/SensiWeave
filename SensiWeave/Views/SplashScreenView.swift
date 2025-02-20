////
////  SplashScreenView.swift
////  SensiWeave
////
////  Created by user on 10/02/25.
////
//
//import SwiftUI
//
//struct SplashScreenView: View {
//    @State private var isActive : Bool = false
//    @State private var scale : CGFloat = 0.8
//    @State private var opacity : Double = 0.5
//    
//    var body: some View {
//        ZStack{
//            Color.darkBlue.ignoresSafeArea()
//            
//            if isActive {
//                OnboardingView()
//            } else {
//                VStack{
//                    Image("SensiWeave")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 300)
//                }
//            }
//        }
//        .onAppear{
//            withAnimation(.easeIn(duration: 1.2)){
//                self.scale = 1.0
//                self.opacity = 1.0
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
//                withAnimation{
//                    self.isActive = true
//                }
//            }
//        }
//    }
//}
//
//struct SplashScreenView_Previews: PreviewProvider {
//    static var previews: some View{
//        SplashScreenView()
//    }
//}

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            Color.darkBlue.ignoresSafeArea()
            
            VStack {
                Image("SensiWeave")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.scale = 1.0
                self.opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = false
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(isActive: .constant(true))
    }
}
