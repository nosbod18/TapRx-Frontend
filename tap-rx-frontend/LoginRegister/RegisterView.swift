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
                    Text("Sign Up").foregroundColor(.white).zIndex(100.0)
                }.padding(.top,5)
                    
            }
            
            Spacer()
            HStack {
                Text("Have an Account?")
                    .font(.subheadline)
                    .foregroundStyle(Color.medicalLightBlue)
                    .fontWeight(.semibold)
                Text("Log In")
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
    RegisterView()
}
