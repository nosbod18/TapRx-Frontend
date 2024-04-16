//
//  CreateMedEventAPITest.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import SwiftUI
import FirebaseAuth
import Foundation

struct CreateMedEventAPITest: View {
    @State private var email: String = "drewclutes@gmail.com"
    @State private var password: String = "123456"
    @State private var userID: String = ""
    
    
    @State private var med_id: String = ""
    @State private var dosage: String = ""
    
    func create_med_event() {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            //get current timestamp, set up formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let currentDate = Date()
            
            if let user = result?.user {
                self.userID = user.uid
                let postData: [String: Any] = [
                    "dosage": self.dosage,
                    "timestamp": formatter.string(from: currentDate),
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
                    
                    let url = URL(string: "https://taprx.xyz/medications/\(self.med_id)/events/")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue(idToken, forHTTPHeaderField: "Authorization")
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: postData)
                        request.httpBody = jsonData
                        print(jsonData)
                        
                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print("Network error: \(error.localizedDescription)")
                                } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                    print("Response String: \(responseString)")
                                    do {
                                        let response = try JSONDecoder().decode(CreateMedEvent.self, from: data)
                                        print(response)
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
        }
    }
    
    var body: some View {
        VStack {
            
            
            TextField(
                    "med id",
                    text: $med_id
                ).padding([.top,.bottom],20)
            TextField(
                    "dosage",
                    text: $dosage
                ).padding([.top,.bottom],20)
            
            
            Button(action: create_med_event) {
                Label("Create Med Event", systemImage: "folder.badge.plus")
            }.padding([.top,.bottom],20)
        }
            .background(.gray)
            .padding(10)
        
    }
}

#Preview {
    CreateMedEventAPITest()
}
