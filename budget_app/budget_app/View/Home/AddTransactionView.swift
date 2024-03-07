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
    
    init() {
        UISegmentedControl.appearance().backgroundColor = .primaryButton.withAlphaComponent(0.1)
        
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .highlighted)
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)], for: .normal)
    }
    
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }


    @State private var selectedFlavor: Flavor = .chocolate
    
    var body: some View {
        NavigationStack{
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
                
                Picker("Flavor", selection: $selectedFlavor) {
                    Text("Chocolate").tag(Flavor.chocolate)
                    Text("Vanilla").tag(Flavor.vanilla)
                    Text("Strawberry").tag(Flavor.strawberry)
                }
                Text("Your Favorite Fruit:")
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

enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
    case transfer = "Transfer"
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
    }
}
