//
//  Meds.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import Foundation

struct Med: Codable, Hashable {
    var user_id: String?
    var med_id: String?
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
        
        func dayNumber() -> Int {
            guard let day = day_of_week else { return 7 }
            
            switch day {
            case "Monday": return 0
            case "Tuesday": return 1
            case "Wednesday": return 2
            case "Thursday": return 3
            case "Friday": return 4
            case "Saturday": return 5
            case "Sunday": return 6
            default: return 7
            }
        }
    }
    
    static func == (lhs: Med, rhs: Med) -> Bool {
        lhs.med_id == rhs.med_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(med_id)
    }
}

struct GetMeds: Codable {
    var data: [Med]?
    var message: String
    var success: Bool
    var total: Int?
}

struct CreateMed: Codable {
    var data: Med?
    var message: String
    var success: Bool?
}

struct GetMedById: Codable {
    var data: [Med]?
    var message: String
    var success: Bool?
}

struct DeleteMedById: Codable {
    var data: [Med]?
    var message: String
    var success: Bool?
}
