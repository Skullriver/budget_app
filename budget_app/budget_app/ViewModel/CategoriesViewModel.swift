//
//  CategoriesViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 07/03/2024.
//

import Foundation

@MainActor
class CategoriesViewModel: ObservableObject {
    
    @Published var categories: [Category] = []
    @Published var isLoading = false
    
    private var userSession: String? {
        AuthViewModel.shared.userSession
    }
    
    func fetchCategories() async {
        if let token = self.userSession {
            isLoading = true
            switch await NetworkService.shared.fetchCategories(token: token) {
                case .success(let categories):
                    isLoading = false
                    self.categories = categories
                case .failure(let error):
                    isLoading = false
                    print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
}
