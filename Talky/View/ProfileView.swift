//
//  ProfileView.swift
//  Talky
//
//  Created by Muhammad Rezky on 07/08/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var toEditProfile = false


    var body: some View {
        ZStack{
            NavigationLink(destination: EditProfileView(), isActive: $toEditProfile){
                EmptyView()
            }
            VStack{
                Rectangle()
                    .frame(height: 250)
                    .foregroundColor(Color("secondary"))
                Spacer()
            }
            .ignoresSafeArea()
            VStack(spacing: 16){
                Spacer()
                    .frame(height: 32)
                if authViewModel.user?.profileImageUrl != nil {
                    AsyncImage(url: URL(string: authViewModel.user!.profileImageUrl!)) { phase in
                        switch phase {
                        case .empty:
                                Rectangle()
                                .frame(width: 200, height: 200)
                                    .cornerRadius(16)
                                    .foregroundColor(Color("secondaryDark"))                                            case .success(let image):
                            // Display the image
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(16)
                        case .failure:
                            // Error handling view
                            Rectangle()
                                .frame(width: 200, height: 200)
                                .cornerRadius(16)
                                .foregroundColor(.red)
                        }
                    }
                } else {
                    
                    Rectangle()
                        .frame(width: 200, height: 200)
                        .cornerRadius(16)
                        .foregroundColor(Color("secondaryDark"))
                }
                VStack(spacing: 4){
                    Text(authViewModel.user?.username ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(verbatim: authViewModel.user?.email ?? "")
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                }
                Spacer()
                VStack(spacing: 16){
                    Button{
                        toEditProfile.toggle()
                    } label: {
                        HStack{
                            Text("Edit Profile")
                            
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("primary"))
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                    }
                    Button{
                        Task{
                            await authViewModel.handleSignOut()
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        
                    } label: {
                        HStack{
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                            
                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                        .background(Color("secondary"))
                        .cornerRadius(16)
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
