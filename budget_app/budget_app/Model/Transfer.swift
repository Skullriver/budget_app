//
//  Transfer.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Transfer: Codable {
    let id: Int
    let userID: Int
    let amount: Float
    let description: String
    let date: Date
    let sourceWalletID: Int
    let destinationWalletID: Int
    let createdAt: Date
}
