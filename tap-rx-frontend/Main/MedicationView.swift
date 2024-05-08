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

struct MedicationFullview: View {
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
    @Binding var aboutMedicationModal: Bool
    @Binding var editMedicationModal: Bool
    @Binding var deleteMedicationModal: Bool
    @Binding var medication_id: String
    let item: Med
    
    init(item: Med, aboutMedicationModal: Binding<Bool>, editMedicationModal: Binding<Bool>, deleteMedicationModal: Binding<Bool>,medication_id: Binding<String>) {
        self.item = item
        self._aboutMedicationModal = aboutMedicationModal
        self._editMedicationModal = editMedicationModal
        self._deleteMedicationModal = deleteMedicationModal
        self._medication_id = medication_id
    }

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedicationFullview.height)
            
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
                                aboutMedicationModal.toggle()
                            } label: {
                                Label("About",systemImage:"i.circle")
                            }
                            Button{
                                medication_id = item.medication_id ?? ""
                                editMedicationModal.toggle()
                            } label: {
                                Label("Edit",systemImage:"pencil")
                                    
                            }
                            Button{
                                medication_id = item.medication_id ?? ""
                                deleteMedicationModal.toggle()
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

struct AddMedicationButton: View {
    @Binding var addMedicationModal: Bool

    var body: some View {
        ZStack{
            ZStack(alignment: .center) {
                Capsule()
                    .stroke(Color.medicalRed)
                    .frame(width: 200, height: 35)
                
                Button {
                    addMedicationModal.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                            .renderingMode(.template)
                            .foregroundColor(.medicalRed)
                        
                        Text("Add Medication")
                            .foregroundColor(.medicalRed)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
        }
    }
}

struct MedicationView: View {
    @State private var addMedicationModal: Bool = false
    @State private var editMedicationModal: Bool = false
    @State private var aboutMedicationModal: Bool = false
    @State private var deleteMedicationModal: Bool = false
    @State private var selectedMedication: String = ""
    @ObservedObject var user: User
    
    @State private var userID: String = ""
    var body: some View {
        
        ZStack {
            VStack {
                Section {
                    Text("Your Medications")
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
                            MedicationFullview(item: item, aboutMedicationModal: $aboutMedicationModal, editMedicationModal: $editMedicationModal, deleteMedicationModal: $deleteMedicationModal, medication_id: $selectedMedication)
                        }
                    } else {
                        Text("No medications yet!")
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
                
                AddMedicationButton(addMedicationModal: $addMedicationModal)
            }
            .frame(width: WIDTH)
            .padding(.top, 30)
            
            if addMedicationModal {
                CreateMedicationPopup(isActive: $addMedicationModal, user: user)
            }
            if aboutMedicationModal {
                AboutMedicationPopup(isActive: $aboutMedicationModal,medication_id: $selectedMedication)
            }
            if editMedicationModal {
                EditMedicationPopup(isActive: $editMedicationModal,medication_id: $selectedMedication)
            }
            if deleteMedicationModal {
                DeleteMedicationPopup(isActive: $deleteMedicationModal,medication_id: $selectedMedication, user: user)
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
                                        print("Network error: \(error.localizedDescription)")
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
            MedicationView(user: user)
                .onAppear{ login() }
            
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
