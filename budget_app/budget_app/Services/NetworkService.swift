//
//  NetworkService.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case invalidData
    case badResponse(statusCode: Int)
}

enum AuthenticationError: Error {
    case invalidURL
    case invalidCredentials
    case encodingError
    case networkError
    case userNotFound
    case custom(errorMessage: String)
}

struct RegisterRequestBody: Codable {
    let username: String
    let email: String
    let password: String
}

struct LoginRequestBody: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String?
    let message: String?
    let success: Bool?
}

struct CreateCategoryRequest: Codable {
    let name: String
    let icon: String
    let color: String
}

struct CreateCategoryResponse: Codable {
    let categoryID: Int64
}

struct UpdateCategoryResponse: Codable {
    let categoryID: Int64
}

struct CreateWalletRequest: Codable {
    let name: String
    let currency: String
    let initial_balance: Int
    let icon: String
    let color: String
}

struct CreateWalletResponse: Codable {
    let walletID: Int64
}

struct UpdateWalletResponse: Codable {
    let walletID: Int64
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func register(username: String, email: String, password: String) async -> Result<String, AuthenticationError> {
        
        guard let url = URL(string: "http://localhost:8080/user/register") else {
            return .failure(.invalidURL)
        }
        
        let body = RegisterRequestBody(username: username, email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
           request.httpBody = try JSONEncoder().encode(body)
        } catch {
           return .failure(.encodingError)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let registerResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                return .failure(.invalidCredentials)
            }
            
            guard let token = registerResponse.token else {
                return .failure(.invalidCredentials)
            }
            
            return .success(token)
        } catch {
            return .failure(.networkError)
        }
        
    }
    
    func login(email: String, password: String) async -> Result<String, AuthenticationError> {
        
        guard let url = URL(string: "http://localhost:8080/user/login") else {
            return .failure(.invalidURL)
        }
        
        let body = LoginRequestBody(email: email, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
           request.httpBody = try JSONEncoder().encode(body)
        } catch {
           return .failure(.encodingError)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let loginResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                return .failure(.invalidCredentials)
            }
            
            guard let token = loginResponse.token else {
                return .failure(.invalidCredentials)
            }
            
            return .success(token)
        } catch {
            return .failure(.networkError)
        }
    }
    
    func getUser(token: String) async -> Result<User, AuthenticationError> {
        guard let url = URL(string: "http://localhost:8080/user/get") else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.networkError)
            }
            
            // Check if the status code indicates success
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                return .success(user)
            } else if httpResponse.statusCode == 404 {
                // User not found
                return .failure(.userNotFound)
            } else {
                // Other error, handle accordingly
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    func fetchCategories(token: String) async -> Result<[Category], AuthenticationError> {
        // Assuming you have a URL for fetching categories
        guard let url = URL(string: "http://localhost:8080/categories/all") else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("here")
                return .failure(.networkError)
            }
            
            // Check if the status code indicates success
            if httpResponse.statusCode == 200 {
                let categories = try JSONDecoder().decode([Category].self, from: data)
                return .success(categories)
            } else {
                // Other error, handle accordingly
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    func createCategory(token: String, category: Category) async -> Result<CreateCategoryResponse, Error> {
        guard let url = URL(string: "http://localhost:8080/categories/create") else {
            return .failure(NetworkError.invalidURL)
        }
        
        let requestPayload = CreateCategoryRequest(name: category.name, icon: category.icon, color: category.color)
        
        do {
            let requestData = try JSONEncoder().encode(requestPayload)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = requestData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Assuming a 200 OK response indicates success
                // Adjust according to your backend's API contract
                return .failure(NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }
            
            // Decode the response to get the newly created category's ID
            let decodedResponse = try JSONDecoder().decode(CreateCategoryResponse.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(error)
        }
    }
    
    func updateCategory(token: String, category: Category) async -> Result<UpdateCategoryResponse, Error> {
        guard let url = URL(string: "http://localhost:8080/categories/update") else {
            return .failure(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let categoryData = try JSONEncoder().encode(category)
            request.httpBody = categoryData
        } catch {
            return .failure(error)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let updateResponse = try JSONDecoder().decode(UpdateCategoryResponse.self, from: data)
            return .success(updateResponse)
        } catch {
            return .failure(error)
        }
    }
    func deleteCategory(token: String, categoryId: Int) async -> Result<Void, Error> {
        guard let url = URL(string: "http://localhost:8080/categories/delete/\(categoryId)") else {
            return .failure(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Assuming a 200 OK response indicates success
                // Adjust according to your backend's API contract
                return .failure(NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }
            
            // Optionally, decode the response if your API provides a response body for DELETE requests
            // For this example, we'll assume success if we get a 200 OK response without decoding the response body
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func fetchWallets(token: String) async -> Result<[Wallet], AuthenticationError> {
        // Assuming you have a URL for fetching categories
        guard let url = URL(string: "http://localhost:8080/wallets/all") else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.networkError)
            }
            
            // Check if the status code indicates success
            if httpResponse.statusCode == 200 {
                let wallets = try JSONDecoder().decode([Wallet].self, from: data)
                print(data)
                return .success(wallets)
            } else {
                // Other error, handle accordingly
                return .failure(.networkError)
            }
        } catch {
            return .failure(.networkError)
        }
    }
    
    func createWallet(token: String, wallet: Wallet) async -> Result<CreateWalletResponse, Error> {
        guard let url = URL(string: "http://localhost:8080/wallets/create") else {
            return .failure(NetworkError.invalidURL)
        }
        
        let requestPayload = CreateWalletRequest(
            name: wallet.name,
            currency: wallet.currency,
            initial_balance: wallet.initialBalance,
            icon: wallet.iconCode,
            color: wallet.colorCode
        )
        
        do {
            let requestData = try JSONEncoder().encode(requestPayload)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = requestData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Assuming a 200 OK response indicates success
                // Adjust according to your backend's API contract
                return .failure(NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }
            
            // Decode the response to get the newly created category's ID
            let decodedResponse = try JSONDecoder().decode(CreateWalletResponse.self, from: data)
            return .success(decodedResponse)
        } catch {
            return .failure(error)
        }
    }
    
    func updateWallet(token: String, wallet: Wallet) async -> Result<UpdateWalletResponse, Error> {
        guard let url = URL(string: "http://localhost:8080/wallets/update") else {
            return .failure(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let walletData = try JSONEncoder().encode(wallet)
            request.httpBody = walletData
        } catch {
            return .failure(error)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let updateResponse = try JSONDecoder().decode(UpdateWalletResponse.self, from: data)
            return .success(updateResponse)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteWallet(token: String, walletId: Int) async -> Result<Void, Error> {
        guard let url = URL(string: "http://localhost:8080/wallets/delete/\(walletId)") else {
            return .failure(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Assuming a 200 OK response indicates success
                // Adjust according to your backend's API contract
                return .failure(NetworkError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }
            
            // Optionally, decode the response if your API provides a response body for DELETE requests
            // For this example, we'll assume success if we get a 200 OK response without decoding the response body
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
