//
//  TransactionsView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI

struct TransactionsView: View {
    
    @EnvironmentObject var transactionViewModel: TransactionViewModel

    
    var body: some View {
        NavigationView{
            ScrollView{
                if transactionViewModel.isLoadingView {
                    ProgressView()
                }else{
                    VStack {
                        ForEach(Array(transactionViewModel.groupedTransactions.keys.sorted()), id: \.self) { dateString in
                            VStack(alignment: .leading) {
                                
                                
                                Text(DateFormatterUtility.shared.format(dateString: dateString)) // Date section header
                                    .font(.headline.monospaced())
                                    .padding(.top)
                                
                                
                                ForEach(transactionViewModel.groupedTransactions[dateString] ?? [], id: \.id) { transaction in
                                    
                                    HStack {
                                        
                                        Circle()
                                            .fill(Color(hex: transaction.categoryColor))
                                            .frame(width: 30, height: 30)
                                            .overlay(
                                                Image(systemName: transaction.categoryIcon)
                                                    .foregroundColor(.white)
                                            )
                                        Text(transaction.categoryName)
                                            .font(.system(size: 14).monospaced())
                                        
                                        Spacer()
                                        
                                        if (transaction.type == "income"){
                                            Text("+")
                                                .foregroundColor(Color.green)
                                        }
                                        
                                        if (transaction.type == "expense"){
                                            Text("-")
                                                .foregroundColor(Color.red)
                                        }
                                        
                                        Text(String(format: "%.2f", Float(transaction.amount) / 100.0))
                                            .font(.system(size: 14).monospaced())
                                            .foregroundColor(transaction.type == "income" ? Color.green : transaction.type != "transfer" ? Color.red : Color.text)
                                        
                                        Text((currencySymbols[transaction.walletCurrency] ?? "$"))
                                            .font(.title3.monospaced())
                                            .foregroundColor(transaction.type == "income" ? Color.green : transaction.type != "transfer" ? Color.red : Color.text)
                                        
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    .padding(.bottom, 50)
                }
                
               
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Transactions")
                            .font(.system(size: 20).monospaced().bold())
                          .foregroundColor(Color.text)
                    }
                }
            }
            
            
        }
        .onAppear {
            Task {
                await transactionViewModel.fetchTransactions()
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    
    static let viewModel: TransactionViewModel = {
            let vm = TransactionViewModel()
            vm.transactions = [
                .income(IncomeResponse(id: 0, userID: 1, amount: 100, categoryID: 1, categoryName: "test", categoryIcon: "tes", categoryColor: "test", description: "test", date: "2024-03-25", walletID: 1, walletCurrency: "", createdAt: "2024-03-25")),
                .expense(ExpenseResponse(id: 1, userID: 1, amount: 10, categoryID: 1, categoryName: "test", categoryIcon: "tes", categoryColor: "test", description: "test", date: "2024-03-25", walletID: 1, walletCurrency: "", createdAt: "2024-03-25")),
                .transfer(TransferResponse(id: 2, userID: 1, amount: 20, description: "test", date: "2024-03-25", sourceWalletID: 1, destinationWalletID: 2, walletCurrency: "", createdAt: "2024-03-25"))
                
            ]
            return vm
    }()
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        TransactionsView().environmentObject(viewModel)

            
        }
}

struct DateFormatterUtility {
    static let shared = DateFormatterUtility()
    private let isoDateFormatter: ISO8601DateFormatter
    private let displayDateFormatter: DateFormatter
    
    init() {
        isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd MMMM YYYY" // Adjust format as needed
        displayDateFormatter.locale = Locale(identifier: "fr_FR") // For French month names
    }
    
    func format(dateString: String) -> String {
        if let date = isoDateFormatter.date(from: dateString) {
            return displayDateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}
