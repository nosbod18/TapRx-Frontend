//
//  ReportMedicationEventPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//
import Foundation
import SwiftUI
import FirebaseAuth

struct ReportMedicationEventPopup: View {
    @Binding var isActive: Bool
    @Binding var medication_id: String
    @Binding var dosage: String

    @State private var userID: String = ""
    @State private var timestamp: String = ""
    
    
    func callReportMedEvent(){
        create_med_event()
    }
  
    
    func create_med_event() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDate = Date()
        
        self.timestamp = formatter.string(from: currentDate)
        
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
            let postData: [String: Any] = [
                "timestamp": self.timestamp,
                "dosage": self.dosage,
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
                
                let url = URL(string: "https://taprx.xyz/medications/\(medication_id)/events/")!
                print(url)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(idToken, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: postData)
                    request.httpBody = jsonData
                    print(postData)
                    print(jsonData)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("Network error: \(error.localizedDescription)")
                            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                print("Response String: \(responseString)")
                                do {
                                    let response = try JSONDecoder().decode(CreateMed.self, from: data)
                                    if(response.data != nil){
                                        isActive.toggle()
                                    } else {
                                        print("error with event creation")
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
    }

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            VStack {
                    HStack{
                        Spacer()
                        Button{
                            isActive.toggle()
                        } label: {
                            Image(systemName:"xmark.square.fill")
                                .resizable()
                                .frame(width:20,height:20)
                                .foregroundColor(Color.medicalGrey)
                        }
                    }.padding(0)
                    Text("Report Medication as Taken")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                        .padding(.bottom,10)
                    
                    
                    HStack {
                        Text("Are you sure you want to report medication as taken?")
                                .font(.subheadline)
                                .foregroundColor(Color.medicalDarkBlue)
                            
                    }.frame(maxWidth: .infinity, alignment: .leading)
                
                    Button(action: callReportMedEvent){
                        Text("Confirm")
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
                
        }
    }
}

struct ReportMedicationEventPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var medication_id = "-Nv4zIQD4996vlxbeq25"
        @State private var dosage = "100"
        
        func login(){
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
            }
        }
        var body: some View {
            ReportMedicationEventPopup(isActive: $showSheet,medication_id: $medication_id,dosage: $dosage).onAppear{
                login()
            }
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
