//
//  MedicationView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI

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
    var body: some View {
        AddMedicationButton()
    }
}

#Preview {
    MedicationView()
}
