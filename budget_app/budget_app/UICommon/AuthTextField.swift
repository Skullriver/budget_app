//
//  AuthTextField.swift
//  budget_app
//
//  Created by Alina Novikova on 01/03/2024.
//

import SwiftUI

struct AuthTextField: View {
    
    @Binding var field: String
    
    var sfSymbolName: String
    var placeHolder: String
    var prompt: String
    var isSecure: Bool = false
    
    @State private var hasTyped = false
    @State private var hasFocus = false
    @State private var showPass: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(!prompt.isEmpty ? .red : .text.opacity(0.8))
                    .frame(width: 15, height: 15, alignment: Alignment.center)
                if isSecure {
                    if showPass {
                        TextField(placeHolder, text: $field, onCommit: {
                            self.hasTyped = true
                        })
                            .font(.system(size: 16).monospaced())
                            .autocapitalization(.none)
                            .padding(.vertical, 15)
                            .padding(.leading, 10)
                        Button {
                            showPass.toggle()
                        } label: {
                            Image(systemName: "eye.slash")
                                .foregroundColor(.text.opacity(0.8))
                        }
                    }else{
                        SecureField(placeHolder, text: $field, onCommit: {
                            self.hasTyped = true
                        })
                            .font(.system(size: 16).monospaced())
                            .autocapitalization(.none)
                            .padding(.vertical, 15)
                            .padding(.leading, 10)
                        Button {
                            showPass.toggle()
                        } label: {
                            Image(systemName: "eye")
                                .foregroundColor(.text.opacity(0.8))
                        }
                    }
                    

                }else{
                    TextField(placeHolder, text: $field, onEditingChanged: { editing in
                        self.hasTyped = editing
                        self.hasFocus = editing
                    }, onCommit: {
                        self.hasFocus = false
                        self.hasTyped = true
                    })
                        .keyboardType(.emailAddress)
                        .font(.system(size: 16).monospaced())
                        .autocapitalization(.none)
                        .padding(.vertical, 15)
                        .padding(.leading, 10)
                }
            }
            .padding(.horizontal, 15)
            .background(Color.white)
            .cornerRadius(55)
            .overlay(
                RoundedRectangle(cornerRadius: 55)
                    .stroke(!prompt.isEmpty ? Color.red : Color.text.opacity(0.8), lineWidth: 1)
                
            )
            
            .padding(.bottom, 10)
            HStack {
                if !prompt.isEmpty {
                    Text(prompt)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.system(size: 10).monospaced())
                        .foregroundColor(Color.red)
                        .padding(.bottom, 10)
                }
            }
            .frame(height: 10)
        }
    }
}


struct AuthTextField_Previews: PreviewProvider {
    @State static var txt: String = ""
    static var previews: some View {
        AuthTextField(field: $txt, sfSymbolName: "envelope", placeHolder: "Email", prompt: "test")
        AuthTextField(field: $txt, sfSymbolName: "envelope", placeHolder: "Email", prompt: "test", isSecure: true)
    }
}
