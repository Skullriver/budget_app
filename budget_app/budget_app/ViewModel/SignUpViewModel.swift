//
//  SignUpViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 01/03/2024.
//

import Foundation

class SignupViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    
    @Published var userStartedTypingName: Bool = false
    @Published var userStartedTypingEmail: Bool = false
    @Published var userStartedTypingPassword: Bool = false
    
    func isPasswordValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // criteria in regex.  See http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    func isNameValid() -> Bool {
        return !name.isEmpty
    }
    
    var isSignUpComplete: Bool {
        if !isPasswordValid() ||
            !isEmailValid() || 
            !isNameValid(){
            return false
        }
        return true
    }
    
    var namePrompt: String {
        return userStartedTypingName ? (isNameValid() ? "" : "Name can't be empty") : ""
    }
    
    
    var emailPrompt: String {
        return userStartedTypingEmail ? (isEmailValid() ? "" : "Enter a valid email address") : ""
    }
        
    var passwordPrompt: String {
        return userStartedTypingPassword ? (isPasswordValid() ? "" : "Must be between 8 and 15 characters containing at least one number and one capital letter") : ""
    }
    
    
}
