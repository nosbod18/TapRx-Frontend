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
    @Binding var medication_id: String
    
    @State private var email = "drewclutes@gmail.com"
    @State private var password = "123456"
    @State private var userID: String = ""
    
    @State private var name: String = "loading.."
    @State private var nickname: String = "loading.."
    @State private var dosage: String = "loading.."
    @State private var schedule: String = "loading.."
    
    func describeCron(item: Med) -> String {
        var minute = ""
        if let minuteInt = item.schedule?.minute {
            if(Int(minuteInt)! < 9) {
                minute = "0\(minuteInt)"
            } else {
                minute = item.schedule!.minute
            }
        }
        
        var hour = ""
        if let hourInt = item.schedule?.hour {
            if(Int(hourInt)! < 9) {
                hour = "0\(hourInt)"
            } else {
                hour = item.schedule!.hour
            }
        }
        let dayOfMonthDesc = item.schedule?.day_of_month == "*" ? "every day" : "on the \(item.schedule?.day_of_month ?? "") day of the month"
        let dayOfWeekDesc = item.schedule?.day_of_week == "*" ? "every day of the week" : "on \(item.schedule?.day_of_week ?? "")"

        if(item.schedule?.day_of_month == "*"){
            return "Taken daily at \(hour):\(minute)"
        } else if (item.schedule?.day_of_week != ""){
            return "Taken weekly at \(hour):\(minute) \(dayOfWeekDesc)"
        } else if (item.schedule?.day_of_month != ""){
            return "Taken monthly at \(hour):\(minute) \(dayOfMonthDesc)"
        } else {
            return "Taken at \(hour):\(minute)"
        }
        
    }
    
    func get_medication_by_id(){
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            

            
            if let user = result?.user {
                self.userID = user.uid
                let url = URL(string: "https://taprx.xyz/medications/\(self.medication_id)")!
                print(url)
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
                                        if response.success==true{
                                            let medication = response.data
                                            self.name = medication?.name ?? "None"
                                            self.nickname = medication?.nickname ?? "None"
                                            self.dosage = medication?.dosage ?? "None"
                                            self.schedule = describeCron(item: medication!)
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
                            Text("Name: \(self.name)").fontWeight(.semibold)
                        }
                        HStack{
                            Text("Nickname: \(self.dosage)").fontWeight(.semibold)
                        }
                        HStack{
                            Text("Dosage: \(self.dosage)").fontWeight(.semibold)
                        }
                        HStack{
                            Text("Schedule: \(self.schedule)").fontWeight(.semibold)
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
        @State private var medication_id = "-Nv4zIQD4996vlxbeq25"
        var body: some View {
            AboutMedicationPopup(isActive: $showSheet,medication_id: $medication_id)
        }
    }

    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
