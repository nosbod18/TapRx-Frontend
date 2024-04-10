//
//  CreateMedicationAPITest.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import SwiftUI
import FirebaseAuth

struct CreateMedicationAPITest: View {
    @State private var email: String = "drewclutes@gmail.com"
    @State private var password: String = "123456"
    @State private var userID: String = ""
    
    
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var dosage: String = ""
    @State private var day_of_month: String = ""
    @State private var day_of_week: String = ""
    @State private var month: String = ""
    @State private var hours: String = ""
    @State private var minutes: String = ""
    
    
    
    func create_medication() {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            //print("User signed in successfully")
            

            
            if let user = result?.user {
                self.userID = user.uid
                let postData: [String: Any] = [
                    "name": self.name,
                    "nickname": self.nickname,
                    "dosage": self.dosage,
                    "schedule":[
                        "day_of_month": self.day_of_month,
                        "day_of_week": self.day_of_week,
                        "month": self.month,
                        "hour": self.hours,
                        "minute": self.minutes
                    ]
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
                    
                    let url = URL(string: "https://taprx.xyz/medications/")!
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
                                    //self.registerSuccess = false
                                } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                    print("Response String: \(responseString)")
                                    do {
                                        let response = try JSONDecoder().decode(CreateMedication.self, from: data)
                                        //self.registerSuccess = true
                                        print(response)
                                    } catch {
                                        print("Decoding error: \(error)")
                                        //self.registerSuccess = false
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
    
    var body: some View {
        VStack {
            
            
            TextField(
                    "name",
                    text: $name
                ).padding([.top,.bottom],20)
            TextField(
                    "nickname",
                    text: $nickname
                ).padding([.top,.bottom],20)
            TextField(
                    "dosage",
                    text: $dosage
                ).padding([.top,.bottom],20)
            TextField(
                    "day of month",
                    text: $day_of_month
                ).padding([.top,.bottom],20)
            TextField(
                    "day of week",
                    text: $day_of_week
                ).padding([.top,.bottom],20)
            TextField(
                    "month",
                    text: $month
                ).padding([.top,.bottom],20)
            TextField(
                    "hours",
                    text: $hours
                ).padding([.top,.bottom],20)
            TextField(
                    "minutes",
                    text: $minutes
                ).padding([.top,.bottom],20)
            
            
            
            Button(action: create_medication) {
                Label("Create Medication", systemImage: "folder.badge.plus")
            }.padding([.top,.bottom],20)
        }
            .background(.gray)
            .padding(10)
        
    }
}

#Preview {
    CreateMedicationAPITest()
}
