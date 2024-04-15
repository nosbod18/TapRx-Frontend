//
//  UserClass.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/19/24.
//

import Foundation

struct Schedule: Codable {
    var days: [Int]
    var time: Date
}

class Medication: Codable, Hashable {
    var dosage: String
    var medication_id: String
    var name: String
    var nickname: String?
    var schedule: Schedule
    var bottle_description: String
    var doctorName: String
    
    private enum CodingKeys: String, CodingKey {
        case dosage
        case medication_id
        case name
        case nickname
        case schedule
        case bottle_description
        case doctorName
    }

    static func == (lhs: Medication, rhs: Medication) -> Bool {
        lhs.medication_id == rhs.medication_id
    }
    
    init(dosage: String = "", medication_id: String = "", name: String = "", nickname: String? = nil, schedule: Schedule = Schedule(days: [], time: Date()), bottle_description: String = "", doctorName: String = "") {
        self.dosage = dosage
        self.medication_id = medication_id
        self.name = name
        self.nickname = nickname
        self.schedule = schedule
        self.bottle_description = bottle_description
        self.doctorName = doctorName
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dosage = try values.decode(String.self, forKey: .dosage)
        medication_id = try values.decode(String.self, forKey: .medication_id)
        name = try values.decode(String.self, forKey: .name)
        nickname = try values.decode(String?.self, forKey: .nickname)
        schedule = try values.decode(Schedule.self, forKey: .schedule)
        bottle_description = try values.decode(String.self, forKey: .bottle_description)
        doctorName = try values.decode(String.self, forKey: .doctorName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dosage, forKey: .dosage)
        try container.encode(medication_id, forKey: .medication_id)
        try container.encode(name, forKey: .name)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(bottle_description, forKey: .bottle_description)
        try container.encode(doctorName, forKey: .doctorName)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(medication_id)
    }
}

class Patient: Codable, ObservableObject {
    @Published var first_name: String
    @Published var last_name: String
    @Published var medications: [String: Medication]
    @Published var phone: String
    @Published var user_id: String
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case medications
        case phone
        case user_id
    }
    
    init(first_name: String = "", last_name: String = "", medications: [String: Medication] = [:], phone: String = "", user_id: String = "") {
        self.first_name = first_name
        self.last_name = last_name
        self.medications = medications
        self.phone = phone
        self.user_id = user_id
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try values.decode(String.self, forKey: .first_name)
        last_name = try values.decode(String.self, forKey: .last_name)
        phone = try values.decode(String.self, forKey: .phone)
        user_id = try values.decode(String.self, forKey: .user_id)
        
        if let medications = try? values.decode([String: Medication].self, forKey: .medications) {
            self.medications = medications
        } else {
            self.medications = [:]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(first_name, forKey: .first_name)
        try container.encode(last_name, forKey: .last_name)
        try container.encode(medications, forKey: .medications)
        try container.encode(phone, forKey: .phone)
        try container.encode(user_id, forKey: .user_id)
    }
}

struct APIResponse: Codable {
    let data: Patient
    let message: String
    let success: Bool
}

struct POSTApiResponse: Codable {
    let data: String?
    let message: String
    let success: Bool?
}
