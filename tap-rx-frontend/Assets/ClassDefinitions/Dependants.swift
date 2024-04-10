//
//  Dependents.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import Foundation

struct Dependant: Codable {
    var first_name: String
    var last_name: String
    var phone: String
}

struct CreateDependant: Codable {
    var data: Dependant?
    var message: String
    var success: Bool?
}

struct GetDependants: Codable {
    var data: [String : Dependant]?
    var message: String
    var success: Bool
    var total: Int?
}
