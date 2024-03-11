//
//  User.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let username: String
    
    static var placeholder: User {
        return User(id: 0, username: "Test")
    }
}


