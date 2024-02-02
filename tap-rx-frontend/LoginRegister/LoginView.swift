//
//  LoginView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    func logIn(){
        print("Log In Button Clicked")
        return
    }
    
    var body: some View {
        VStack{
            HStack{
                LogoView()
                Spacer()
            }
            
            
            VStack{
                //Welcome Message
                
                VStack {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .foregroundColor(Color.medicalDarkBlue)
                        .bold()
                    
                    Text("Please Log In")
                        .font(.subheadline)
                        .foregroundColor(Color.medicalLightBlue)
                }.padding([.top,.bottom], 80)
                
                //Username Field
                TextField("", text: $username,prompt: Text("Username, Email, or Phone Number").foregroundColor(Color.medicalLightBlue))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.medicalDarkBlue, lineWidth: 2)
                    )
                    
                    .padding(.bottom,5)
                
                //Password Field
                SecureField("",text: $password,prompt: Text("Password").foregroundColor(Color.medicalLightBlue))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.medicalDarkBlue, lineWidth: 2)
                    )
                    .padding(.bottom,5)
                
                //Remember Me and Forgot Password Links
                HStack{
                    Text("Remember Me")
                        .font(.subheadline)
                        .foregroundStyle(Color.medicalLightBlue)
                    Spacer()
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundStyle(Color.medicalLightBlue)
                }
                
                // Button for Log In Action
                ZStack{
                    Button(action: logIn){
                        Text(" ")
                    }
                    .padding([.top,.bottom],8)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                            .fill(Color.medicalRed)
                    )
                        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    Text("Log In").foregroundColor(.white).zIndex(100.0)
                }.padding(.top,15)
                    
            }
            
            Spacer()
            HStack {
                Text("Don't have an Account?")
                    .font(.subheadline)
                    .foregroundStyle(Color.medicalLightBlue)
                Text("Sign Up")
                    .font(.subheadline)
                    .underline()
                    .foregroundStyle(Color.medicalDarkBlue)
                    .bold()
                
                
                    
            }
        }
        .padding([.leading,.trailing],25)
    }
}

#Preview {
    LoginView()
}
