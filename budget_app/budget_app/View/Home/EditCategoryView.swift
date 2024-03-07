//
//  EditCategoryView.swift
//  budget_app
//
//  Created by Alina Novikova on 07/03/2024.
//

import SwiftUI

struct EditCategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var category: Category
        
    var body: some View {
        NavigationStack{
            VStack{
                Text("Editing Category ID: \(category.id)")
                    .navigationBarTitle("Edit Category", displayMode: .inline)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    EditCategoryView(category: Category.placeholder)
}
