//
//  RecentMessage.swift
//  Talky
//
//  Created by Muhammad Rezky on 10/08/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct RecentMessage: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String?
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
