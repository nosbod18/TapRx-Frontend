//
//  ForgotPasswordView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var username: String = ""
    
    func callForgotPassword(){
        print("Button Click")
        forgotPassword(username: self.username)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    LogoView()
                    Spacer()
                }
                
                
                VStack{
                    //Welcome Message
                    
                    VStack {
                        Text("Forgot Password?")
                            .font(.largeTitle)
                            .foregroundColor(Color.medicalDarkBlue)
                            .fontWeight(.black)
                        
                        LockIcon()
                            .padding()
                        
                        Text("Enter your email and we'll send you a link to sign in.")
                            .font(.subheadline)
                            .foregroundColor(Color.medicalLightBlue)
                            .padding(.bottom,30)
                            .fontWeight(.semibold)
                        
                    }.padding(.top, 80)
                    
                    //Username Field
                    TextField("", text: $username,prompt: Text("Email")
                        .foregroundColor(Color.medicalLightBlue))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.medicalDarkBlue, lineWidth: 2)
                    )
                    
                    
                    // Button for Log In Action
                    Button(action: callForgotPassword){
                        Text("Send Email Link")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                    }
                        .padding([.top,.bottom],10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.medicalRed)
                        ).padding(.top,10)
                    
                }
                
                Spacer()
                HStack {
                    Text("Don't have an Account?")
                        .font(.subheadline)
                        .foregroundStyle(Color.medicalLightBlue)
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Sign Up")
                            .font(.subheadline)
                            .foregroundStyle(Color.medicalDarkBlue)
                            .bold()
                            .underline()
                    }
                }
            }
            .padding([.leading,.trailing],25)
            .padding(.bottom,10)
        }
            .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
