//
//  AddTransactionView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI
import Combine

struct AddTransactionView: View {

    @Environment(\.dismiss) private var dismiss
    @State var amount: Int = 0
    @State var selectedType:TransactionType = .income
    
    @State var transactionDate: Date = Date()
    @State var notes: String = ""
    // Assuming 'selectedFromWallet' and 'selectedToWallet' for Transfer type
    @State var selectedFromWallet: Wallet = .placeholder
    @State var selectedToWallet: Wallet = .placeholder
    
    @EnvironmentObject var categoriesViewModel: CategoriesViewModel
    @EnvironmentObject var walletsViewModel: WalletsViewModel
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .primaryButton.withAlphaComponent(0.1)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .normal)
    }

    
    @State private var selectedCategory: Category = .selectCategory
    @State private var selectedWallet: Wallet = .placeholder
    
    var body: some View {
        NavigationView{
            ZStack {
                // Background color applied here to cover full screen
                Color.background
                    .edgesIgnoringSafeArea(.all)
                
                if categoriesViewModel.isLoading {
                    ProgressView()
                }else{
                    VStack{
                        CurrencyField(value: $amount)
                            .font(.largeTitle.monospaced())
                            .padding()
                        
                        Picker("t", selection: $selectedType) {
                            ForEach(TransactionType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        if selectedType != .transfer {
                            PickerCategoryView(selectedCategory: $selectedCategory, categoriesViewModel: categoriesViewModel)
                        }
                        
                        HStack{
                            Text("Date:")
                                .font(.system(size: 14).monospaced().bold())
                                .foregroundColor(Color.text)
                            
                            Spacer()
                            // Date Picker
                            DatePicker("", selection: $transactionDate, displayedComponents: .date)
                                .padding()
                        }
                        .padding(.horizontal, 35)
                        
                        
                        if selectedType == .transfer {
                            PickerWalletView(label: "From Wallet:", selectedWallet: $selectedFromWallet, walletsViewModel: walletsViewModel)
                            PickerWalletView(label: "To Wallet:", selectedWallet: $selectedToWallet, walletsViewModel: walletsViewModel)
                        } else {
                            // For Income and Expense, show Wallet Picker
                            PickerWalletView(label: "Wallet:", selectedWallet: $selectedWallet, walletsViewModel: walletsViewModel)
                        }
                        
                        TextField("Notes", text: $notes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                                                
                        
//                        HStack{
//                            Text("Category:")
//                                .font(.system(size: 14).monospaced().bold())
//                                .foregroundColor(Color.text)
//                            
//                            Spacer()
//                            Picker("Category", selection: $selectedCategory) {
//                                ForEach(categoriesViewModel.categories) { category in
//                                    Text(category.name)
//                                        .font(.system(size: 12).monospaced().bold())
//                                        .foregroundColor(Color.text)
//                                        .tag(category)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 35)
                        
//                        HStack{
//                            Text("Wallet:")
//                                .font(.system(size: 14).monospaced().bold())
//                                .foregroundColor(Color.text)
//                            
//                            Spacer()
//                            Picker("Wallet", selection: $selectedWallet) {
//                                ForEach(walletsViewModel.wallets) { wallet in
//                                    Text(wallet.name)
//                                        .font(.system(size: 12).monospaced().bold())
//                                        .foregroundColor(Color.text)
//                                        .tag(wallet)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 35)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            SecondaryButton(title: "Save")
                        }
                        .padding()

                        
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Add transaction")
                                    .font(.system(size: 20).monospaced().bold())
                                    .foregroundColor(Color.text)
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        .onAppear {
            Task {
                await categoriesViewModel.fetchCategories()
                await walletsViewModel.fetchWallets()
            }
        }
    
    }
}

enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
    case transfer = "Transfer"
}

// Helper views for categories and wallets picker
struct PickerCategoryView: View {
    @Binding var selectedCategory: Category
    var categoriesViewModel: CategoriesViewModel
    
    var body: some View {
        HStack {
            Text("Category:")
                .font(.system(size: 14).monospaced().bold())
                .foregroundColor(Color.text)
            
            Spacer()
            
            Picker("Category", selection: $selectedCategory) {
                ForEach(categoriesViewModel.categories) { category in
                    Text(category.name)
                        .font(.system(size: 12).monospaced().bold())
                        .foregroundColor(Color.text)
                        .tag(category)
                }
            }
        }
        .padding(.horizontal, 35)
    }
}

struct PickerWalletView: View {
    var label: String
    @Binding var selectedWallet: Wallet
    var walletsViewModel: WalletsViewModel
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14).monospaced().bold())
                .foregroundColor(Color.text)
            
            Spacer()
            
            Picker(label, selection: $selectedWallet) {
                ForEach(walletsViewModel.wallets) { wallet in
                    Text(wallet.name)
                        .font(.system(size: 12).monospaced().bold())
                        .foregroundColor(Color.text)
                        .tag(wallet)
                }
            }
        }
        .padding(.horizontal, 35)
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    
    static let viewModel: CategoriesViewModel = {
            let vm = CategoriesViewModel()
            vm.categories = [
                Category(id: 1, user_id: -1, name: "Groceries", icon: "cart", color: "#FF0000"),
                Category(id: 2, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 3, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 4, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 5, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
            ]
            return vm
    }()
    
    static let walletViewModel: WalletsViewModel = {
            let vm = WalletsViewModel()
            vm.wallets = [
                Wallet(id: 1, userID: -1, name: "Wallet1", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 2, userID: -1, name: "Wallet2", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 3, userID: -1, name: "Wallet3", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 4, userID: -1, name: "Wallet4", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
            ]
            return vm
    }()
    
    static var previews: some View {
        AddTransactionView()
            .environmentObject(viewModel)
            .environmentObject(walletViewModel)
    }
}
