//
//  EditDependantPopup.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 4/16/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct EditDependantPopup: View {
    @Binding var isActive: Bool
    @Binding var dependantID: String
    
    @ObservedObject var user: User
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var validFirstName: Bool = true
    @State private var validLastName: Bool = true
    
    func loadDependant() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let url = URL(string: "https://taprx.xyz/users/\(dependantID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        user.getIDToken { idToken, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = idToken else {
                return
            }
            
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response String: \(responseString ?? "Test")")

                    do {
                        let response = try JSONDecoder().decode(GetDependantByID.self, from: data)
                        DispatchQueue.main.async {
                            print(response)
                            if let success = response.success, success {
                                firstName = response.data!.first_name
                                lastName = response.data!.last_name
                            }
                        }
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }

            task.resume()
            self.user.refresh()
        }
    }
    
    func callEditDependant(){
        validFirstName = (firstName.count > 0)
        validLastName = (lastName.count > 0)
        
        if validFirstName && validLastName {
            editDependant()
        } else {
            print("validFirstName = \(validFirstName)")
            print("validLastName = \(validLastName)")
        }
    }
    
    func editDependant() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
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
            
            let url = URL(string: "https://taprx.xyz/users/\(user.uid)/dependants")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(Dependant(dependant_id: dependantID, first_name: firstName, last_name: lastName))
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Network error: \(error.localizedDescription)")
                        } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response String: \(responseString)")
                            do {
                                let response = try JSONDecoder().decode(CreateMed.self, from: data)
                                if let success = response.success, success {
                                    self.user.refresh()
                                    isActive.toggle()
                                    firstName = ""
                                    lastName = ""
                                    validFirstName = true
                                    validLastName = true
                                } else {
                                    print("error with edit")
                                }
                            } catch {
                                print("Decoding error: \(error)")
                                
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

    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Spacer()
                    Button{
                        isActive.toggle()
                        firstName = ""
                        lastName = ""
                        validFirstName = true
                        validLastName = true
                    } label: {
                        Image(systemName:"xmark.square.fill")
                            .resizable()
                            .frame(width:20,height:20)
                            .foregroundColor(Color.medicalGrey)
                    }
                }
                .padding(0)

                Text("Update Dependant")
                    .font(.title2)
                    .foregroundColor(.medicalDarkBlue)
                    .fontWeight(.black)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(height: 5)
                    .padding(.bottom,10)
                
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
                
                Button(action: callEditDependant){
                    Text("Update Dependant")
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
            .frame(width: UIScreen.main.bounds.width*0.8)
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)

        }.onAppear{
            loadDependant()
        }
    }
}

struct EditDependantPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var dependantID = "-Nv5HRJXV9pDL1okR_oW"

        @ObservedObject var user = User()
        
        func login() {
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                user.refresh()
            }
        }

        var body: some View {
            EditDependantPopup(isActive: $showSheet, dependantID: $dependantID, user: user).onAppear{
                login()
            }
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
