//
//  EditProfileView.swift
//  Talky
//
//  Created by Muhammad Rezky on 10/08/23.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var email = ""
    @State var currpassword = ""
    @State var password = ""
    @State var repassword = ""
    @State var showPassword = false
    @State var showAlert = false
    @State var shouldShowImagePicker = false
    
    
    var body: some View {
        VStack(spacing: 32){
            ZStack(alignment: .top){
                Rectangle()
                    .frame(height: 150)
                    .foregroundColor(Color("secondary"))
                ZStack(alignment: .bottomTrailing){
                    if(authViewModel.image != nil){
                        Image(uiImage: authViewModel.image!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(16)
                    } else {
                        // Explicitly unwrapping the optional causes previews to crash since there isn't any profile image url present or in app storage. 
                        AsyncImage(url: URL(string: authViewModel.user?.profileImageUrl ?? "")) { phase in
                            switch phase {
                            case .empty:
                                Rectangle()
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(16)
                                    // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                                    .foregroundStyle(Color("secondaryDark"))
                            case .success(let image):
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
                                    // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                                    .foregroundStyle(Color.red)
                                // Handle unknown values using "@unknown default”
                            @unknown default:
                                if #available(iOS 17.0, *) {
                                    // 'ContentUnavailableView' is only available in iOS 17.0 or newer
                                    ContentUnavailableView("", systemImage: "")
                                } else {
                                    fatalError()
                                }
                            }
                        }
                    }
                    
                    Button{
                        shouldShowImagePicker.toggle()
                    } label: {
                        Image(systemName: "camera")
                            // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(Color("primary"))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 32)
                
                
            }
            VStack(alignment: .leading, spacing: 16){
                TextField("Email", text: $email, axis: .vertical)
                    .disabled(true)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                    .padding(.leading, 16)
                    .padding(.vertical, 2)
                    .frame(minHeight: 56)
                    .background(Color("secondary"))
                    .cornerRadius(16)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                    .foregroundStyle(Color.black)
                    .opacity(0.5)
                SecureTextField(placeholder: "Current Password", show: $showPassword, text: $currpassword)
                SecureTextField(placeholder: "New Password", show: $showPassword, text: $password)
                SecureTextField(placeholder: "Confirm New Password", show: $showPassword, text: $repassword)
            }
            .padding(.horizontal, 24)
            Spacer()
        }
        .onAppear{
            email = authViewModel.user?.email ?? ""
        }
        .navigationTitle("Edit Profile")
        .navigationBarItems(
            trailing:
                Button{
                    Task {
                        await authViewModel.editProfile(email: email, currPassword: currpassword, newPassword: password, newRePassword: repassword){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }label : {
                    Text(authViewModel.viewState == .loading ? "Loading..." : "Save")
                }
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text(authViewModel.logMessage))
        }
        .onChange(of: authViewModel.viewState, perform: { newValue in
            if newValue == .error{
                showAlert = true
            }
        })
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $authViewModel.image)
                .ignoresSafeArea()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(AuthViewModel())
    }
}
