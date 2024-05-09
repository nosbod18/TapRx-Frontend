//
//  ForgotPasswordView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 1/31/24.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var username: String = ""
    @State private var isEmailValid: Bool = true
    @State private var pushActive: Bool = false
    
    private func validateEmail() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isEmailValid = emailPred.evaluate(with: username)
    }
    
    func sendPasswordResetEmail(to email: String) {
        /*let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://taprx.page.link")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)*/
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
                print("\(error)")
                return
            }
            // Password reset email sent.
            else{
                pushActive = true
            }
        }
    }
    
    func callForgotPassword(){
        validateEmail()
        if(isEmailValid){
            sendPasswordResetEmail(to: self.username)
        }
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
                        
                        Text("Enter your email and we'll send you a link to reset your email.")
                            .font(.subheadline)
                            .foregroundColor(Color.medicalLightBlue)
                            .padding(.bottom,30)
                            .fontWeight(.semibold)
                        
                    }.padding(.top, 60)
                    
                    Text("Invalid Crudentials")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .opacity(isEmailValid ? 0 : 1)
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
            
            //hidden navigation link to push to home page on login
            .navigationDestination(isPresented: self.$pushActive) {
                LoginView()
            }
        }
            .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
