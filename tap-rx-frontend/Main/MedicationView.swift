//
//  MedicationView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI

struct DayView: View {
    static let days = ["m.square", "t.square", "w.square", "t.square", "f.square", "s.square", "s.square"]

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
    static let height = 140.0
    
    let item: Medication
    
    init(item: Medication) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedicationFullview.height)
            
            VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(item.name)
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            Spacer()
                            
                            Button {
                                // Edit, delete
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundStyle(.white)
                                    .padding(.trailing, 10)
                                    .padding(.top, -5)
                            }
                        }
//                        .border(.orange)
                        .frame(maxWidth: .infinity)

                        Text("\(item.time.formatted(date: .omitted, time: .shortened)) | \(item.dosage)mg | \(item.bottleDescription)")
                            .foregroundColor(.medicalGrey)
                            .font(.footnote)
                        
                        Text(item.doctorName)
                            .font(.footnote)
                            .foregroundColor(.medicalGrey)
                    }
//                    .border(.green)
//                .padding(.vertical, 10)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    ForEach(0..<7) { day in
                        DayView(day: day, active: item.days.contains(where: {$0 == day}))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .vertical])
        }
    }
}

struct AddMedicationButton: View {
    var body: some View {
        ZStack(alignment: .center) {
            Capsule()
                .stroke(Color.medicalRed)
                .frame(width: WIDTH * 0.5, height: 35)
            
            Button {
                
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

struct MedicationView: View {
    let medications: [Medication]?
    
    init(with medications: [Medication]?) {
        self.medications = medications
    }
    
    var body: some View {
        NavigationStack {
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
                    if let meds = medications {
                        ForEach(meds) { item in
                            MedicationFullview(item: item)
                        }
                    } else {
                        Text("No medications added")
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
                
                AddMedicationButton()
            }
            .frame(width: WIDTH)
            .padding(.top, -30)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        LogoView()
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.medicalRed)
                            .padding(.top, 5)
                    }
                }
            }
        }
    }
}

#Preview {
    MedicationView(with: SAMPLE_MEDICATIONS)
}
