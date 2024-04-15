//
//  AboutMedicationPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//

import SwiftUI
import FirebaseAuth

struct AboutMedicationPopup: View {
    @Binding var isActive: Bool
    
    @State private var email = "drewclutes@gmail.com"
    @State private var password = "123456"
    @State private var medication_id: String = "-Nv4zIQD4996vlxbeq25"
    @State private var userID: String = ""
    
    @State private var name: String = "loading.."
    @State private var nickname: String = "loading.."
    @State private var dosage: String = "loading.."
    @State private var schedule: String = "loading.."
    
    func get_medication_by_id(){
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            

            
            if let user = result?.user {
                self.userID = user.uid
                let url = URL(string: "https://taprx.xyz/medications/\(self.medication_id)")!
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
                                    let response = try JSONDecoder().decode(GetMedById.self, from: data)
                                    DispatchQueue.main.async {
                                        if let medication = response.data {
                                            self.name = medication.name ?? "None"
                                            self.nickname = medication.nickname ?? "None"
                                            self.dosage = medication.dosage ?? "None"
                                            self.schedule = "tbd"
                                        }
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
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            
            VStack {
                    HStack{
                        Spacer()
                        Button{
                            isActive.toggle()
                        } label: {
                            Image(systemName:"xmark.square.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.medicalGrey)
                        }
                    }.padding(0)
                    Text("About Medication")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                    
                    Section{
                        HStack{
                            Text("Name: ").fontWeight(.bold)
                            Text(self.name)
                        }
                        HStack{
                            Text("Nickname: ").fontWeight(.bold)
                            Text(self.nickname)
                        }
                        HStack{
                            Text("Dosage: ").fontWeight(.bold)
                            Text(self.dosage)
                        }
                        HStack{
                            Text("Schedule: ").fontWeight(.bold)
                            Text(self.schedule)
                        }
                    }
                        .frame(maxWidth:.infinity,alignment:.leading)
                        .foregroundColor(Color.medicalDarkBlue)
                        
                    
                }
                .frame(width: UIScreen.main.bounds.width*0.8)
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .onAppear{
                    get_medication_by_id()
            }
        }
            
    }
}

struct AboutMedicationPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility

        var body: some View {
            AboutMedicationPopup(isActive: $showSheet)
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
