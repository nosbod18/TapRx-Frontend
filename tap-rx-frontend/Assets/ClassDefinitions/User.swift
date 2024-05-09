//
//  UserClass.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/19/24.
//

import Foundation
import FirebaseAuth

class User: Codable, ObservableObject {
    @Published var first_name: String
    @Published var last_name: String
    @Published var medications: [String: Med]?
    @Published var phone: String?
    @Published var user_id: String?
    @Published var dependants: [String: Dependant]?
    
    private enum CodingKeys: CodingKey {
        case first_name
        case last_name
        case medications
        case phone
        case user_id
        case dependants
    }
    
    init(first_name: String = "<???>", last_name: String = "<???>", medications: [String : Med]? = nil, phone: String? = nil, user_id: String? = nil, dependants: [String: Dependant]? = nil) {
        self.first_name = first_name
        self.last_name = last_name
        self.medications = medications
        self.phone = phone
        self.user_id = user_id
        self.dependants = dependants
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.first_name = try container.decode(String.self, forKey: .first_name)
        self.last_name = try container.decode(String.self, forKey: .last_name)
        self.medications = try container.decodeIfPresent([String : Med].self, forKey: .medications)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.user_id = try container.decodeIfPresent(String.self, forKey: .user_id)
        self.dependants = try container.decodeIfPresent([String: Dependant].self, forKey: .dependants)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(first_name, forKey: .first_name)
        try container.encode(last_name, forKey: .last_name)
        try container.encodeIfPresent(medications, forKey: .medications)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(user_id, forKey: .user_id)
        try container.encodeIfPresent(dependants, forKey: .dependants)
    }
    
    var description: String {
        return "UserData(id: \(user_id ?? ""), name: \(first_name) \(last_name), phone: \(phone ?? "")"
    }
    
    func update(with data: User) {
        self.first_name = data.first_name
        self.last_name = data.last_name
        self.medications = data.medications
        self.phone = data.phone
        self.user_id = data.user_id
        self.dependants = data.dependants
    }
    
    
    
    func clear(){
        self.first_name = ""
        self.last_name = ""
        self.medications = nil;
        self.dependants = nil;
        self.phone = nil;
        self.user_id = nil;
    }
    
    func populate_user(){
        //print("populate user called")
        guard let user = Auth.auth().currentUser else { return }
        
        let postData: [String: Any] = [
            "first_name": self.first_name,
            "last_name": self.last_name,
            "phone": self.phone ?? "",
            "user_id": self.user_id ?? "",
            //"medications": self.medications ?? [],
        ]
        
        user.getIDToken { (idToken, error) in
            //guard let self = self else { return }
            
            //print("HERE")
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            //print("HERE")
            guard let idToken = idToken else {
                print("Failed to retrieve ID token.")
                return
            }
            //print("HERE")
            if let user_id = self.user_id {
                //("HERE")
                let url = URL(string: "https://taprx.xyz/users/\(user_id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue(idToken, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                //print("HERE")
                do {
                    //print("BEFORE")
                    //print("Post Data to serialize: \(postData)")

                    let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
                    request.httpBody = jsonData
                    
                    //print("TEST")
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        DispatchQueue.main.async {
                            if let error = error {
                                print("Network error: \(error.localizedDescription)")
                            } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                                //print("HERE")
                                print("Response String: \(responseString)")
                                do {
                                    //print("HERE")
                                    let response = try JSONDecoder().decode(CreateUser.self, from: data)
                                    print(response)
                                } catch {
                                    print("Decoding error: \(error)")
                                }
                            }
                        }
                    }
                    task.resume()
                } catch {
                    print("Error serializing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func refresh() {
        guard let user = Auth.auth().currentUser else { return }
        
        let url = URL(string: "https://taprx.xyz/users/\(user.uid)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        user.getIDToken { idToken, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = idToken else {
                return
            }
            
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Network error: \(error.localizedDescription)")
                    }
                    return
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response String: \(responseString ?? "nil")")
                    
                    do {
                        let response = try JSONDecoder().decode(APIResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            if response.success {
                                self.update(with: response.data)
                            }
                        }
                        
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            }
            
            task.resume()
        }
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
