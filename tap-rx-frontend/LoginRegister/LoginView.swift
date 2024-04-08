//
//  LoginView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var pushActive = false
    @State var isEmailValid: Bool = true
    @State var isValidPassword: Bool = true
    @State var userID: String = ""
    @State var error: String = "Invalid Crudentials"
    @State var showError: Bool = false

    
    private func validateEmail() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isEmailValid = emailPred.evaluate(with: username)
    }
    
    func callLogIn(){
        validateEmail()
        if isEmailValid && !password.isEmpty {
            isValidPassword = true
            Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.showError = true;
                    self.error = "Invalid Email or Password.. Please Try Again."
                    return
                }
                
                print("User signed in successfully")
                

                
                if let user = result?.user {
                    self.userID = user.uid
                    let url = URL(string: "https://taprx.xyz/users/\(self.userID)")!
                    var request = URLRequest(url: url)
                    request.httpMethod="GET"
                    user.getIDToken { idToken, error in
                        if let error = error {
                            print("error: \(error.localizedDescription)")
                        } else if let idToken = idToken {
                            request.setValue(idToken, forHTTPHeaderField: "Authorization")
                            
                            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                if let error = error {
                                    DispatchQueue.main.async {
                                        print( "Network error: \(error.localizedDescription)")
                                    }
                                } else if let data = data {
                                    let responseString = String(data: data, encoding: .utf8)
                                    print("Response String: \(responseString ?? "Test")")

                                    do {
                                        let response = try JSONDecoder().decode(APIResponse.self, from: data)
                                        DispatchQueue.main.async {
                                            print(response.data)
                                            self.pushActive = true
                                        }
                                    } catch {
                                        print("Decoding error: \(error)")
                                    }
                                }
                            }
                            task.resume()
                        }
                    }
                    
                }
            }
        } else if (password.isEmpty && !isEmailValid && password.count < 6){
            isValidPassword = false
            self.error = "Invalid Login Crudentials"
            showError = true
        } else if(!isEmailValid){
            isValidPassword = false
             self.error = "Enter a Valid Email"
            showError = true
        } else {
            isValidPassword = false
            self.error = "Enter a Valid Password"
            showError = true
        
        }
    }
    
    func setEscape(_ condition: Bool){
        self.pushActive = condition
    }
    func callGoogleLogIn(){
        print("google log in")
    }
    
    func callAppleLogIn(){
        print("apple log in")
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
                    }.padding([.top,.bottom], 60)
                    
                    Text(self.error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .opacity(showError ? 1 : 0)
                        .frame(height: 20)
                    
                    //Username Field
                    TextField("", text: $username,prompt: Text("Email")
                        .foregroundColor(isEmailValid ? Color.medicalLightBlue : Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isEmailValid ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                    )
                    
                    .padding(.bottom,5)
                    
                    //Password Field
                    SecureField("",text: $password,prompt: Text("Password")
                        .foregroundColor(isValidPassword ? Color.medicalLightBlue : Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(isValidPassword ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
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
                        Text("Sign In")
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
                    /*
                    VStack {
                        Button(action: callAppleLogIn){
                            HStack{
                                Image(systemName: "apple.logo")
                                    .offset(x: -3)
                                Text("Sign in with Apple")
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
                            )
                            .padding(.top,5)
                        
                        Button(action: callGoogleLogIn){
                            HStack{
                                Image("google.logo")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .offset(x:2)
                                Text("Sign in with Google")
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
                            )
                            .padding(.top,5)
                    }
                    */
                    
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
            
            //hidden navigation link to push to home page on login
            .navigationDestination(isPresented: self.$pushActive) {
                MainView()
            }
        }.navigationBarHidden(true)
            
    }
}

#Preview {
    LoginView()
}
