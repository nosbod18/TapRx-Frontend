//
//  MedView.swift
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

struct MedFullview: View {
    static let height = 140.0
    
    let item: Med
    
    init(item: Med) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedFullview.height)
            
            VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(item.name ?? item.nickname ?? "<???>")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundStyle(.white)
                                    .padding(.trailing, 10)
                                    .padding(.top, -5)
                            }
                            
                        }
//                        .border(.orange)
                        .frame(maxWidth: .infinity)

                        Text("\(item.schedule?.hour ?? "??"):\(item.schedule?.minute ?? "??") | \(item.dosage ?? "0")mg")
                            .foregroundColor(.medicalGrey)
                            .font(.footnote)
                        
//                        Text(item.doctorName)
//                            .font(.footnote)
//                            .foregroundColor(.medicalGrey)
                    }
//                    .border(.green)
//                .padding(.vertical, 10)
                
                Spacer()
                
                // TODO: Get active days from schedule
                HStack(alignment: .bottom) {
                    ForEach(0..<7) { day in
                        DayView(day: day, active: false)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
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
                    .frame(width: WIDTH * 0.5, height: 35)
                
                Button {
                    addMedModal.toggle()
                    print("button clicked: \(self.addMedModal)")
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

struct MedView: View {
    @State private var addMedModal: Bool = false
    @ObservedObject var user: User
    
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
                    if let count = user.meds?.count, count > 0 {
                        ForEach(Array(user.meds!.values), id: \.self) { item in
                            MedFullview(item: item)
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
                AboutMedicationPopup(isActive: $addMedModal)
            }
        }
    }
}

#Preview {
    MedView(user: User())
}
