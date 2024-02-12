//
//  RegisterView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    
    func callRegister(){
        print("Button Clicked")
        register(email: self.email, phone: self.phone, name: self.name, password: self.password, confirm: self.confirm)
    }
    
    func callAppleSignIn(){
        print("Apple Sign In")
    }
    
    func callGoogleSignIn(){
        print("Google Sign In")
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
                        Text("Welcome!")
                            .font(.largeTitle)
                            .foregroundColor(Color.medicalDarkBlue)
                            .fontWeight(.black)
                        
                        Text("Please register below.")
                            .font(.title3)
                            .foregroundColor(Color.medicalLightBlue)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 80)
                    .padding(.bottom,40)
                    
                    
                    // Email Field
                    TextField("", text: $email, prompt: Text("Email Address")
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
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    
                    .padding(.bottom,5)
                    
                    // Phone Field
                    TextField("", text: $phone,prompt: Text("Phone Number")
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
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    
                    .padding(.bottom,5)
                    
                    //Full Name Field
                    TextField("", text: $name,prompt: Text("Full Name")
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
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
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
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.bottom,5)
                    
                    // Confirm Password Field
                    SecureField("",text: $confirm, prompt: Text("Confirm Password")
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
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.bottom,5)
                    
                    HStack{
                        Text("Password must be at least 6 characters, contain a number and capital letter")
                            .font(.subheadline)
                            .foregroundColor(Color.medicalLightBlue)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom,10)
                    
                    // Button for Log In Action
                    Button(action: callRegister){
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                    }
                        .padding([.top,.bottom],10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.medicalRed)
                                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                        )
                        .padding(.top,5)
                    
                    VStack {
                        Button(action: callAppleSignIn){
                            HStack{
                                Image(systemName: "apple.logo")
                                    .offset(x: -3)
                                Text("Sign up with Apple")
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                
                            }
                            
                        }
                            .padding([.top,.bottom],10)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            )
                            .padding(.top,5)
                        
                        Button(action: callGoogleSignIn){
                            HStack{
                                Image("google.logo")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .offset(x:2)
                                Text("Sign up with Google")
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            
                        }
                            .padding([.top,.bottom],7)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 1)
                            )
                            .padding(.top,5)
                    }
                    
                }
                
                Spacer()
                HStack {
                    Text("Have an Account?")
                        .font(.subheadline)
                        .foregroundStyle(Color.medicalLightBlue)
                        .fontWeight(.semibold)
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Log In")
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
    RegisterView()
}
