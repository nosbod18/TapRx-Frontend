//
//  EditMedicationPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//
import Foundation
import SwiftUI
import FirebaseAuth

struct EditMedicationPopup: View {
    @Binding var isActive: Bool
    @Binding var medication_id: String
    @ObservedObject var user: User
    @State private var userID: String = ""
    
    
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var dosage: String = ""
    @State private var day_of_month: String = ""
    @State private var day_of_week: String = ""
    @State private var month: String = ""
    @State private var hours: String = ""
    @State private var minutes: String = ""
    
    @State private var validName: Bool = true
    @State private var validDosage: Bool = true
    @State private var validSchedule: Bool = true
    
    @State private var selectedTime = Date()
    @State private var selectedOption = "Daily"
    @StateObject var weeklyViewModel = ButtonsViewModel(count: 7)
    @StateObject var monthlyViewModel = ButtonsViewModel(count: 31)
    
    init(isActive: Binding<Bool>,medication_id: Binding<String>,user: User){
        self._isActive = isActive
        self._medication_id = medication_id
        self.user = user
    }
    
    func loadMedData(){
        if let user = Auth.auth().currentUser {
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
                                    print(response)
                                    if(response.success==true){
                                        user.reload()
                                        dosage = response.data?.dosage ?? ""
                                        name = response.data?.name ?? ""
                                        nickname = response.data?.nickname ?? ""
                                        month = response.data?.schedule?.month ?? ""
                                        hours = response.data?.schedule?.hour ?? ""
                                        minutes = response.data?.schedule?.minute ?? ""
                                        day_of_month = response.data?.schedule?.day_of_month ?? ""
                                        day_of_week = response.data?.schedule?.day_of_week ?? ""
                                        if(day_of_month == "*"){
                                            selectedOption = "Daily"
                                        } else if (day_of_month != ""){
                                            selectedOption = "Monthly"
                                        } else if (day_of_week != ""){
                                            selectedOption = "Weekly"
                                        } else {
                                            selectedOption = "Daily"
                                        }
                                        let dateString = "\(hours):\(minutes)"
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "HH:mm"
                                        if let date = formatter.date(from: dateString) {
                                            selectedTime = date
                                        } else {
                                            selectedTime = Date.now
                                        }
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
    
    func callEditMed(){
        //validate name
        if(name.count > 0){
            validName = true
        } else {
            validName = false
        }
        
        //validate dosage
        if(dosage.count > 0){
            validDosage = true
        } else {
            validDosage = false
        }
        
        //validate schedule
        validSchedule = true
        if(selectedOption == "Daily"){
            populate_schedule()
        } else if (selectedOption == "Weekly"){
            populate_schedule()
            let weeklyTrueCount = weeklyViewModel.buttonStates.filter { $0 == true }.count
            validSchedule = weeklyTrueCount > 0
        } else if (selectedOption == "Monthly") {
            populate_schedule()
            let monthlyTrueCount = monthlyViewModel.buttonStates.filter { $0 == true }.count
            validSchedule = monthlyTrueCount > 0
        } else {
            validSchedule = false
        }
        
        if(validName && validDosage && validSchedule){
            edit_med()
        } else {
            print(validName)
            print(validDosage)
            print(validSchedule)
        }
    }
    
    func populate_schedule(){
        month = "*"
        let calendar = Calendar.current
        let selectedHour = calendar.component(.hour, from: selectedTime)
        let selectedMinute = calendar.component(.minute, from: selectedTime)
        hours = String(selectedHour)
        minutes = String(selectedMinute)
        if(selectedOption == "Daily"){
            day_of_month = "*"
            day_of_week = "*"
        } else if (selectedOption == "Weekly"){
            let weekly = weeklyViewModel.buttonStates.enumerated().filter { $0.element == true }.map { $0.offset }
            let cronDaysOfWeek = weekly.map { String($0) }.joined(separator: ",")
            day_of_week = cronDaysOfWeek
            day_of_month = ""
        } else if (selectedOption == "Monthly") {
            let monthly = monthlyViewModel.buttonStates.enumerated().filter { $0.element == true }.map { $0.offset+1 }
            let cronDaysOfMonth = monthly.map { String($0) }.joined(separator: ",")
            day_of_month = cronDaysOfMonth
            day_of_week = ""
        } else {
            validSchedule = false
        }
    }
    
    func edit_med() {
        if let user = Auth.auth().currentUser {
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
                
                let url = URL(string: "https://taprx.xyz/medications/\(medication_id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
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
                                    let response = try JSONDecoder().decode(CreateMed.self, from: data)
                                    if(response.data != nil){
                                        self.user.refresh()
                                        isActive.toggle()
                                        name = ""
                                        nickname = ""
                                        dosage = ""
                                        validName = true
                                        validDosage = true
                                        validSchedule = true
                                        selectedOption = "Daily"
                                        monthlyViewModel.resetButtons()
                                        weeklyViewModel.resetButtons()
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
                } catch {
                    print("Error serializing JSON: \(error.localizedDescription)")
                }
            }
        }
    }

    var body: some View {
        let options = ["Daily","Weekly","Monthly"]
        ZStack {
            VStack {
                    HStack{
                        Spacer()
                        Button{
                            isActive.toggle()
                            name = ""
                            nickname = ""
                            dosage = ""
                            validName = true
                            validDosage = true
                            validSchedule = true
                            selectedOption = "Daily"
                            monthlyViewModel.resetButtons()
                            weeklyViewModel.resetButtons()
                        } label: {
                            Image(systemName:"xmark.square.fill")
                                .resizable()
                                .frame(width:20,height:20)
                                .foregroundColor(Color.medicalGrey)
                        }
                    }.padding(0)
                    Text("Update Medication")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                        .padding(.bottom,10)
                    
                    TextField("", text: $name, prompt: Text("Name")
                        .foregroundColor(validName ? Color.medicalLightBlue : Color.medicalRed) + Text(" *").foregroundColor(Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(self.validName ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                    )
                    .padding(.bottom,5)
                
                    TextField("", text: $nickname,prompt: Text("Nickname")
                        .foregroundColor(Color.medicalLightBlue))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.medicalDarkBlue, lineWidth: 2)
                    )
                    .padding(.bottom,5)
                    
                    TextField("", text: $dosage,prompt: Text("Dosage")
                        .foregroundColor(validDosage ? Color.medicalLightBlue : Color.medicalRed) + Text(" *").foregroundColor(Color.medicalRed))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding([.leading,.trailing],15)
                    .padding([.top,.bottom],8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(self.validDosage ? Color.medicalDarkBlue : Color.medicalRed, lineWidth: 2)
                    )
                    .padding(.bottom,5)
                    HStack{
                        Picker("Select Frequency", selection: $selectedOption) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(Color.medicalDarkBlue)
                        
                        DatePicker("Select time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .accentColor(Color.medicalDarkBlue)
                    }
                    
                if selectedOption == "Weekly" {
                    
                    HStack {
                        Text("Select Days:")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .frame(alignment: .leading)
                            .foregroundStyle(Color.medicalDarkBlue)
                        
                        Spacer()
                    }
                    HStack {
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 0)
                        }) {
                            Image(systemName: "s.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[0] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 1)
                        }) {
                            Image(systemName: "m.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[1] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 2)
                        }) {
                            Image(systemName: "t.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[2] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 3)
                        }) {
                            Image(systemName: "w.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[3] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 4)
                        }) {
                            Image(systemName: "t.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[4] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 5)
                        }) {
                            Image(systemName: "f.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[5] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            weeklyViewModel.toggleButton(at: 6)
                        }) {
                            Image(systemName: "s.square")
                                .resizable()
                                .foregroundColor(weeklyViewModel.buttonStates[6] ? .medicalRed : .medicalDarkBlue)
                                .frame(width:35,height:35)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                } else if selectedOption == "Monthly" {
                    HStack {
                        Text("Select Days:")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .frame(alignment: .leading)
                            .foregroundStyle(Color.medicalDarkBlue)
                        
                        Spacer()
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 35))]) {
                        ForEach(0..<31, id: \.self) { index in
                            Button(action: {
                                monthlyViewModel.toggleButton(at: index)
                            }) {
                                Image(systemName: "\(index+1).square")
                                    .resizable()
                                    .foregroundColor(monthlyViewModel.buttonStates[index] ? .medicalRed : .medicalDarkBlue)
                                    .frame(width:35,height:35)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                
                    Button(action: callEditMed){
                        Text("Update Medication")
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
            loadMedData()
        }
    }
}

struct EditMedicationPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var medication_id = "-Nv4zIQD4996vlxbeq25"
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
            EditMedicationPopup(isActive: $showSheet,medication_id: $medication_id,user: user).onAppear{
                login()
            }
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
