//
//  Expense.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Expense: Codable {
    let id: Int
    let userID: Int
    let amount: Float
    let categoryID: Int
    let description: String
    let date: Date
    let walletID: Int
    let createdAt: Date
}
