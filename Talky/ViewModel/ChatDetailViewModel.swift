//
//  ChatDetailViewModel.swift
//  Talky
//
//  Created by Muhammad Rezky on 10/08/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


class ChatDetailViewModel: ObservableObject {
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    
    var firestoreListener: ListenerRegistration?
    
    var chatUser: ChatUser?
    var user: ChatUser?
    
    init(){
        getCurrentUser()
    }
    
    private func getCurrentUser(){
        if let savedData = UserDefaults.standard.data(forKey: "xxxx") {
            do {
                let decodedUser = try JSONDecoder().decode(ChatUser.self, from: savedData)
                user = decodedUser
            } catch {
                print("Error decoding user:", error)
            }
        }
    }
    
    
    
    func fetchMessage(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener =   FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp", descending: false) // Sorting by timestamp in ascending order
        
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen messages: \(error)"
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                    
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        
                        if let data = try? change.document.data(as: ChatMessage.self){
                            self.chatMessages.append(data)
                            
                        }
                        
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData: [String: Any] = [
            "fromId" : fromId,
            "toId" : toId,
            "text" : self.chatText,
            "timestamp": Timestamp()
        ]
        
        document.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
            print ("Successfully saved current user sending message")
        }
        
        let receiver = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        
        receiver.setData(messageData){ error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                
            }
            print ("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage(){
        print("persistsss")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = chatUser?.uid else {return}
        
        
        let document = FirebaseManager.shared.firestore.collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            "fromId" : uid,
            "toId" : toId,
            "text" : self.chatText,
            "timestamp": Timestamp(),
            "profileImageUrl" : self.chatUser?.profileImageUrl ?? "",
            "email" : self.chatUser?.email ?? ""
        ] as [String: Any]
        
        document.setData(data){error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print(self.errorMessage);
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                
            }
        }
        
        // for recipient
        guard let currentUser = FirebaseManager.shared.auth.currentUser else { return }
        
        
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": self.user?.profileImageUrl ?? "",
            "email": currentUser.email!
        ] as [String : Any]
        
        
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
        if  chatUser?.fcm != "" {
            print("executed")
            PushNotificationManager.sendPushNotification(chatUser!.fcm!, username: chatUser!.username, text: self.chatText)
        }
    }
}
