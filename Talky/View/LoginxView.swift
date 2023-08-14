//
//  LoginView.swift
//  Talky
//
//  Created by Muhammad Rezky on 08/08/23.
//

import SwiftUI

struct LoginxView: View {
    @State var showAlert = false
    @State private var showPassword = false
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        ZStack{
            Color("secondary").ignoresSafeArea()
            VStack{
                    VStack{
                        Spacer()
                    }
                    .overlay {
                        ZStack{
                            Image("shots")
                            LinearGradient(
                            stops: [
                            Gradient.Stop(color: Color(red: 0.93, green: 0.94, blue: 0.97).opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.93, green: 0.94, blue: 0.97), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        }
                    }
                VStack(alignment: .leading, spacing: 24){
                    VStack(alignment: .leading, spacing: 8){
                        Text("Login")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("You need lo login first.")
                            .font(.body)
                            .foregroundColor(Color("secondaryDark"))
                    }
                    VStack(alignment: .leading, spacing: 16){
                        TextField("Email", text: $authViewModel.email, axis: .vertical)
                            .autocorrectionDisabled(true)
                            .keyboardType(.emailAddress)
                            .padding(.leading, 16)
                            .padding(.vertical, 2)
                            .frame(minHeight: 56)
                            .background(Color("secondary"))
                            .cornerRadius(16)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .foregroundColor(.black)
                        SecureTextField(placeholder: "Password", show: $showPassword, text: $authViewModel.password)
                    }
                    Button{
                        
                    } label: {
                        HStack{
                            Spacer()
                            Text("Forgot Password?")
                            
                        }
                        .foregroundColor(Color("primary"))
                    }
                    Button{
                        Task{
                            await
                            authViewModel.login()
                        }
                    } label: {
                        HStack{
                            Text(authViewModel.viewState == .loading ? "Loading..." : "Sign in")

                        }
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("primary"))
                        .cornerRadius(16)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(authViewModel.logMessage))
                    }
                }
                .padding([.horizontal, .bottom], 24)
                .padding(.top, 42)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
            }
        }
        .onChange(of: authViewModel.viewState, perform: { newValue in
            if newValue == .error{
                showAlert = true
            }
        })
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoginxView_Previews: PreviewProvider {
    static var previews: some View {
        LoginxView()
    }
}
