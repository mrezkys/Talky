//
//  WelcomeView.swift
//  Talky
//
//  Created by Muhammad Rezky on 08/08/23.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("secondary").ignoresSafeArea()
                VStack{
                    VStack{
                        Spacer()
                    }
                    .overlay {
                        ZStack{
                            Image("shots").padding(.top, 144)
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
                        VStack(spacing:16) {
                            NavigationLink {
                                RegisterxView()
                            } label: {
                                HStack {
                                    Text("Start Messaging")
                                        .padding(.vertical, 20)
                                        .frame(maxWidth: .infinity)
                                    // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                                        .foregroundStyle(Color.white)
                                        .background(Color("primary"))
                                        .cornerRadius(16)
                                }
                            }
                            NavigationLink {
                                LoginxView()
                            } label: {
                                HStack {
                                    Text("Already have an account?")
                                    // `foregroundColor` has been renamed to `foregroundStyle` and will be deprecated in a future version of iOS
                                        .foregroundStyle(Color("secondaryDark"))
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
