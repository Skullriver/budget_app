//
//  WelcomeView.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationView{
            Color.background
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .overlay(WelcomeContentView(), alignment: .center)
        }
        .accentColor(.text)
        
    }
}

struct WelcomeContentView: View {
    
    @State private var isLoginActive = false
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: .widthPer(per: 0.7))
            Text("SophistiSpend")
                .font(.system(size: 32).monospaced())
                .fontWeight(.medium)
                .foregroundColor(.text)
                .padding(.bottom, 40)
            
            
            NavigationLink{
                SignUpView()
            } label: {
                PrimaryButton(title: "Continue with email")
            }
            
            HStack {
                Text("Already a member?")
                    .font(.system(size: 14).monospaced())
                
                NavigationLink{
                    LoginView()
                } label: {
                    Text("Login")
                        .foregroundColor(.primaryButton)
                        .font(.system(size: 14).monospaced())
                }
               
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .background(Color.background)
    }
    
}

#Preview {
    WelcomeView()
}
