//
//  NewChatViewModel.swift
//  Talky
//
//  Created by Muhammad Rezky on 10/08/23.
//


import SwiftUI
import FirebaseFirestoreSwift

class NewChatViewModel: ObservableObject {
    @Published var users: [ChatUser] = []
    @Published var errorMessage = ""
    init() {
    }
    
    func fetchAllUser(){
        users.removeAll()
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                snapshot?.documents.forEach({ snapshot in
                    if let data = try? snapshot.data(as: ChatUser.self){
                        if data.uid != FirebaseManager.shared.auth.currentUser?.uid {
                            self.users.append(data)
                        }
                    }
                   
                })
            }
    }
}
