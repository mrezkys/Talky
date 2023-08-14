//
//  PushNotificationManager.swift
//  Talky
//
//  Created by Muhammad Rezky on 11/08/23.
//

import Foundation

class PushNotificationManager{
    static func saveFCM(_ key: String){
        UserDefaults.standard.set(key, forKey: "fcm")
    }
    
    static func getFCM() -> String? {
        if let savedData = UserDefaults.standard.string(forKey: "fcm") {
            return "\(savedData)"
        }
        return nil
    }
    
    static func sendPushNotification(_ fcm: String, username: String, text: String) {
            let receiverFCM = fcm
            let serverKey = "AAAAMqvz0mI:APA91bHx1daPzvUdYfQMEcoqe6Q6MsxW28blYE9FN-qTzymUZtnTSCFyJrWqoAC43UBoaIeATthY0NpqB5uq_EibbSk7uFfHnOQm0BhpbRlt0NOB0U7OgmZgj-xEzwaDrujwRshkZK-0"
            
            let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Set the request headers
            request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Set the request body data
            let requestBody: [String: Any] = [
                "to": receiverFCM,
                "notification": [
                    "title": "New message from \(username)",
                    "body": "\(text)"
                ]
            ]
        
        print("--------aaaa")
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
                request.httpBody = jsonData
                
                // Send the request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response: \(responseString)")
                        }
                    }
                }.resume()
            }
        }
}
