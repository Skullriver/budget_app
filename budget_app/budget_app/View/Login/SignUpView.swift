//
//  SignUpView.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var signupVM = SignupViewModel()
    
    @FocusState private var focusedField: String?
    
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
                                .focused($focusedField, equals: "name")
                                .onTapGesture {
                                    signupVM.userStartedTypingName = true
                                    focusedField = "name"
                                }
                                .padding(.horizontal, 37)
                            
                            AuthTextField(field: $signupVM.email, sfSymbolName: "envelope", placeHolder: "Email", prompt: signupVM.emailPrompt)
                                .focused($focusedField, equals: "email")
                                .onTapGesture {
                                    signupVM.userStartedTypingEmail = true
                                    focusedField = "email"
                                }
                                .padding(.horizontal, 37)
                            
                            AuthTextField(field: $signupVM.password, sfSymbolName: "lock", placeHolder: "Password", prompt: signupVM.passwordPrompt, isSecure: true)
                                .focused($focusedField, equals: "password")
                                .onTapGesture {
                                    signupVM.userStartedTypingPassword = true
                                    focusedField = "password"
                                }
                                .padding(.top, 1)
                                .padding(.horizontal, 37)
                        }
                        .onAppear(perform: focusFirstField)
                        .onSubmit(focusNextField)
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
            
        }
        .navigationBarBackButtonHidden()
    }
    
    func focusFirstField() {
        focusedField = "name"
        signupVM.userStartedTypingName = true
    }

    func focusNextField() {
        switch focusedField {
        case "name":
            focusedField = "email"
            signupVM.userStartedTypingEmail = true
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


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
        SignUpView().preferredColorScheme(.dark)
    }
}

