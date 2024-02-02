//
//  RegisterView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var contact: String = ""
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    
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
                    
                    
                    // Email/Phone Field
                    TextField("", text: $contact,prompt: Text("Email or Phone Number")
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
                    )
                    
                    .padding(.bottom,5)
                    
                    //Username Field
                    TextField("", text: $username,prompt: Text("Username")
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
                    
                    HStack{
                        Text("Password must be at least 6 characters, contain a number and capital letter")
                            .font(.subheadline)
                            .foregroundColor(Color.medicalLightBlue)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom,10)
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
                    )
                    .padding(.bottom,5)
                    
                    // Button for Log In Action
                    Button(action: register){
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
                        )
                        .padding(.top,5)
                    
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
        }.navigationBarHidden(true)
    }
}

#Preview {
    RegisterView()
}
