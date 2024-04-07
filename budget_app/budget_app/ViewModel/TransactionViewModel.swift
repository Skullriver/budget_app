//
//  AddTransactionViewModel.swift
//  budget_app
//
//  Created by Alina Novikova on 08/03/2024.
//

import Foundation

@MainActor
class TransactionViewModel: ObservableObject {
     
    @Published var amount: Int = 0
    @Published var selectedType: TransactionType = .income
    @Published var transactionDate: Date = Date()
    @Published var notes: String = ""
    
    @Published var selectedFromWallet: Wallet = .placeholder
    @Published var selectedToWallet: Wallet = .placeholder
    
    @Published var selectedCategory: Category = .selectCategory
    @Published var selectedWallet: Wallet = .placeholder
    
    @Published var isLoading = false
    @Published var isNewTransactionVisible = false
    
    @Published var transactions: [Transaction] = []
    @Published var groupedTransactions: [String: [Transaction]] = [:]

    @Published var isLoadingView = false
    
    private var userSession: String? {
        AuthViewModel.shared.userSession
    }
    
    func fetchTransactions() async {
        if let token = self.userSession {
            isLoadingView = true
            switch await NetworkService.shared.fetchTransactions(token: token) {
                case .success(let transactions):
                    isLoadingView = false
                    self.transactions = transactions
                    // Group transactions by their `date` field
                    let grouped = Dictionary(grouping: transactions, by: { $0.date })
                    self.groupedTransactions = grouped
                        
                case .failure(let error):
                    isLoadingView = false
                    print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    // Function to prepare and send the transaction data to the backend
    func prepareDataForSubmission() -> Data? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: transactionDate)
            
            let encoder = JSONEncoder()
            var requestData: Data?
            
            switch selectedType {
            case .income:
                let request = CreateIncomeRequest(amount: amount, categoryID: selectedCategory.id, date: dateString, walletID: selectedWallet.id, notes: notes.isEmpty ? nil : notes)
                requestData = try? encoder.encode(request)
            case .expense:
                let request = CreateExpenseRequest(amount: amount, categoryID: selectedCategory.id, date: dateString, walletID: selectedWallet.id, notes: notes.isEmpty ? nil : notes)
                requestData = try? encoder.encode(request)
            // Handle other cases as necessary
            case .transfer:
                let request = CreateTransferRequest(amount: amount, date: dateString, sourceWalletID: selectedFromWallet.id, destinationWalletID: selectedToWallet.id, notes: notes.isEmpty ? nil : notes)
                requestData = try? encoder.encode(request)
            
            }
            
            return requestData
        
    }
    
    func createTransaction() async {
        
        guard let token = self.userSession else { return }
        
        guard let data = prepareDataForSubmission() else { return }
        
        if selectedType == .income {
            
            self.isLoading = true
            
            let result = await NetworkService.shared.createIncome(token: token, requestData: data)
            
            switch result {
                case .success(let createIncomeResponse):
                    print("Income successfully created with ID: \(createIncomeResponse.incomeID)")
                    await fetchTransactions()
                case .failure(let error):
                    print("Failed to create income: \(error.localizedDescription)")
                }
            
            self.isLoading = false
        }
        
        if selectedType == .expense {
            
            self.isLoading = true
            
            let result = await NetworkService.shared.createExpense(token: token, requestData: data)
            
            switch result {
                case .success(let createExpenseResponse):
                    print("Expense successfully created with ID: \(createExpenseResponse.expenseID)")
                    await fetchTransactions()
                case .failure(let error):
                    print("Failed to create expense: \(error.localizedDescription)")
                }
            
            self.isLoading = false
        }
        
        if selectedType == .transfer {
            
            self.isLoading = true
            
            let result = await NetworkService.shared.createTransfer(token: token, requestData: data)
            
            switch result {
                case .success(let createTransferResponse):
                    print("Transfer successfully created with ID: \(createTransferResponse.transferID)")
                    await fetchTransactions()
                case .failure(let error):
                    print("Failed to create transfer: \(error.localizedDescription)")
                }
            
            self.isLoading = false
        }
        
    }
    
    
}

enum TransactionType: String, CaseIterable, Codable {
    case income = "Income"
    case expense = "Expense"
    case transfer = "Transfer"
}

enum Transaction: Codable {
    case income(IncomeResponse)
    case expense(ExpenseResponse)
    case transfer(TransferResponse)
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    var categoryName: String {
        switch self {
        case .income(let income):
            return income.categoryName
        case .expense(let expense):
            return expense.categoryName
        case .transfer(_):
            return "Transfer"
        }
    }
    
    var categoryIcon: String {
        switch self {
        case .income(let income):
            return income.categoryIcon
        case .expense(let expense):
            return expense.categoryIcon
        case .transfer(_):
            return "arrow.2.squarepath"
        }
    }
    
    var categoryColor: String {
        switch self {
        case .income(let income):
            return income.categoryColor
        case .expense(let expense):
            return expense.categoryColor
        case .transfer(_):
            return "red"
        }
    }
    
    var amount: Int {
        switch self {
        case .income(let income):
            return income.amount
        case .expense(let expense):
            return expense.amount
        case .transfer(let transfer):
            return transfer.amount
        }
    }
    
    var walletCurrency: String {
        switch self {
        case .income(let income):
            return income.walletCurrency
        case .expense(let expense):
            return expense.walletCurrency
        case .transfer(let transfer):
            return transfer.walletCurrency
        }
    }
    
    var type: String {
        switch self {
        case .income(_):
            return "income"
        case .expense(_):
            return "expense"
        case .transfer(_):
            return "transfer"
        }
    }
    
    var date: String {
        switch self {
        case .income(let income):
            return income.date
        case .expense(let expense):
            return expense.date
        case .transfer(let transfer):
            return transfer.date
        }
    }
    
    var id: Int {
        switch self {
        case .income(let income):
            return income.id
        case .expense(let expense):
            return expense.id
        case .transfer(let transfer):
            return transfer.id
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(TransactionType.self, forKey: .type)
        
        switch type {
        case .income:
            let income = try IncomeResponse(from: decoder)
            self = .income(income)
        case .expense:
            let expense = try ExpenseResponse(from: decoder)
            self = .expense(expense)
        case .transfer:
            let transfer = try TransferResponse(from: decoder)
            self = .transfer(transfer)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .income(let income):
            try container.encode(TransactionType.income.rawValue, forKey: .type)
            try income.encode(to: encoder)
        case .expense(let expense):
            try container.encode(TransactionType.expense.rawValue, forKey: .type)
            try expense.encode(to: encoder)
        case .transfer(let transfer):
            try container.encode(TransactionType.transfer.rawValue, forKey: .type)
            try transfer.encode(to: encoder)
        }
    }
}
