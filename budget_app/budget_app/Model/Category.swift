//
//  Category.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Category: Codable {
    let id: Int
    let userID: Int
    let name: String
    let iconCode: String
    let colorCode: String
    let createdAt: Date
}
