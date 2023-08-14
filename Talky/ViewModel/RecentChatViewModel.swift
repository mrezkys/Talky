//
//  ChatViewModel.swift
//  Talky
//
//  Created by Muhammad Rezky on 09/08/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@MainActor
class RecentChatViewModel: ObservableObject {
    @Published var viewState = ViewState.empty
    @Published var logMessage = ""
    @Published var recentMessages = [RecentMessage]()
    @Published var users: [ChatUser] = []
    @Published var selectedChatUser: ChatUser?
    private var firestoreListener: ListenerRegistration?
    
    
    init() {
        fetchRecentMessages()
        fetchAllUser()
    }
    
    func fetchAllUser(){
        users.removeAll()
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    self.logMessage = "Failed to fetch users: \(error)"
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
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener =   FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.viewState = .error
                    self.logMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    print("as-asaojsahhaihiosahsioaoi")
                    print(change.document.data())
                    if let rm = try? change.document.data(as: RecentMessage.self){
                        self.recentMessages.insert(rm, at: 0)
                    }
                    
                    
                    // self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
    
    

    
    
}

