//
//  ForgotPasswordView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var username: String = ""
    
    func forgotPassword(){
        print("Forgot Password Button Clicked")
        return
    }
    
    var body: some View {
        NavigationView{
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
                        
                        Text("Enter your email, phone, or username and we'll send you a link to change your password")
                            .font(.subheadline)
                            .foregroundColor(Color.medicalLightBlue)
                            .padding(.bottom,30)
                            .fontWeight(.semibold)
                        
                    }.padding(.top, 80)
                    
                    //Username Field
                    TextField("", text: $username,prompt: Text("Username, Email, or Phone Number")
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
                    ZStack{
                        Button(action: forgotPassword){
                            Text(" ")
                        }
                        .padding([.top,.bottom],8)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.medicalRed)
                        )
                        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        Text("Reset Password").foregroundColor(.white).zIndex(100.0)
                    }.padding(.top,15)
                    
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
        }
            .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
