//
//  UserClass.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/19/24.
//

import Foundation
//struct Schedule: Codable {
//    var hour: String
//    var minute: String?
//}
//
//struct Meds: Codable {
//    var dosage: String?
//    var Med_id: String
//    var name: String
//    var nickname: String?
//    var schedule: Schedule
//}

class User: Codable, ObservableObject {
    @Published var first_name: String
    @Published var last_name: String
    @Published var medications: [String: Med]?
    @Published var phone: String?
    @Published var user_id: String?
    
    private enum CodingKeys: CodingKey {
        case first_name
        case last_name
        case medications
        case phone
        case user_id
    }
    
    init(first_name: String = "<???>", last_name: String = "<???>", medications: [String : Med]? = nil, phone: String? = nil, user_id: String? = nil) {
        self.first_name = first_name
        self.last_name = last_name
        self.medications = medications
        self.phone = phone
        self.user_id = user_id
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)
        self.medications = try container.decodeIfPresent([String : Med].self, forKey: .medications)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.user_id = try container.decodeIfPresent(String.self, forKey: .user_id)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(first_name, forKey: .first_name)
        try container.encode(last_name, forKey: .last_name)
        try container.encodeIfPresent(medications, forKey: .medications)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(user_id, forKey: .user_id)
    }
    
    var description: String {
        return "UserData(id: \(user_id ?? ""), name: \(first_name) \(last_name), phone: \(phone ?? "")"
    }
}

struct APIResponse: Codable {
    let data: User
    let message: String
    let success: Bool
}

struct POSTApiResponse: Codable {
    let data: String?
    let message: String
    let success: Bool?
}

struct GetUserById: Codable {
    var data: User?
    var message: String
    var success: Bool?
}

struct GetUsers: Codable {
    var data: [User]?
    var message: String
    var success: Bool?
    var next_page: String?
}

struct CreateUser: Codable {
    let data: User?
    let message: String
    let success: Bool?
}
