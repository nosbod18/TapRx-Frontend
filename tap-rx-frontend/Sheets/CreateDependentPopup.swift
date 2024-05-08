//
//  CreateDependantPopup.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 4/16/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct CreateDependantPopup: View {
    @Binding var isActive: Bool
    
    @ObservedObject var user: User
    
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    @State private var validEmail = true
    @State private var validFirstName = true
    @State private var validLastName = true
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func callCreateDependant() {
        validEmail = validateEmail()
        validFirstName = (firstName.count > 0)
        validLastName = (lastName.count > 0)
        
        if validEmail && validFirstName && validLastName {
            createDependant()
        } else {
            print("validEmail: \(validEmail)")
            print("validFirstName: \(validFirstName)")
            print("validLastName: \(validLastName)")
        }
    }
    
    func createDependant() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.getIDToken { (idToken, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }

            guard let idToken = idToken else {
                print("Failed to retrieve ID token.")
                return
            }
            
            let url = URL(string: "https://taprx.xyz/users/\(user.uid)/dependants")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(Dependant(first_name: firstName, last_name: lastName))
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Network error: \(error.localizedDescription)")
                            return
                        }

                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response String: \(responseString)")
                            do {
                                let response = try JSONDecoder().decode(CreateDependant.self, from: data)
                                
                                if let success = response.success, success {
                                    isActive.toggle()
                                    email = ""
                                    firstName = ""
                                    lastName = ""
                                } else {
                                    print("error with creation")
                                }
                            } catch {
                                print("Decoding error: \(error)")
                            }
                        }
                    }
                }

                task.resume()
                
                self.user.refresh()

            } catch {
                print("Error serializing JSON: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack{
                    Spacer()

                    Button{
                        isActive.toggle()
                        email = ""
                        firstName = ""
                        lastName = ""
                    } label: {
                        Image(systemName:"xmark.square.fill")
                            .resizable()
                            .frame(width:20, height:20)
                            .foregroundColor(Color.medicalGrey)
                    }
                }
                .padding(0)

                Text("Create Dependant")
                    .font(.title2)
                    .foregroundColor(.medicalDarkBlue)
                    .fontWeight(.black)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(height: 5)
                    .padding(.bottom,10)
                
                TextField("", text: $email, prompt: Text("Email")
                    .foregroundColor(validEmail ? Color.medicalLightBlue : Color.medicalRed) + Text(" *").foregroundColor(Color.medicalRed))
                .fontWeight(.semibold)
                .font(.subheadline)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding([.leading,.trailing],15)
                .padding([.top,.bottom],8)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(validEmail ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                )
                .padding(.bottom,5)
            
                TextField("", text: $firstName, prompt: Text("First Name")
                    .foregroundColor(validFirstName ? Color.medicalLightBlue : Color.medicalRed) + Text(" *").foregroundColor(Color.medicalRed))
                .fontWeight(.semibold)
                .font(.subheadline)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding([.leading,.trailing],15)
                .padding([.top,.bottom],8)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(validFirstName ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                )
                .padding(.bottom,5)
                
                TextField("", text: $lastName, prompt: Text("Last Name")
                    .foregroundColor(validLastName ? Color.medicalLightBlue : Color.medicalRed) + Text(" *").foregroundColor(Color.medicalRed))
                .fontWeight(.semibold)
                .font(.subheadline)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding([.leading,.trailing],15)
                .padding([.top,.bottom],8)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(validLastName ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                )
                .padding(.bottom,5)
                
                Button(action: callCreateDependant) {
                    Text("Create Dependant")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding([.top,.bottom],10)
                .padding([.leading,.trailing],15)
                .foregroundColor(.white)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.medicalRed)
                )
                .padding(.top,15)
            }
            .frame(width: WIDTH * 0.9)
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
                
        }
    }
}

struct CreateDependantPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        
        func login(){
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
            }
        }

        var body: some View {
            CreateDependantPopup(isActive: $showSheet, user: User()).onAppear{
                login()
            }
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
