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

struct RegisterResponse: Codable {
    let token: String?
    let message: String?
    let success: Bool?
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
            
            guard let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
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
}
