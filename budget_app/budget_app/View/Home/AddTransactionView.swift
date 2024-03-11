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
    
    @EnvironmentObject var categoriesViewModel: CategoriesViewModel
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .primaryButton.withAlphaComponent(0.1)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .normal)
    }

    
    @State private var selectedCategory: Category = .selectCategory
    
    var body: some View {
        NavigationStack{
            if categoriesViewModel.isLoading {
                ProgressView()
            }else{
                VStack{
                    CurrencyField(value: $amount)
                        .font(.largeTitle)
                    
                    Picker("t", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    HStack{
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
        .onAppear {
            Task {
                await categoriesViewModel.fetchCategories()
            }
        }
    }
}

enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
    case transfer = "Transfer"
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
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
                Category(id: 6, user_id: -1, name: "Utilities", icon: "bolt.fill", color: "#00FF00"),
            ]
            return vm
    }()
    
    static var previews: some View {
        AddTransactionView()
            .environmentObject(viewModel)
    }
}
