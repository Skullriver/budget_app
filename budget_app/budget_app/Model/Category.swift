//
//  Category.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable, Hashable {
    let id: Int
    var user_id: Int
    var name: String
    var icon: String
    var color: String
    
    // Static placeholder property
    static var placeholder: Category {
        return Category(id: -1, user_id: -1, name: "", icon: "questionmark.circle", color: "#DBF9F0")
    }
    
    static var selectCategory: Category {
        return Category(id: -1, user_id: -1, name: "Select category", icon: "questionmark.circle", color: "#DBF9F0")
    }
}

struct CategoryStatistic: Codable, Hashable {
    let category: String
    let amount: Int
    let colorCode: String
    
    var color: Color {
        Color(hex: colorCode) // Ensure you have implemented this extension.
    }
   
    private enum CodingKeys: String, CodingKey {
        case category, amount, colorCode
    }
}
