//
//  MedView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI
import FirebaseAuth

struct DayView: View {
    static let days = ["s.square","m.square", "t.square", "w.square", "t.square", "f.square", "s.square"]

    let name: String
    let color: Color
    
    init(day: Int, active: Bool) {
        self.name = DayView.days[day]
        self.color = active ? .medicalRed : .white
    }
    
    var body: some View {
        Image(systemName: self.name)
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 30)
            .foregroundStyle(self.color)
            .padding(.horizontal, 2)
    }
}

struct MedFullview: View {
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
    func describeCron() -> String {
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
    
    
    
    
    static let height = 140.0
    @Binding var aboutMedModal: Bool
    @Binding var editMedModal: Bool
    @Binding var deleteMedModal: Bool
    @Binding var medication_id: String
    let item: Med
    
    init(item: Med, aboutMedModal: Binding<Bool>, editMedModal: Binding<Bool>, deleteMedModal: Binding<Bool>,medication_id: Binding<String>) {
        self.item = item
        self._aboutMedModal = aboutMedModal
        self._editMedModal = editMedModal
        self._deleteMedModal = deleteMedModal
        self._medication_id = medication_id
    }

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedFullview.height)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        if(item.name != nil && item.nickname != nil){
                            Text(item.name ?? "")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            Text(item.nickname ?? "")
                                .foregroundColor(Color.medicalGrey)
                                .font(.title3)
                        } else {
                            Text(item.name ?? item.nickname ?? "<??>")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        Spacer()
                        
                        Menu {
                            Button{
                                medication_id = item.medication_id ?? ""
                                aboutMedModal.toggle()
                            } label: {
                                Label("About",systemImage:"i.circle")
                            }
                            Button{
                                medication_id = item.medication_id ?? ""
                                editMedModal.toggle()
                            } label: {
                                Label("Edit",systemImage:"pencil")
                                    
                            }
                            Button{
                                medication_id = item.medication_id ?? ""
                                deleteMedModal.toggle()
                            } label: {
                                Label("Delete",systemImage:"trash")
                                    .foregroundColor(.red)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.white)
                                .padding(.trailing, 10)
                                .padding(.top, -5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                    
                    Text("\(getTime()) | \(item.dosage ?? "0mg")")
                        .foregroundColor(.medicalGrey)
                        .font(.footnote)

                    }
                
                
                // TODO: Get active days from schedule
                HStack{
                    Text(describeCron())
                        .foregroundColor(.white)
                        .font(.subheadline)
                    
                
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .vertical])
        }
    }
}

struct AddMedButton: View {
    @Binding var addMedModal: Bool

    var body: some View {
        ZStack{
            ZStack(alignment: .center) {
                Capsule()
                    .stroke(Color.medicalRed)
                    .frame(width: WIDTH * 0.4, height: 35)
                
                Button {
                    addMedModal.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(.medicalRed)
                        
                        Text("Add Med")
                            .foregroundColor(.medicalRed)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            
        }
    }
}

extension User {
    func update(with data: User) {
        self.first_name = data.first_name
        self.last_name = data.last_name
        self.medications = data.medications
        self.phone = data.phone
        self.user_id = data.user_id
    }
}

struct MedView: View {
    @State private var addMedModal: Bool = false
    @State private var editMedModal: Bool = false
    @State private var aboutMedModal: Bool = false
    @State private var deleteMedModal: Bool = false
    @State private var selectedMedication: String = ""
    @ObservedObject var user: User
    
    @State private var userID: String = ""
    var body: some View {
        
        ZStack {
            VStack {
                Section {
                    Text("Your Meds")
                        .font(.largeTitle)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                }
                .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(height: 5)
                
                ScrollView {
                    if let count = user.medications?.count, count > 0 {
                        ForEach(Array(user.medications!.values), id: \.self) { item in
                            MedFullview(item: item,aboutMedModal: $aboutMedModal, editMedModal: $editMedModal, deleteMedModal: $deleteMedModal, medication_id: $selectedMedication)
                        }
                    } else {
                        Text("No Meds added")
                            .padding(.vertical, 50)
                            .foregroundStyle(Color.medicalLightBlue)
                            .font(.title2)
                    }
                }
                .mask {
                    LinearGradient(colors: [.black, .clear],
                                   startPoint: UnitPoint(x: 0.5, y: 0.5),
                                   endPoint: UnitPoint(x: 0.5, y: 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                AddMedButton(addMedModal: $addMedModal)
            }
            .frame(width: WIDTH)
            .padding(.top, 30)
            
            if addMedModal {
                CreateMedicationPopup(isActive: $addMedModal)
            }
            if aboutMedModal {
                AboutMedicationPopup(isActive: $aboutMedModal,medication_id: $selectedMedication)
            }
            if editMedModal {
                EditMedicationPopup(isActive: $editMedModal,medication_id: $selectedMedication)
            }
            if deleteMedModal {
                DeleteMedicationPopup(isActive: $deleteMedModal,medication_id: $selectedMedication)
            }
        }.onAppear {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted 

            do {
                let jsonData = try encoder.encode(user)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to string.")
                }
            } catch {
                    print("Encoding error: \(error)")
            }
        }
    }
}

struct MedicationView_Previews: PreviewProvider {
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
                                            if response.success == true{
                                                print("TEST")
                                                let user_data = response.data
                                                self.user.update(with: user_data)
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
            MedView(user: user)
                .onAppear{ login() }
            
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
