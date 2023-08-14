//
//  AuthViewModel.swift
//  Talky
//
//  Created by Muhammad Rezky on 09/08/23.
//import SwiftUI
import Firebase
import FirebaseStorage

@MainActor
class AuthViewModel: ObservableObject {
    @Published var loggedOut = true
    @Published var viewState = ViewState.empty
    @Published var logMessage = ""
    @Published var email = ""
    @Published var password = ""
    // other variables for registering new user
    @Published var repassword = ""
    @Published var image: UIImage?
    
    @Published var user: ChatUser?
    @Published var fcm: String?
    
    
    init() {
        self.loggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        if(!loggedOut){
            getCurrentUser()
        }
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
    
    
    private func saveUserData() async {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        do {
            let userRef = FirebaseManager.shared.firestore.collection("users").document(uid)
            let userDoc =  try await userRef.getDocument(as: ChatUser.self)
            user = userDoc
            let encodedUser =  try JSONEncoder().encode(userDoc)
            UserDefaults.standard.set(encodedUser, forKey: "xxxx")
        } catch {
            print(error)
        }
    }
    
    func handleSignOut() async {
        do{
            try  FirebaseManager.shared.auth.signOut()
            loggedOut = true
        } catch{
            print(error)
        }
    }
    
    func editProfile( email: String, currPassword: String, newPassword: String, newRePassword: String, onComplete: ()-> ()) async {
        viewState = .loading
        if image != nil{
            await persistImageToStorage()
            await saveUserData()
            getCurrentUser()
            
            
            
        } else {
            viewState = .empty
        }
        if(!currPassword.isEmpty && !newPassword.isEmpty && !newRePassword.isEmpty){
            await resetPassword(email: email, currPassword: currPassword, newPassword: newPassword, newRePassword: newRePassword)
        }else {
            viewState = .empty
        }
        
        onComplete()
    }
    
    private func persistImageToStorage() async {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }


        let metadata =  ref.putData(imageData, metadata: nil)
        
        do {
            let url = try await ref.downloadURL()
            self.logMessage = "Successfully stored image with url: \(url.absoluteString)"
            self.viewState = .loaded
            print("-------")
            print(url.absoluteString)
            await updateUserProfile(uid: uid, updateData: ["profileImageUrl": url.absoluteString])
        } catch {
            self.logMessage = "Failed to retrieve downloadURL: \(error)"
            self.viewState = .error
        }
        
    }

    
    func resetPassword(email: String, currPassword: String, newPassword: String, newRePassword: String) async {
        guard let user = FirebaseManager.shared.auth.currentUser else {
            return
        }
        
        if newPassword != newRePassword {
            viewState = .error
            logMessage = "New Password should same with Confirmation New Password"
            return
        }
        
        viewState = .loading
        let credential = EmailAuthProvider.credential(withEmail: email, password: currPassword)
           
        do {
            try await user.reauthenticate(with: credential)
            try await user.updatePassword(to: newPassword)
            viewState = .loaded
        } catch{
            print(error)
            logMessage = "Error : \(error)"
            viewState = .error
        }
       
    }
    
    func login() async {
        viewState = .loading
        do {
            try await FirebaseManager.shared.auth.signIn(withEmail: email, password: password)
            viewState = .loaded
            logMessage = "Successfully logged in as user: \(FirebaseManager.shared.auth.currentUser?.uid ?? "")"
            loggedOut = false
            await updateUserFCM()
            await saveUserData()
        } catch {
            viewState = .error
            logMessage = "Failed to login user: \(error.localizedDescription)"
        }
    }
    
    func register() async {
        viewState = .loading
        if password != repassword {
            viewState = .error
            logMessage = "Password and Confirmation Password should be same."
            return
        }
        
        do {
            let result = try await FirebaseManager.shared.auth.createUser(withEmail: email, password: password)
            viewState = .loaded
            logMessage = "Successfully created user: \(result.user.uid)"
            await storeUserInformation()
            viewState = .loaded
            loggedOut = false
            await saveUserData()
        } catch {
            viewState = .error
            logMessage = "Failed to create user: \(error.localizedDescription)"
        }
    }
    
    private func uploadProfileImage() async {
        if image == nil {
            viewState = .error
            logMessage = "You must select an avatar image"
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            ref.putData(imageData, metadata: nil)
            let url = try await ref.downloadURL()
            logMessage = "Successfully stored image with url: \(url.absoluteString)"
            let updateData: [String: Any] = ["imageProfileUrl": url.absoluteString]
            
            await updateUserProfile(uid: uid, updateData: updateData)
        } catch {
            viewState = .error
            logMessage = "Failed to push image to Storage: \(error.localizedDescription)"
        }
    }
    
    private func updateUserProfile(uid: String, updateData: [String: Any]) async {
        let userRef = FirebaseManager.shared.firestore.collection("users").document(uid)
        
        do {
            try await userRef.updateData(updateData)
            self.logMessage = "User profile updated with image URL."
            self.viewState = .loaded
        } catch {
            self.logMessage = "Failed to update user profile: \(error.localizedDescription)"
            self.viewState = .error
        }
    }
    
    private func updateUserFCM() async {
        guard let userFCM = PushNotificationManager.getFCM() else {return}
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["fcm" : userFCM]
        
        
        await updateUserProfile(uid: uid, updateData: userData)
        
        
    }

    
    private func storeUserInformation() async {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        if let userFCM = PushNotificationManager.getFCM() {
            fcm = userFCM
        }
        let userData = ["id": uid, "email": email, "uid": uid, "fcm": fcm ?? "", "profileImageUrl": ""]
        
        do {
            try await FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData)
        } catch {
            viewState = .error
            logMessage = error.localizedDescription
        }
    }
}

