//
//  MainView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI

let WIDTH = UIScreen.main.bounds.width * 0.90

let SAMPLE_MEDICATIONS = [
    Medication(id: UUID(), name: "Medication 1", dosage: 20, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
    Medication(id: UUID(), name: "Medication 2", dosage: 40, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
    Medication(id: UUID(), name: "Medication 3", dosage: 60, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
    Medication(id: UUID(), name: "Medication 4", dosage: 80, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
    Medication(id: UUID(), name: "Medication 5", dosage: 80, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
    Medication(id: UUID(), name: "Medication 6", dosage: 80, bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
]

struct MainView: View {
    var body: some View {
        UserView()
    }
}

#Preview {
    MainView()
}
