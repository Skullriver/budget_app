//
//  budget_appApp.swift
//  budget_app
//
//  Created by Alina Novikova on 15/02/2024.
//

import SwiftUI

@main
struct budget_appApp: App {

    @StateObject var viewModel = AuthViewModel()
    @StateObject var tabViewModel = TabViewModel()
    @StateObject var transactionViewModel = TransactionViewModel()
    @StateObject var categoryViewModel = CategoriesViewModel()
    @StateObject var walletsViewModel = WalletsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(tabViewModel)
                .environmentObject(transactionViewModel)
                .environmentObject(categoryViewModel)
                .environmentObject(walletsViewModel)
        }
    }
}
