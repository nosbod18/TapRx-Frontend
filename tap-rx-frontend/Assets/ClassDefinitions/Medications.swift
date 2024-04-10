//
//  Medications.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import Foundation

struct Med: Codable {
    var user_id: String?
    var medication_id: String?
    var name: String?
    var nickname: String?
    var dosage: String?
    var schedule: Schedule?
    
    struct Schedule: Codable {
        var day_of_month: String?
        var day_of_week: String?
        var month: String?
        var hour: String
        var minute: String
    }
}

struct GetMedications: Codable {
    var data: [Med]?
    var message: String
    var success: Bool
    var total: Int?
}

struct CreateMedication: Codable {
    var data: Med?
    var message: String
    var success: Bool?
}

struct GetMedicationById: Codable {
    var data: [Med]?
    var message: String
    var success: Bool?
}

struct DeleteMedicationById: Codable {
    var data: [Med]?
    var message: String
    var success: Bool?
}
