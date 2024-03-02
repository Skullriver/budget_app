//
//  SignUpView.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct SignUpView: View {
    
    enum FocusableField: Hashable {
        case username, email, password
    }
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var signupVM = SignupViewModel()
    
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        
        NavigationView{
            
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
                            
                            AuthTextField(field: $signupVM.name, sfSymbolName: "person", placeHolder: "Name", prompt: signupVM.namePrompt)
                                .onTapGesture {
                                    signupVM.userStartedTypingName = true
                                }
                                .padding(.horizontal, 37)
                            
                            AuthTextField(field: $signupVM.email, sfSymbolName: "envelope", placeHolder: "Email", prompt: signupVM.emailPrompt)
                                .onTapGesture {
                                    signupVM.userStartedTypingEmail = true
                                }
                                .padding(.horizontal, 37)
                            
                            AuthTextField(field: $signupVM.password, sfSymbolName: "lock", placeHolder: "Password", prompt: signupVM.passwordPrompt, isSecure: true)
                                .onTapGesture {
                                    signupVM.userStartedTypingPassword = true
                                }
                                .padding(.horizontal, 37)
                        }
                        .padding(.bottom, 15)
                        
                    }
                    Spacer()
                    
                    Button{
                        Task {
                            try await viewModel.register(username: signupVM.name, email: signupVM.email, password: signupVM.password)
                        }
                    } label: {
                        PrimaryButton(title: "Sign Up")
                            .padding(.bottom, 35)
                    }
                    .opacity(signupVM.isSignUpComplete ? 1 : 0.6)
                    .disabled(!signupVM.isSignUpComplete)
                    
                    
                    HStack {
                        Text("Already a member?")
                            .font(.system(size: 14).monospaced())
                        
                        NavigationLink{
                            LoginView()
                        } label: {
                            Text("Login")
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
//            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarBackButtonHidden()
//        .keyboardAwarePadding()
    }
    
}

#Preview {
    SignUpView()
}

