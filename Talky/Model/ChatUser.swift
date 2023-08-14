//
//  ChatUser.swift
//  Talky
//
//  Created by Muhammad Rezky on 25/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email: String
    let profileImageUrl: String?
    let fcm: String?
    
    var username: String {
        guard let atIndex = email.firstIndex(of: "@") else {
            return email
        }
        return String(email[..<atIndex])
    }
    
    // Custom initializer
    init(id: String? = nil, uid: String, email: String, profileImageUrl: String? = nil, fcm: String? = nil) {
        self.id = id
        self.uid = uid
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.fcm = fcm
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case profileImageUrl
        case fcm
    }
    
    
    // Custom init(from:) function that decodes the id property using the Firestore.Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode the DocumentID property using the Firestore.Decoder
        if let idContainer = try? decoder.container(keyedBy: CodingKeys.self),
           let id = try? idContainer.decode(String.self, forKey: .id) {
            self.id = id
        }
        uid = try container.decode(String.self, forKey: .uid)
        email = try container.decode(String.self, forKey: .email)
        profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        fcm = try container.decode(String.self, forKey: .fcm)
        
    }
    
    // Custom encode function that encodes the DocumentID property using the Firestore.Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Encode the DocumentID property using the Firestore.Encoder
        if let id = id {
            let firestoreEncoder = Firestore.Encoder()
            let something = try firestoreEncoder.encode(["id":id])

            if let mapId = something["id"] as? String {
                try container.encode(mapId, forKey: .id)
            }
        }
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(fcm, forKey: .fcm)
        //
                
    }
    
    static func fromRecentMessage(_ data: RecentMessage) -> ChatUser{
        let uid = FirebaseManager.shared.auth.currentUser?.uid == data.fromId ? data.toId : data.fromId
        return  ChatUser.init(id: uid, uid: uid, email: data.email, profileImageUrl: data.profileImageUrl)
    }
}
