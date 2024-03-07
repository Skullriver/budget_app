//
//  Category.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: Int
    let user_id: Int
    let name: String
    let icon: String
    let color: String
    
    // Static placeholder property
    static var placeholder: Category {
        return Category(id: 0, user_id: -1, name: "Placeholder", icon: "questionmark.circle", color: "#FFFFFF")
    }
}
