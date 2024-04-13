//
//  Dependents.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/9/24.
//

import Foundation

struct Dependant: Codable {
    var dependant_id: String?
    var first_name: String
    var last_name: String
    var phone: String?
}

struct CreateDependant: Codable {
    var data: Dependant?
    var message: String
    var success: Bool?
}

//decode a get dependant call
typealias GetDependantByID = Dependant

//decode a get dependants list
typealias GetDependants = [String: Dependant]

//decode update dependant response
typealias DeleteDependantById = CreateDependant

//decode delete dependant response
typealias UpdateDependantById = CreateDependant

