//
//  ContentView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI
import FirebaseAuth

struct MedPreview: View {
    static let height = 80.0
    @Binding var reportMedicationModal: Bool
    @Binding var medication_id: String
    @Binding var dosage: String
    
    let item: Med

    init(item: Med,reportMedicationModal: Binding<Bool>,medication_id: Binding<String>,dosage: Binding<String>) {
        self.item = item
        self._reportMedicationModal = reportMedicationModal
        self._medication_id = medication_id
        self._dosage = dosage
    }
    
    func getTime() -> String {
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
        return "\(hour):\(minute)"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedPreview.height)
            
            HStack {
                Text(getTime())
                    .font(.title3)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(width: 2, height: MedPreview.height * 0.90)
                
                VStack(alignment: .leading) {
                    if(item.name != nil && item.nickname != nil) {
                        HStack (alignment: .bottom){
                            Text(item.name ?? "")
                                .foregroundColor(.white)
                                .font(.title2)
                            Text("(\(item.nickname ?? ""))")
                                .foregroundColor(Color.medicalGrey)
                                .font(.title2)
                        }
                    } else {
                        Text(item.name ?? item.nickname ?? "No Name")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                    
                    Text("\(item.dosage ?? "0")mg")
                        .foregroundColor(.medicalGrey)
                        .font(.footnote)
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                Menu {
                    Button {
                        reportMedicationModal.toggle()
                        self.dosage = item.dosage ?? ""
                        self.medication_id = item.medication_id ?? ""
                    } label: {
                        Label("Already taken today?",systemImage: "questionmark.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.rectangle")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
    }
}

struct HomeView: View {
    @ObservedObject var user: User
    @State private var reportMedicationModal: Bool = false
    @State private var medication_id: String = ""
    @State private var dosage: String = ""
    
    
    var body: some View {
        ZStack {
            VStack {
                // Welcome message
                Section {
                    Text("Welcome, \(user.first_name)!")
                        .font(.largeTitle)
                        .foregroundColor(.medicalRed)
                        .fontWeight(.black)
                }
                .padding(.bottom, 20)
                
                // Today's Medications and date
                Section {
                    Text("Today's Medications:")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                    
                    Text(Date.now, style: .date)
                        .font(.title2)
                        .foregroundColor(.medicalLightBlue)
                }
                
                // Medication List
                ScrollView {
                    // TODO: Check if the medications are for today using the schedule
                    if let count = user.medications?.count, count > 0 {
                        ForEach(Array(user.medications!.values), id: \.self) { value in
                            MedPreview(item: value, reportMedicationModal: $reportMedicationModal, medication_id: $medication_id, dosage: $dosage)
                        }
                    } else {
                        Text("No medications for today!")
                            .padding(.vertical, 50)
                            .foregroundStyle(Color.medicalLightBlue)
                            .font(.title2)
                    }
                }
                .mask {
                    LinearGradient(colors: [.black, .clear],
                                   startPoint: UnitPoint(x: 0.5, y: 0.25),
                                   endPoint: UnitPoint(x: 0.5, y: 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            .frame(width: WIDTH)
            .padding(.top, 30)
            .onAppear {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted  // Set output formatting to pretty printed for easier readability
                
                do {
                    let jsonData = try encoder.encode(user)  // Encode the user object to JSON data
                    if let jsonString = String(data: jsonData, encoding: .utf8) {  // Convert JSON data to String
                        print(jsonString)  // Print the JSON string
                    } else {
                        print("Failed to convert data to string.")
                    }
                } catch {
                    print("Encoding error: \(error)")  // Print the error if encoding fails
                }
            }
            
            if reportMedicationModal {
                
                ReportMedicationEventPopup(isActive: $reportMedicationModal, medication_id: $medication_id, dosage: $dosage)
                .onAppear{
                    print("medication: \(medication_id)")
                    print("dosage: \(dosage)")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    struct WrapperView: View {
        @ObservedObject var user: User = User()
        
        @State private var userID: String = ""
        func login(){
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
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
                                            if(response.success==true){
                                                self.user.update(with: response.data)
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
            HomeView(user: user)
                .onAppear{ login() }
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
