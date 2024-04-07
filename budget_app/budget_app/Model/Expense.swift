//
//  Expense.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Expense: Identifiable, Codable, Hashable {
    let id: Int
    let userID: Int
    let amount: Int
    let categoryID: Int
    let description: String
    let date: String
    let walletID: Int
    let createdAt: String
}

struct CreateExpenseRequest: Codable {
    var amount: Int
    var categoryID: Int
    var date: String
    var walletID: Int
    var notes: String?
}

struct ExpenseResponse: Identifiable, Codable, Hashable {
    let id: Int
    let userID: Int
    let amount: Int
    let categoryID: Int
    let categoryName: String
    let categoryIcon: String
    let categoryColor: String
    let description: String
    let date: String
    let walletID: Int
    let walletCurrency: String
    let createdAt: String
}
