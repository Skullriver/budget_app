//
//  WalletsViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 18/03/2024.
//

import Foundation

@MainActor
class WalletsViewModel: ObservableObject {
    
    @Published var wallets: [Wallet] = [.placeholder]
    @Published var displayableWallets: [Wallet] = []
    @Published var isLoading = false
    
    @Published var walletStatistics: WalletStatistics?
    
    private var userSession: String? {
        AuthViewModel.shared.userSession
    }
    
    func fetchWalletStatistics(walletID: Int) async {
        if let token = self.userSession {
            isLoading = true
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM" // Format to filter by month
            let monthString = formatter.string(from: Date())
            
            switch await NetworkService.shared.fetchWalletStatistics(token: token, walletID: walletID, month: monthString) {
                case .success(let stats):
                    isLoading = false
                    self.walletStatistics = stats
                case .failure(let error):
                    isLoading = false
                    print("Error fetching wallet statistics: \(error.localizedDescription)")
            }
        
        }
    }
    
    func fetchWallets() async {
        if let token = self.userSession {
            isLoading = true
            switch await NetworkService.shared.fetchWallets(token: token) {
                case .success(let wallets):
                    isLoading = false
                    self.wallets = [.placeholder]
                    self.displayableWallets = wallets
                    self.wallets.append(contentsOf: wallets)
                case .failure(let error):
                    isLoading = false
                    print("Error fetching wallets: \(error.localizedDescription)")
            }
        }
    }
    
    func updateWallet(_ wallet: Wallet) async {
        
        guard let token = self.userSession else { return }
                
        self.isLoading = true
        let result = await NetworkService.shared.updateWallet(token: token, wallet: wallet)
        
        switch result {
        case .success(let updateResponse):
            print("Successfully updated wallet with ID: \(updateResponse.walletID)")
            // Consider refreshing your categories list here if necessary
            await fetchWallets()
        case .failure(let error):
            print("Failed to update wallet: \(error.localizedDescription)")
        }
        self.isLoading = false
    }
    
    func createWallet(_ wallet: Wallet) async {
        
        guard let token = self.userSession else { return }
                
        self.isLoading = true
        let result = await NetworkService.shared.createWallet(token: token, wallet: wallet)
        
        switch result {
        case .success(let createWalletResponse):
            print("Wallet successfully created with ID: \(createWalletResponse.walletID)")
            // Optionally refresh your categories list here if necessary
            await fetchWallets()
        case .failure(let error):
            print("Failed to create wallet: \(error.localizedDescription)")
        }
        
        self.isLoading = false
    }
    
    func deleteWallet(_ walletId: Int) async {
        guard let token = self.userSession else { return }
        
        isLoading = true
        let result = await NetworkService.shared.deleteWallet(token: token, walletId: walletId)
        
        switch result {
        case .success(_):
            print("Wallet deleted successfully.")
            // Optionally refresh your categories list here
            await fetchWallets()
        case .failure(let error):
            print("Error deleting wallet: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
}
