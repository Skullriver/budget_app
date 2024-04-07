//
//  Wallet.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Wallet: Identifiable, Codable, Hashable {
    var id: Int
    var userID: Int
    var name: String
    var currency: String
    var initialBalance: Int
    var balance: Int
    var iconCode: String
    var colorCode: String
    var createdAt: String
    
    static var placeholder: Wallet {
        return Wallet(id: -1, userID: -1, name: "Select wallet", currency: "USD", initialBalance: 0, balance:0, iconCode: "questionmark.circle", colorCode: "#DBF9F0", createdAt: "")
    }
}

struct WalletStatistics: Identifiable, Codable {
    var id: Int
    let totalIncome: Int
    let totalExpenses: Int
}
