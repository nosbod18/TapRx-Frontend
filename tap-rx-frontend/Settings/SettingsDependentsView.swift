//
//  SettingsUserView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI
import FirebaseAuth

struct DependantView: View {
    static let height = 75.0
    @Binding var editDependantModal: Bool
    @Binding var deleteDependantModal: Bool
    @Binding var dependantID: String

    let item: Dependant
    
    init(item: Dependant, editDependantModal: Binding<Bool>, deleteDependantModal: Binding<Bool>, dependantID: Binding<String>) {
        self.item = item
        self._editDependantModal = editDependantModal
        self._deleteDependantModal = deleteDependantModal
        self._dependantID = dependantID
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: DependantView.height)
            
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("\(item.first_name) \(item.last_name)")
                        .foregroundColor(.white)
                        .font(.title2)

                    Spacer()
                    
                    Menu {
                        Button{
                            dependantID = item.dependant_id ?? ""
                            editDependantModal.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                
                        }
                        Button{
                            dependantID = item.dependant_id ?? ""
                            deleteDependantModal.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .vertical])
        }
    }
}

struct AddDependantButton: View {
    @Binding var addDependantModal: Bool

    var body: some View {
        ZStack{
            ZStack(alignment: .center) {
                Capsule()
                    .stroke(Color.medicalRed)
                    .frame(width: 200, height: 35)
                
                Button {
                    addDependantModal.toggle()
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .renderingMode(.template)
                            .foregroundColor(.medicalRed)
                        
                        Text("Add Dependant")
                            .foregroundColor(.medicalRed)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
        }
    }
}

struct SettingsDependantsView: View {
    @State private var addDependantModal: Bool = false
    @State private var editDependantModal: Bool = false
    @State private var deleteDependantModal: Bool = false
    @State private var selectedDependant: String = ""
    @ObservedObject var user: User
    
    var body: some View {
        ZStack {
            VStack {
                Section {
                    Text("Your Dependants")
                        .font(.largeTitle)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                }
                .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(height: 5)
                
                ScrollView {
                    if let count = user.dependants?.count, count > 0 {
                        ForEach(Array(user.dependants!.values), id: \.self) { item in
                            DependantView(item: item, editDependantModal: $editDependantModal, deleteDependantModal: $deleteDependantModal, dependantID: $selectedDependant)
                        }
                    } else {
                        Text("No dependants yet!")
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
                
                AddDependantButton(addDependantModal: $addDependantModal)
            }
            .frame(width: WIDTH)
            .padding(.top, 30)
            
            if addDependantModal {
                CreateDependantPopup(isActive: $addDependantModal, user: user)
            }
            
            if editDependantModal {
                EditDependantPopup(isActive: $editDependantModal, dependantID: $selectedDependant, user: user)
            }
            
            if deleteDependantModal {
                DeleteDependantPopup(isActive: $deleteDependantModal, dependantID: $selectedDependant, user: user)
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

struct SettingsDependantsView_Previews: PreviewProvider {
    struct WrapperView: View {
        @ObservedObject var user: User = User()
        
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
            SettingsDependantsView(user: user)
                .onAppear{ login() }
            
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
