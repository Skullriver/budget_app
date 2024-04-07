//
//  Transfer.swift
//  budget_app
//
//  Created by Alina Novikova on 24/02/2024.
//

import Foundation

struct Transfer: Identifiable, Codable, Hashable {
    let id: Int
    let userID: Int
    let amount: Int
    let description: String
    let date: String
    let sourceWalletID: Int
    let destinationWalletID: Int
    let createdAt: String
}

struct CreateTransferRequest: Codable {
    var amount: Int
    var date: String
    var sourceWalletID: Int
    var destinationWalletID: Int
    var notes: String?
}

struct TransferResponse: Identifiable, Codable, Hashable {
    let id: Int
    let userID: Int
    let amount: Int
    let description: String
    let date: String
    let sourceWalletID: Int
    let destinationWalletID: Int
    let walletCurrency: String
    let createdAt: String
}
