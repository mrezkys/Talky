//
//  WelcomeView.swift
//  Talky
//
//  Created by Muhammad Rezky on 08/08/23.
//

import SwiftUI

struct WelcomeView: View {
    @State var toRegister = false
    @State var toLogin = false
    var body: some View {
        NavigationView{
            ZStack{
                Color("secondary").ignoresSafeArea()
                
                NavigationLink(destination: LoginxView(), isActive: $toLogin){
                    EmptyView()
                }
                NavigationLink(destination: RegisterxView(), isActive: $toRegister){
                    EmptyView()
                }
                VStack{
                        VStack{
                            Spacer()
                        }
                        .overlay {
                            ZStack{
                                Image("shots")
                                    .padding(.top, 144)
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
                    VStack(alignment: .center, spacing: 32){
                            Text("Connect with Talky")
                                .font(.title)
                                .fontWeight(.bold)
                        VStack(spacing:16){
                            Button{
                                toRegister.toggle()
                            } label: {
                                HStack{
                                    Text("Start Messaging")
                                    
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color("primary"))
                                .cornerRadius(16)
                            }
                            Button{
                                toLogin.toggle()
                            } label: {
                                HStack{
                                    Text("Already have account?")
                                        .foregroundColor(Color("secondaryDark"))
                                    Text("Log in")
                                    
                                }
                            }
                        }
                    }
                    .padding([.horizontal, .bottom], 24)
                    .padding(.top, 42)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
