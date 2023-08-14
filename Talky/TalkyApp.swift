//
//  TalkyApp.swift
//  Talky
//
//  Created by Muhammad Rezky on 24/06/23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
    
}

extension AppDelegate: MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = fcmToken {
            print(fcm, "key")
                PushNotificationManager.saveFCM(fcmToken!)
        }
    }
}


@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject var authViewModel = AuthViewModel()
    @StateObject private var manager = NotificationManager()

    var body: some Scene {
        WindowGroup {
                RecentChatView()
                .onAppear{
                    Task{
                        await manager.request()
                    }
                }
                .environmentObject(authViewModel)
            }
        }
    
}

struct MainView: View {
    @StateObject private var manager = NotificationManager()
    
    func sendPushNotification() {
         let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         // Set the request headers
         request.setValue("key=AAAAMqvz0mI:APA91bHx1daPzvUdYfQMEcoqe6Q6MsxW28blYE9FN-qTzymUZtnTSCFyJrWqoAC43UBoaIeATthY0NpqB5uq_EibbSk7uFfHnOQm0BhpbRlt0NOB0U7OgmZgj-xEzwaDrujwRshkZK-0", forHTTPHeaderField: "Authorization")
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         // Set the request body data
         let bodyData = """
         {
             "to": "cqke-3LT9USzoFp0nY4QhM:APA91bF662-T8EUrFXkm3Dadg9BhENxNLWza_JSwbig2XVz9RMq76nsQXDN49CDAbOWenRkY36MGynlpNKJ9YOleWFO3oSGCRxCV7Hx6pkzNKt8eB2WBJ8FD1al1QcIK7tngfRm3xuos",
             "notification": {
                 "title": "title",
                 "body": "body"
             }
         }
         """.data(using: .utf8)
         
         request.httpBody = bodyData
         
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
    
    var body: some View{
        VStack{
            Button("Request Notification"){
                Task{
                    await manager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(manager.hasPermission)
            .task {
                await manager.getAuthStatus()
            }
            Button("Send Pu"){
                Task{
                    await sendPushNotification()
                }
            }
            .buttonStyle(.bordered)
            .disabled(manager.hasPermission)
            .task {
                await manager.getAuthStatus()
            }
        }
    }
}
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
