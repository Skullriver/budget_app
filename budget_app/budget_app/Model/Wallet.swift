//
//  Wallet.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Wallet: Codable {
    let id: Int
    let userID: Int
    let name: String
    let currency: String
    let initialBalance: Float
    let balance: Float
    let iconCode: String
    let colorCode: String
    let createdAt: Date
}
