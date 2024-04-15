//
//  MainView.swift
//  tap-rx-frontend
//
//  Created by Evan Dobson on 2/2/24.
//

import SwiftUI

let WIDTH = UIScreen.main.bounds.width * 0.90

//let SAMPLE_MedS = [
//    Med(Med_id: "1", name: "Med 1", dosage: "20", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//    Med(Med_id: "2", name: "Med 2", dosage: "40", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//    Med(Med_id: "3", name: "Med 3", dosage: "60", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//    Med(Med_id: "4", name: "Med 4", dosage: "80", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//    Med(Med_id: "5", name: "Med 5", dosage: "80", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//    Med(Med_id: "6", name: "Med 6", dosage: "80", bottleDescription: "Orange Bottle", time: Date(), doctorName: "Dr. No", days: [0, 2, 4]),
//]

struct MainView: View {
    @ObservedObject var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        UserView(user: user)
    }
}

#Preview {
    MainView(user: User())
}
