//
//  ContentView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI

struct Medication: Identifiable {
    var id: UUID
    var name: String
    var dosage: Int
    var bottleDescription: String
    var time: Date
}

struct MedicationPreview: View {
    static let height = 80.0
    
    let item: Medication

    init(item: Medication) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedicationPreview.height)
            
            HStack {
                Text(item.time, style: .time)
                    .font(.title3)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(width: 2, height: MedicationPreview.height * 0.90)
                
                VStack(alignment: .leading) {
                    Text(item.name)
                        .foregroundColor(.white)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("\(item.dosage)mg | \(item.bottleDescription)")
                        .foregroundColor(.medicalGrey)
                        .font(.footnote)
                }
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
}

struct HomeView: View {
    @State private var username = "<User>"

    //let medications: [Medication]? = nil
    let medications: [Medication]? = [
        Medication(id: UUID(), name: "Medication 1", dosage: 20, bottleDescription: "Orange Bottle", time: Date()),
        Medication(id: UUID(), name: "Medication 2", dosage: 40, bottleDescription: "Orange Bottle", time: Date()),
        Medication(id: UUID(), name: "Medication 3", dosage: 60, bottleDescription: "Orange Bottle", time: Date()),
        Medication(id: UUID(), name: "Medication 4", dosage: 80, bottleDescription: "Orange Bottle", time: Date()),
        Medication(id: UUID(), name: "Medication 5", dosage: 80, bottleDescription: "Orange Bottle", time: Date()),
        Medication(id: UUID(), name: "Medication 6", dosage: 80, bottleDescription: "Orange Bottle", time: Date()),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Welcome message
                Section {
                    Text("Welcome, \(username)!")
                        .font(.largeTitle)
                        .foregroundColor(.medicalRed)
                        .fontWeight(.black)
                }
                .padding([.top, .bottom], 30)
                
                // Today's medications and date
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
                
                ScrollView {
                    if let meds = medications {
                        ForEach(meds) { item in
                            MedicationPreview(item: item)
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
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: WIDTH)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        LogoView()
                        Spacer()
                        NavigationStack{
                            NavigationLink {
                                SettingsHomeView()
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .resizable()
                                    .frame(width: 25, height: 20)
                                    .foregroundColor(.medicalRed)
                                    .padding(.top, 5)
                            }
                        }
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
