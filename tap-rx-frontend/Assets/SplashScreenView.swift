//
//  SpashScreenView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/19/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var isBouncing = false
    var body: some View {
        ZStack {
            if(self.isActive){
                LoginView()
            } else {
                HStack{
                    Image(systemName: "pencil.and.list.clipboard").foregroundColor(Color.medicalRed)
                    Text("TapRx").foregroundColor(Color.medicalDarkBlue)
                }
                .font(.title2)
                .bold()
                .scaleEffect(2)
                .offset(y: isBouncing ? 0 : -10) // Move up by 50 points
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.0)
                        .delay(0.5)
                        .repeatForever(autoreverses: true)){
                            isBouncing.toggle()
                        }
                    
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
