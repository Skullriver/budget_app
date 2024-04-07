//
//  BudgetViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 05/04/2024.
//

import Foundation
import SwiftUI

@MainActor
class BudgetViewModel: ObservableObject {
    // Assumes you have a way to fetch these, possibly from a database
    @Published var selectedMonth: Date = Date()
    @Published var statisticsType: StatisticsType = .expenses
    @Published var categoriesStatistics: [CategoryStatistic] = []
    @Published var selectedWalletID: Int?
    @Published var selectedWalletCurrency: String = "$"
    @Published var isLoading = false
    
    @Published var hasFetchedStatistics = false
    
    private var userSession: String? {
        AuthViewModel.shared.userSession
    }

    enum StatisticsType: String, CaseIterable {
        case expenses = "Expenses"
        case income = "Income"
    }

    
    func fetchStatistics() async {
        guard let token = self.userSession, let walletID = selectedWalletID else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM" // Format to filter by month
        let monthString = formatter.string(from: selectedMonth)
        
        isLoading = true
        // Example: Fetch expenses or income for the selected wallet
        // You'll need to adjust this to your app's data fetching logic
        switch await NetworkService.shared.fetchStatistics(token: token, walletID: walletID, month: monthString, type: statisticsType.rawValue) {
        case .success(let statistics):
            isLoading = false
            self.categoriesStatistics = statistics
        case .failure(let error):
            isLoading = false
            print("Error fetching statistics: \(error.localizedDescription)")
        }
    }
}
