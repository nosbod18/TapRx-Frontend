//
//  ContentView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI

struct MedPreview: View {
    static let height = 80.0
    
    let item: Med

    init(item: Med) {
        self.item = item
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.medicalDarkBlue)
                .frame(height: MedPreview.height)
            
            HStack {
                Text("\(item.schedule?.month ?? "") \(item.schedule?.day_of_month ?? "")")
                    .font(.title3)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.medicalRed)
                    .frame(width: 2, height: MedPreview.height * 0.90)
                
                VStack(alignment: .leading) {
                    Text(item.name ?? "Medication")
                        .foregroundColor(.white)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("\(item.dosage ?? "0")mg")
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
    @ObservedObject var user: User
    
    var body: some View {
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
                if let count = user.meds?.count, count > 0 {
                    ForEach(Array(user.meds!.values), id: \.self) { value in
                        MedPreview(item: value)
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
    }
}

#Preview {
    HomeView(user: User())
}
