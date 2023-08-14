//
//  SecureTextFieldView.swift
//  Talky
//
//  Created by Muhammad Rezky on 09/08/23.
//

import SwiftUI

struct SecureTextField: View {
    var placeholder: String
    @Binding var show: Bool
    @Binding var text: String
    
    var body: some View {
        if show{
            TextField(placeholder, text: $text, axis: .vertical)
                .padding(.leading, 16)
                .padding(.vertical, 2)
                .frame(minHeight: 56)
                .background(Color("secondary"))
                .cornerRadius(16)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .foregroundColor(.black)
                .overlay(
                    Button(action: {
                        show.toggle()
                    }) {
                        Image(systemName: show ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 16),
                    alignment: .trailing
                )
        } else {
            SecureField(placeholder, text: $text)
                
                .padding(.leading, 16)
                .padding(.vertical, 2)
                .frame(minHeight: 56)
                .background(Color("secondary"))
                .cornerRadius(16)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .foregroundColor(.black)
                .overlay(
                    Button(action: {
                        show.toggle()
                    }) {
                        Image(systemName: show ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 16),
                    alignment: .trailing
                )
        }
    }
}

