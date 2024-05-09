//
//  CalendarEventsPopup.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 4/15/24.
//
import Foundation
import SwiftUI
import FirebaseAuth

struct CalendarEventsPopup: View {
    @Binding var isActive: Bool
    @Binding var date: Date

    @State private var userID: String = ""
    @State private var data: String = "loading.."
    
    func get_data(i: MedEvent, completion: @escaping (String) -> Void) {
        // Convert iso8601 to readable format
        let readable = readableISO(from: i.timestamp)
        
        guard let user = Auth.auth().currentUser else {
            completion("")
            return
        }

        guard let url = URL(string: "https://taprx.xyz/medications/\(i.medication_id)") else {
            completion("")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        user.getIDToken { idToken, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion("")
                return
            }
            
            guard let idToken = idToken else {
                completion("")
                return
            }

            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Network error: \(error.localizedDescription)")
                        completion("")
                    }
                    return
                }

                guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                    DispatchQueue.main.async {
                        print("Failed to decode response.")
                        completion("")
                    }
                    return
                }
                
                print("Response String: \(responseString)")
                
                do {
                    let response = try JSONDecoder().decode(GetMedById.self, from: data)
                    DispatchQueue.main.async {
                        let name = response.data?.name ?? ""
                        completion("\(name), \(i.dosage)mg, \(readable)\n")
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion("")
                    }
                }
            }
            task.resume()
        }
    }

    
    func readableISO(from isoDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)  // Adjust as necessary for your use case

        guard let date = dateFormatter.date(from: isoDate) else {
            print("Failed to parse date with custom formatter")
            print(isoDate)
            return ""
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = nil  // Reset to use dateStyle and timeStyle for output

        return dateFormatter.string(from: date)
    }
    
    func iso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    func get_medication_events() {
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
            
            user.getIDToken { (idToken, error) in
                //guard let self = self else { return }
                
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    return
                }
                
                guard let idToken = idToken else {
                    print("Failed to retrieve ID token.")
                    return
                }
                
                var components = URLComponents(string: "https://taprx.xyz/medications/events/users/\(userID)")
                    
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: date)

                var date_components = DateComponents()
                date_components.day = 1
                date_components.second = -1
                let endOfDay = calendar.date(byAdding: date_components, to: startOfDay)!

                let isoFormatter = ISO8601DateFormatter()
                isoFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
                isoFormatter.timeZone = TimeZone.current

                let startTimeString = isoFormatter.string(from: startOfDay)
                let endTimeString = isoFormatter.string(from: endOfDay)

                components?.queryItems = [
                    URLQueryItem(name: "start_at", value: startTimeString),
                    URLQueryItem(name: "end_at", value: endTimeString)
                ]
                
                guard let url = components?.url else { return }
                print("Final URL: \(url)")
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue(idToken, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Network error: \(error.localizedDescription)")
                        } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response String: \(responseString)")
                            do {
                                let response = try JSONDecoder().decode(GetMedEvents.self, from: data)
                                if(response.success == true){
                                    if(response.data != nil){
                                        if let res_data = response.data{
                                            if(res_data.count == 0){
                                                self.data = "No events for this day"
                                            } else {
                                                self.data = ""
                                                for i in res_data {
                                                    get_data(i:i) { resultString in
                                                        self.data += resultString
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        self.data = "No events for this day"
                                    }
                                } else {
                                    print("error with event creation")
                                }
                            } catch {
                                print("Decoding error: \(error)")
                                
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }

    var body: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            VStack {
                    HStack{
                        Spacer()
                        Button{
                            isActive.toggle()
                        } label: {
                            Image(systemName:"xmark.square.fill")
                                .resizable()
                                .frame(width:20,height:20)
                                .foregroundColor(Color.medicalGrey)
                        }
                    }.padding(0)
                    Text("Calendar Events")
                        .font(.title2)
                        .foregroundColor(.medicalDarkBlue)
                        .fontWeight(.black)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.medicalRed)
                        .frame(height: 5)
                        .padding(.bottom,10)
                    
                    
                    HStack {
                        Text(self.data)
                                .font(.subheadline)
                                .foregroundColor(Color.medicalDarkBlue)
                            
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: UIScreen.main.bounds.width*0.8)
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .onAppear {
                    get_medication_events()
                }
                
        }
    }
}

struct CalendarEventsPopup_Previews: PreviewProvider {
    struct WrapperView: View {
        @State private var showSheet = true  // State to control the visibility
        @State private var date = Date.now
        
        func login(){
            Auth.auth().signIn(withEmail: "drewclutes@gmail.com", password: "123456") { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
            }
        }
        var body: some View {
            CalendarEventsPopup(isActive: $showSheet,date: $date).onAppear{
                login()
            }
        }
    }
    
    static var previews: some View {
        WrapperView()  // Embed the view within a wrapper to manage the state
    }
}
