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
    
    func callLogIn(){
        print("Button Clicked")
        logIn(username: self.username, password: self.password)
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
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .foregroundColor(Color.medicalDarkBlue)
                            .fontWeight(.black)
                        
                        Text("Please Log In")
                            .font(.title3)
                            .foregroundColor(Color.medicalLightBlue)
                            .fontWeight(.semibold)
                    }.padding([.top,.bottom], 80)
                    
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
                    
                    .padding(.bottom,5)
                    
                    //Password Field
                    SecureField("",text: $password,prompt: Text("Password")
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
                    .padding(.bottom,5)
                    
                    //Remember Me and Forgot Password Links
                    HStack{
                        Text("Remember Me")
                            .font(.subheadline)
                            .foregroundStyle(Color.medicalLightBlue)
                            .fontWeight(.semibold)
                        Spacer()
                        NavigationLink {
                            ForgotPasswordView()
                        } label: {
                            Text("Forgot Password")
                                .font(.subheadline)
                                .foregroundStyle(Color.medicalDarkBlue)
                                .bold()
                                .underline()
                        }
                    }
                    
                    // Button for Log In Action
                    Button(action: callLogIn){
                        Text("Log In")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                    }
                        .padding([.top,.bottom],10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.medicalRed)
                        )
                        .padding(.top,15)
                    
                }
                
                Spacer()
                HStack {
                    Text("Don't have an Account?")
                        .font(.subheadline)
                        .foregroundStyle(Color.medicalLightBlue)
                        .fontWeight(.semibold)
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
        }.navigationBarHidden(true)
            
    }
}

#Preview {
    LoginView()
}
