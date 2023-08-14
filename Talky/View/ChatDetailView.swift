//
//  ChatDetailView.swift
//  Talky
//
//  Created by Muhammad Rezky on 06/08/23.
//

import SwiftUI

struct ChatDetailView: View {
    @StateObject var vm: ChatDetailViewModel = ChatDetailViewModel()
    var chatUser: ChatUser
    static let emptyScrollToString = "Empty"
    
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
    }
    
    var body: some View {
        ZStack{
            Color("secondary")
                .ignoresSafeArea()
                .onAppear{
                    
                    vm.chatUser = chatUser
                    vm.fetchMessage()
                }
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack{
                        ForEach(vm.chatMessages) { message in
                            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                                HStack{
                                    Spacer()
                                    Text(message.text)
                                        .fontWeight(.regular)
                                        .lineSpacing(4)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.trailing)
                                        .padding(16)
                                    
                                        .background(Color("primary"))
                                        .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.70, alignment: .trailing)
                                        .foregroundColor(.white)
                                }
                            } else {
                                HStack{
                                    Text(message.text)
                                        .fontWeight(.regular)
                                        .lineSpacing(4)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                        .padding(16)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(16, corners: [.topRight, .bottomLeft, .bottomRight])
                                        .frame(maxWidth: UIScreen.main.bounds.width * 0.70, alignment: .leading)
                                    Spacer()
                                }
                            }
                        }
                        
                        HStack{ Spacer() }
                            .padding(.bottom, 100)
                            .id(Self.emptyScrollToString)
                    }
                    
                    .padding(24)
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
            VStack{
                Spacer()
                chatBar
            }
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack{
                    ForEach(vm.chatMessages) { message in
                        
                        if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                        } else {
                            HStack {
                                HStack {
                                    Text(message.text)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                Spacer()
                            }
                        }
                    }
                    
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onReceive(vm.$count) { _ in
                        withAnimation(.easeOut(duration: 0.5)) {
                            scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                    HStack{ Spacer() }
                        .padding(.bottom,64)
                        .id(Self.emptyScrollToString)
                }
            }
            
            HStack{ Spacer() }
                .frame(height: 50)
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    var chatBar: some View{
        HStack(alignment: .bottom, spacing: 16){
            TextField("write a message...", text: $vm.chatText, axis: .vertical)
                .padding(.leading, 16)
                .padding(.vertical, 2)
                .frame(minHeight: 56)
                .background(Color("secondary"))
                .cornerRadius(16)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            if(vm.chatText.isEmpty){
                HStack(spacing: 8){
                    Button{} label: {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                            .frame(maxWidth: 56, maxHeight: 56)
                            .background(Color("secondary"))
                            .cornerRadius(16)
                            .foregroundColor(.black)
                    }
                    Button{} label: {
                        Image(systemName: "mic")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(16)
                            .frame(maxWidth: 56, maxHeight: 56)
                            .background(Color("primary"))
                            .cornerRadius(16)
                            .foregroundColor(.white)
                    }
                }
            } else {
                Button{
                    vm.handleSend()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(16)
                        .frame(maxWidth: 56, maxHeight: 56)
                        .background(Color("primary"))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

//struct ChatDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatDetailView(vm: ChatLogViewModel(chatUser: nil))
//    }
//}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
