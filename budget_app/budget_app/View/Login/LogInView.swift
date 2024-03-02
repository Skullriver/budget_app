//
//  LoginView.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginActive = false
    @State private var isSignUpActive = false
    
    var body: some View {
    
        NavigationView {
            VStack {
                
                Spacer()
                
                VStack {
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .widthPer(per: 0.6))
                        .padding(.top, 10)
                    Text("SophistiSpend")
                        .font(.system(size: 32).monospaced())
                        .fontWeight(.medium)
                        .foregroundColor(.text)
                        .padding(.bottom, 40)
                    
                    
                    VStack {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.text.opacity(0.8))
                                .frame(width: 15, height: 15, alignment: Alignment.center)
                            TextField("Email", text: $email)
                                .font(.system(size: 16).monospaced())
                                .autocapitalization(.none)
                                .padding(.vertical, 15)
                                .padding(.leading, 10)
                        }
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 55)
                                .stroke(Color.text.opacity(0.8), lineWidth: 1)
                        )
                        .padding(.horizontal, 37)
                        .padding(.bottom, 20)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.text.opacity(0.8))
                                .frame(width: 15, height: 15, alignment: Alignment.center)
                            SecureField("Password", text: $password)
                                .font(.system(size: 16).monospaced())
                                .padding(.vertical, 15)
                                .padding(.leading, 10)
                        }
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 55)
                                .stroke(Color.text.opacity(0.8), lineWidth: 1)
                        )
                        .padding(.horizontal, 37)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
                
                NavigationLink{
                    
                } label: {
                    PrimaryButton(title: "Log in")
                        .padding(.bottom, 35)
                }
                
                HStack {
                    Text("Not a member?")
                        .font(.system(size: 14).monospaced())
                    
                    NavigationLink{
                        SignUpView()
                    } label: {
                        Text("Sign up")
                            .font(.system(size: 14).monospaced())
                            .foregroundColor(.primaryButton)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
                Spacer()
            }
            .background(Color.background)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView()
}