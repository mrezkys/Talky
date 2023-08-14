//
//  ChatView.swift
//  Talky
//
//  Created by Muhammad Rezky on 06/08/23.
//

import SwiftUI

struct RecentChatView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    @State var shouldShowNewMessageScreen = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject private var vm = RecentChatViewModel()
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .bottom){
                VStack{
                    ZStack{
                        Color("secondary")
                            .edgesIgnoringSafeArea(.top)
                        HStack(){
                            VStack(alignment: .leading, spacing: 8){
                                Text("Messages")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Text("\(vm.recentMessages.count) Incoming messages.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("primary"))
                            }
                        }
                        .padding(24)
                    }
                    .frame(height: 98)
                    ScrollView{
                        if(vm.selectedChatUser != nil){
                            NavigationLink(destination: ChatDetailView(chatUser: vm.selectedChatUser!), isActive:  $shouldNavigateToChatLogView){
                                    EmptyView()
                                }
                        }
                        VStack{
                            
                            ForEach(vm.recentMessages, id: \.self) { recentMessage in
                                var _ = print(recentMessage)
                                Button{
                                    vm.selectedChatUser = vm.users.first(where: { ChatUser in
                                       return ChatUser.uid == recentMessage.fromId
                                    })
                                    if(vm.selectedChatUser != nil){
                                        
                                        self.shouldNavigateToChatLogView.toggle()
                                    }
                                } label: {
                                    VStack(spacing: 0){
                                        HStack(spacing: 0){
                                            
                                            if recentMessage.profileImageUrl != nil {
                                                AsyncImage(url: URL(string: recentMessage.profileImageUrl!)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                            Rectangle()
                                                                .frame(width: 64, height: 64)
                                                                .cornerRadius(16)
                                                                .foregroundColor(Color("secondary"))                                            case .success(let image):
                                                        // Display the image
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                        
                                                            .frame(width: 64, height: 64)
                                                            .clipped()
                                                            .cornerRadius(16)
                                                    case .failure:
                                                        // Error handling view
                                                        Rectangle()
                                                            .frame(width: 64, height: 64)
                                                            .cornerRadius(16)
                                                            .foregroundColor(.red)
                                                    }
                                                }
                                            } else {
                                                
                                                Rectangle()
                                                    .frame(width: 64, height: 64)
                                                    .cornerRadius(16)
                                                    .foregroundColor(Color("secondary"))
                                            }
                                            Spacer()
                                                .frame(width: 24)
                                            VStack(alignment: .leading, spacing: 4){
                                                Text(recentMessage.username)
                                                    .font(.body)
                                                    .lineLimit(1)
                                                    .fontWeight(.semibold)
                                                    .multilineTextAlignment(.leading)
                                                Text(recentMessage.text)
                                                    .lineLimit(1)
                                                    .font(.footnote)
                                                    .fontWeight(.light)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing, spacing: 8){
                                                Text(recentMessage.timeAgo)
                                                    .font(.caption2)
                                                    .fontWeight(.light)
                                                    .multilineTextAlignment(.leading)
                                                Rectangle()
                                                    .frame(width: 8, height: 8)
                                                    .cornerRadius(100)
                                                    .foregroundColor(Color("primary"))
                                            }
                                        }
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 16)
                                        Divider()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        
                    }
                }
                Button{
                    shouldShowNewMessageScreen.toggle()
                    
                } label: {
                    HStack{
                        Image(systemName: "text.bubble")
                        Text("New Chat")
                        
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color("primary"))
                    .cornerRadius(16)
                    .padding(16)
                }
                .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
                    NewChatView { chatUser in
                        self.vm.selectedChatUser = chatUser
                        self.shouldNavigateToChatLogView.toggle()
                    }
                }
            }
            .onAppear{
                vm.fetchRecentMessages()
                vm.fetchAllUser()
            }
            .fullScreenCover(isPresented: $authViewModel.loggedOut){
                WelcomeView()
                    .onDisappear{
                        vm.fetchRecentMessages()
                    }
            }
        }
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        RecentChatView()
    }
}
