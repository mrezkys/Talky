//
//  FirebaseManager.swift
//  Talky
//
//  Created by Muhammad Rezky on 25/06/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
//    let storage: Storage
    
    static let shared = FirebaseManager()
    
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
    
}
