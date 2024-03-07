//
//  LoginView.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var signupVM = SignupViewModel()
    @FocusState private var focusedField: String?
    
    var body: some View {
    
        NavigationView {
            ScrollView {
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
                            
                            AuthTextField(field: $signupVM.email, sfSymbolName: "envelope", placeHolder: "Email", prompt: "")
                                .focused($focusedField, equals: "email")
                                .onTapGesture {
                                    focusedField = "email"
                                }
                                .padding(.horizontal, 37)
                            
                            AuthTextField(field: $signupVM.password, sfSymbolName: "lock", placeHolder: "Password", prompt: "", isSecure: true)
                                .focused($focusedField, equals: "password")
                                .onTapGesture {
                                    focusedField = "password"
                                }
                                .padding(.top, 1)
                                .padding(.horizontal, 37)
                        }
                        .onAppear(perform: focusFirstField)
                        .onSubmit(focusNextField)
                    }
                    
                    Spacer()
                    
                    Button{
                        Task {
                            try await viewModel.login(email: signupVM.email, password: signupVM.password)
                        }
                    } label: {
                        PrimaryButton(title: "Log in")
                            .padding(.bottom, 35)
                    }
                    .opacity(signupVM.isLogInComplete ? 1 : 0.6)
                    .disabled(!signupVM.isLogInComplete)
                    
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
                
                
            }
            .background(Color.background)
        }
        .navigationBarBackButtonHidden()
    }
    
    func focusFirstField() {
        focusedField = "email"
    }

    func focusNextField() {
        switch focusedField {
        case "email":
            focusedField = "password"
            signupVM.userStartedTypingPassword = true
        case "password":
            focusedField = nil
        case .none:
            break
        case .some(_):
            break
        }
    }
}

#Preview {
    LoginView()
}
