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
                        .foregroundStyle(Color(red: 35/255, green: 64/255, blue: 142/255))
                        .bold()
                    
                    Text("Please Log In")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 56/255, green: 83/255, blue: 153/255))
                }.padding([.top,.bottom], 80)
                
                //Username
                TextField("", text: $username,prompt: Text("Username, Email, or Phone Number").foregroundColor(Color(red: 56/255, green: 83/255, blue: 153/255)))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color(red: 35/255, green: 64/255, blue: 142/255), lineWidth: 2)
                    )
                    
                    .padding(.bottom,5)
                
                //Password
                SecureField("",text: $password,prompt: Text("Password").foregroundColor(Color(red: 56/255, green: 83/255, blue: 153/255)))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color(red: 35/255, green: 64/255, blue: 142/255), lineWidth: 2)
                    )
                    .padding(.bottom,5)
                
                HStack{
                    Text("Remember Me")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 56/255, green: 83/255, blue: 153/255))
                    Spacer()
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 56/255, green: 83/255, blue: 153/255))
                }
                
                ZStack{
                    Button(action: logIn){
                        Text(" ")
                    }
                    .padding([.top,.bottom],8)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 237/255, green: 27/255, blue:36/255))
                    )
                        .zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                    Text("Log In").foregroundColor(.white).zIndex(100.0)
                }.padding(.top,15)
                    
            }
            
            Spacer()
            HStack {
                Text("Don't have an Account?")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 56/255, green: 83/255, blue: 153/255))
                Text("Sign Up")
                    .font(.subheadline)
                    .underline()
                    .foregroundStyle(Color(red: 35/255, green: 64/255, blue: 142/255))
                    .bold()
                
                
                    
            }
        }
        .padding([.leading,.trailing],25)
    }
}

#Preview {
    LoginView()
}
