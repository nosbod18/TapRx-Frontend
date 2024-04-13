//
//  MedEvents.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/12/24.
//

import Foundation

struct MedEvent: Codable {
    var dosage: String
    var medication_event_id: String
    var medication_id: String
    var timestamp: String
    var user_id: String
}

struct CreateMedEvent: Codable {
    var data: MedEvent?
    var message: String
    var success: Bool?
}

struct GetMedEvents: Codable {
    var data: [MedEvent]?
    var message: String
    var next_token: String?
    var success: Bool?
}

typealias GetMedEventsByUser = GetMedEvents

struct DeleteMedEvent: Codable {
    var message: String
    var success: Bool
}

typealias UpdateMedEvent = DeleteMedEvent
