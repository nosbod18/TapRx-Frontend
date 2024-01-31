//
//  ContentView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 1/30/24.
//

import SwiftUI

struct Medicine: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var dosage: Int
    var time: Date
}

struct MedicinePreview: View {
    let dateFormatter = DateFormatter()
    let item: Medicine

    init(item: Medicine) {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        self.item = item
    }
    
    var body: some View {
        HStack {
            Text(item.time, style: .time).font(.system(size: 14))
            VStack {
                Text(item.name)
                Text("\(item.dosage)mg")
            }
        }
    }
}

struct ContentView: View {
    let medications = [
        Medicine(id: UUID(), name: "Medicine 1", dosage: 20, time: Date()),
        Medicine(id: UUID(), name: "Medicine 2", dosage: 40, time: Date()),
        Medicine(id: UUID(), name: "Medicine 3", dosage: 60, time: Date()),
        Medicine(id: UUID(), name: "Medicine 4", dosage: 80, time: Date()),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("{Logo}")
                Spacer()
                Text("{User Icon}")
            }
            .padding()
            
            Text("Welcome, {User}!")
                .font(.title)
                .bold()
            
            Text("Today's Medications:")
                .font(.title2)
            
            Text("----------------------------")
            Text("{Date}")
            
            List {
                ForEach(medications) { item in
                    MedicinePreview(item: item)
                }
                Text("Add Medication")
            }
            .listStyle(.plain)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    Text("{Medicine}")
                    Spacer()
                    Text("{Home}")
                    Spacer()
                    Text("{Calendar}")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
