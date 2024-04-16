//
//  SettingsHistoryView.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/2/24.
//

import SwiftUI

struct SettingsHistoryView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            Text("Account History")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.medicalDarkBlue)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.medicalRed)
                .frame(height: 5)
                .padding(.top,-10)
                .padding(.bottom,5)

            
            VStack {
              //Text("Selected date is: \(selectedDate)")

              DatePicker("Select a date", selection: $selectedDate,displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            }
            Spacer()
        }
        .frame(width: WIDTH)
        .padding(.top, 30)
    }
}

#Preview {
    SettingsHistoryView()
}
