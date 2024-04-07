//
//  CategoriesViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 07/03/2024.
//

import Foundation

@MainActor
class CategoriesViewModel: ObservableObject {
    
    @Published var categories: [Category] = [.selectCategory]
    @Published var displayableCategories: [Category] = []
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
                    self.categories = [.selectCategory]
                    self.displayableCategories = categories
                    self.categories.append(contentsOf: categories)
                case .failure(let error):
                    isLoading = false
                    print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
    func updateCategory(_ category: Category) async {
        
        guard let token = self.userSession else { return }
                
        self.isLoading = true
        let result = await NetworkService.shared.updateCategory(token: token, category: category)
        
        switch result {
        case .success(let updateResponse):
            print("Successfully updated category with ID: \(updateResponse.categoryID)")
            // Consider refreshing your categories list here if necessary
            await fetchCategories()
        case .failure(let error):
            print("Failed to update category: \(error.localizedDescription)")
        }
        self.isLoading = false
    }
    
    func createCategory(_ category: Category) async {
        
        guard let token = self.userSession else { return }
                
        self.isLoading = true
        let result = await NetworkService.shared.createCategory(token: token, category: category)
        
        switch result {
        case .success(let createCategoryResponse):
            print("Category successfully created with ID: \(createCategoryResponse.categoryID)")
            // Optionally refresh your categories list here if necessary
            await fetchCategories()
        case .failure(let error):
            print("Failed to create category: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    func deleteCategory(_ categoryId: Int) async {
        guard let token = self.userSession else { return }
        
        isLoading = true
        let result = await NetworkService.shared.deleteCategory(token: token, categoryId: categoryId)
        
        switch result {
        case .success(_):
            print("Category deleted successfully.")
            // Optionally refresh your categories list here
            await fetchCategories()
        case .failure(let error):
            print("Error deleting category: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
}

