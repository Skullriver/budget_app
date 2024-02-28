//
//  AuthViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: String?
    @Published var currentUser: User?
    
    init() {
        self.userSession = UserDefaults.standard.string(forKey: "userSession")
        
        Task {
            await fetchUser()
        }
    }
    
    func register(username: String, email: String,  password: String) async throws{
        let result = await NetworkService.shared.register(username: username, email: email, password: password)
            switch result {
            case .success(let token):
                print("Registration successful. Token: \(token)")
                // Handle successful registration
                self.userSession = token
                await fetchUser()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                // Handle failure
            }
    }
    
    func fetchUser() async {
        if let token = self.userSession {
            switch await NetworkService.shared.getUser(token: token) {
                case .success(let user):
                    self.currentUser = user
                case .failure(let error):
                    self.userSession = nil
                    print("Error fetching user: \(error.localizedDescription)")
                }
        }
    }
    
}
