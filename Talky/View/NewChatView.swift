//
//  NewChatView.swift
//  Talky
//
//  Created by Muhammad Rezky on 07/08/23.
//

import SwiftUI

struct NewChatView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = NewChatViewModel()
    
    let didSelectNewUser: (ChatUser) -> ()
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button{
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        VStack(spacing: 0){
                            HStack(spacing: 0){
                                
                                if user.profileImageUrl != nil {
                                    AsyncImage(url: URL(string: user.profileImageUrl!)) { phase in
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
                                                .background(.red)
                                        }
                                    }
                                } else {
                                    
                                    Rectangle()
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(16)
                                        .background(Color("secondary"))
                                }
                                Spacer()
                                    .frame(width: 24)
                                VStack(alignment: .leading, spacing: 4){
                                    Text(user.email)
                                        .font(.body)
                                        .lineLimit(1)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
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
            
                .onAppear{
                    vm.fetchAllUser()
                }
            .navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
                
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(didSelectNewUser: {_ in })
    }
}
