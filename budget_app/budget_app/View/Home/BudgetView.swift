//
//  BudgetView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI

struct BudgetView: View {
    
    @EnvironmentObject var walletsViewModel: WalletsViewModel
    
    @StateObject var viewModel = BudgetViewModel()
    @State private var showingDateSelection = false
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .primaryButton.withAlphaComponent(0.1)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .normal)
    }
    
    var body: some View {
        
        if viewModel.isLoading {
            ProgressView()
        }else{
            
            VStack {
                // Month selector
                HStack {
                    Button(action: { self.changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.text)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.selectedMonth, formatter: DateFormatter.monthYear)
                        .font(.title3.monospaced())
                        .foregroundColor(.text)
                        .onTapGesture { showingDateSelection.toggle() }
                    
                    Spacer()
                    
                    Button(action: { self.changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.text)
                    }
                }
                .padding()
                
                if !walletsViewModel.displayableWallets.isEmpty {
                    Picker("Select Wallet", selection: $viewModel.selectedWalletID) {
                        ForEach(walletsViewModel.displayableWallets) { wallet in
                            Text(wallet.name).tag(wallet.id as Int?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                
                // Statistics Type Picker
                Picker("Type", selection: $viewModel.statisticsType) {
                    ForEach(BudgetViewModel.StatisticsType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.categoriesStatistics.isEmpty {
                                Spacer() // Optional: Adjust layout to center or position the text as desired.
                                Text("No data to show")
                                    .foregroundColor(.text)
                                    .font(.title3.monospaced())
                                Spacer() // Optional: Adjust layout to center or position the text as desired.
                } else {
                    
                    PieChartView(statistics: viewModel.categoriesStatistics)
                        .frame(width: 200)
                    
                    // List of Categories and Amounts
                    List(viewModel.categoriesStatistics, id: \.category) { statistic in
                        HStack {
                            Circle()
                                .fill(statistic.color)
                                .frame(width: 20, height: 20)
                            Text(statistic.category)
                                .foregroundColor(.text)
                                .font(.system(.callout).monospaced().bold())
                            Spacer()
                            
                            
                            Text((currencySymbols[viewModel.selectedWalletCurrency] ?? "$"))
                                .font(.title3.monospaced())
                            
                            
                            Text(String(format: "%.2f", Float(statistic.amount) / 100.0))
                                .font(.title3.monospaced())
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                }
            }
            .background(Color.background)
            .onChange(of: viewModel.selectedMonth) { _,_ in 
                Task {await viewModel.fetchStatistics()} }
            .onChange(of: viewModel.statisticsType) { _,_ in
                Task {await viewModel.fetchStatistics()} }
            .onChange(of: viewModel.selectedWalletID) { _,_ in
                Task {await viewModel.fetchStatistics()} }
            .onAppear {
                Task {
                    if walletsViewModel.displayableWallets.isEmpty {
                        await walletsViewModel.fetchWallets()
                        // Setting the default wallet after wallets are fetched
                        if let firstWallet = walletsViewModel.displayableWallets.first {
                            viewModel.selectedWalletID = firstWallet.id
                            viewModel.selectedWalletCurrency = firstWallet.currency
                        }
                    }
                    // Fetch statistics only if they haven't been fetched yet or if it's necessary to refresh
                    if !viewModel.hasFetchedStatistics {
                        await viewModel.fetchStatistics()
                        viewModel.hasFetchedStatistics = true
                    }
                       
                }
            }
        }
    }
    
    private func changeMonth(by value: Int) {
        let currentCalendar = Calendar.current
        if let newDate = currentCalendar.date(byAdding: .month, value: value, to: viewModel.selectedMonth) {
            viewModel.selectedMonth = newDate
        }
    }
}

struct BudgetView_Previews: PreviewProvider {
    
    static let walletsViewModel: WalletsViewModel = {
            let vm = WalletsViewModel()
            vm.displayableWallets = [
                Wallet(id: 1, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 2, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 3, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 4, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                
            ]
            return vm
    }()
    
    static let viewModel: BudgetViewModel = {
            let vm = BudgetViewModel()
            vm.categoriesStatistics = [
                CategoryStatistic(category: "Groceries", amount: 100, colorCode: ""),
                                          CategoryStatistic(category: "Utilities", amount: 50, colorCode: "")
                
            ]
            return vm
    }()
    
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        BudgetView()
            .environmentObject(walletsViewModel)
            .environmentObject(viewModel)

            
        }
}

