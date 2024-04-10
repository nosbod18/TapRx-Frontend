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
//struct Medications: Codable {
//    var dosage: String?
//    var medication_id: String
//    var name: String
//    var nickname: String?
//    var schedule: Schedule
//}

struct User: Codable {
    var first_name: String
    var last_name: String
    var medications: [String:Med]?
    var phone: String?
    var user_id: String?
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
