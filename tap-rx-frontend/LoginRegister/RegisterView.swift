//
//  RegisterView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI
import Foundation
import FirebaseAuth

struct RegisterView: View {
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var name: String = ""
    @State private var last_name: String = ""
    @State private var password: String = ""
    @State private var confirm: String = ""
    @State private var userID: String = ""
    @State private var errorMessage: String = "Invalid Crudentials"
    
    @State private var isEmailValid: Bool = true
    @State private var validPasswords: Bool = true
    @State private var isValidPhone: Bool = true
    @State private var isValidName: Bool = true
    @State private var isValidLastName: Bool = true
    
    @State private var registerSuccess = false
    
    private func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func validatePhoneNumber() -> Bool {
        let phoneRegex = "^(\\+\\d{1,2}\\s)?(\\(\\d{3}\\)\\s?|\\d{3}[-\\s]?)\\d{3}[-\\s]?\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
        
    }
    
    func callRegister(){
        //validate email
        self.isEmailValid = validateEmail()
        if(self.isEmailValid == false){
            self.errorMessage = "Enter a valid email"
        }
        
        //validate phone
        self.isValidPhone = validatePhoneNumber()
        if(isValidPhone==false){
            self.errorMessage="Enter a valid email"
        }
        
        //validate first name
        if(self.name != ""){
            isValidName = true
        } else {
            self.errorMessage = "First name is required."
            isValidName = false
        }
        
        //validate last name
        if(self.last_name != ""){
            isValidLastName = true
        } else {
            self.errorMessage = "Last name is required."
            isValidLastName = false
        }
        
        //validate password
        if(self.password == ""){
            validPasswords = false
            self.errorMessage="Password cannot be empty"
        }
        else if(self.password != "" && self.password.count < 6){
            validPasswords=false
            self.errorMessage="Password must be at least 6 characters"
        } else if(self.password != self.confirm){
            validPasswords=false
            self.errorMessage = "Passwords do not match"
        } else {
            validPasswords = true
        }
        
        if(isValidName && isValidLastName && isEmailValid && isValidPhone && validPasswords){
            Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.registerSuccess = false
                } else {
                    print("User registered successfully")
                    if let user = result?.user {
                        self.userID = user.uid
                        let postData: [String: Any] = [
                            "first_name": self.name,
                            "last_name": self.last_name,
                            "phone": self.phone,
                            "user_id": self.userID
                        ]
                        
                        user.getIDToken { (idToken, error) in
                            //guard let self = self else { return }
                            
                            if let error = error {
                                print("error: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let idToken = idToken else {
                                print("Failed to retrieve ID token.")
                                return
                            }
                            
                            let url = URL(string: "https://taprx.xyz/users/")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue(idToken, forHTTPHeaderField: "Authorization")
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: postData)
                                request.httpBody = jsonData
                                
                                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                    DispatchQueue.main.async {
                                        if let error = error {
                                            print("Network error: \(error.localizedDescription)")
                                            self.registerSuccess = false
                                        } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                            print("Response String: \(responseString)")
                                            do {
                                                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                                                self.registerSuccess = true
                                                print(response)
                                            } catch {
                                                print("Decoding error: \(error)")
                                                self.registerSuccess = false
                                            }
                                        }
                                    }
                                }
                                task.resume()
                            } catch {
                                print("Error serializing JSON: \(error.localizedDescription)")
                            }
                        }
                    }

                }
            }
        }
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
                    .padding(.bottom,30)
                    
                    
                    Text(self.errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .opacity(isEmailValid && validPasswords && isValidName && isValidPhone ? 0 : 1)
                        .frame(height: 20)
                    
                    
                    // Email Field
                    TextField("", text: $email, prompt: Text("Email Address")
                        .foregroundColor(isEmailValid ? Color.medicalLightBlue : Color.red))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isEmailValid ? Color.medicalDarkBlue : Color.red, lineWidth: 2)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.bottom,5)
                    
                    
                    // Phone Field
                    TextField("", text: $phone,prompt: Text("Phone Number")
                        .foregroundColor(isValidPhone ? Color.medicalLightBlue : Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isValidPhone ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    
                    .padding(.bottom,5)
                    
                    //First Name Field
                    TextField("", text: $name,prompt: Text("First Name")
                        .foregroundColor(isValidName ? Color.medicalLightBlue : Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isValidName ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    
                    //Last Name Field
                    TextField("", text: $last_name,prompt: Text("Last Name")
                        .foregroundColor(isValidLastName ? Color.medicalLightBlue : Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isValidLastName ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    
                    .padding(.bottom,5)
                    
                    //Password Field
                    SecureField("",text: $password,prompt: Text("Password")
                        .foregroundColor(validPasswords ? Color.medicalLightBlue : Color.red))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(validPasswords ? Color.medicalDarkBlue : Color.red, lineWidth: 2)
                            .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    )
                    .padding(.bottom,5)
                    
                    // Confirm Password Field
                    SecureField("",text: $confirm, prompt: Text("Confirm Password")
                        .foregroundColor(validPasswords ? Color.medicalLightBlue : Color.red))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(validPasswords ? Color.medicalDarkBlue : Color.red, lineWidth: 2)
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
                    Section{
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
                    }
                    
                    VStack {
                        /*
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
                            .hidden()
                        
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
                            .hidden()*/
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
            
            //hidden navigation link to push to home page on login
            .navigationDestination(isPresented: self.$registerSuccess) {
                LoginView()
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    RegisterView()
}
