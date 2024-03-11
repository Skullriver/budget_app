//
//  CategoryView.swift
//  budget_app
//
//  Created by Alina Novikova on 06/03/2024.
//

import SwiftUI

struct CategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: CategoriesViewModel
    
    @State private var isPresented: Bool = false
    @State private var showingDeleteConfirmation = false
    @State private var categoryToDelete: Category?
    
    @State private var showingActionSheet = false
    @State private var selectedCategory: Category?
    @State private var navigateToEditView = false
    
    var body: some View {
        NavigationStack{
            VStack{
                //fetch categories here
                if viewModel.isLoading {
                    ProgressView()
                }else{
                    List(viewModel.categories) { category in
                        HStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(hex: category.color ) )
                                    .frame(width: 25, height: 25) // Adjust size as needed
                                
                                Image(systemName: category.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white) // Icon color, adjust as needed
                                    .frame(width: 15, height: 15) // Adjust icon size as needed
                            }
                            .padding(.trailing, 5)
                            
                            Text(category.name)
                                .foregroundColor(.text)
                                .font(.system(.callout).monospaced().bold())

                        }
                        .padding(.vertical, 7)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedCategory = category
                            self.showingActionSheet = true
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                    .scrollContentBackground(.hidden)
                    .actionSheet(isPresented: $showingActionSheet) {
                        actionSheet(for: selectedCategory)
                    }
                    .fullScreenCover(isPresented: $navigateToEditView) {
                        CategoryDetailView(category: selectedCategory, isNewCategory: false)
                    }
                }
                
                //Add new category
                Button{
                    isPresented.toggle()
                } label: {
                    SecondaryButton(title: "Add")
                }
                Spacer()
            }
            .toolbar {
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
                        Text("Categories")
                            .font(.system(size: 20).monospaced().bold())
                          .foregroundColor(Color.text)
                    }
                }
            }
            .background(Color.background)
            .sheet(isPresented: $isPresented) {
                CategoryDetailView(isNewCategory: true)
            }
            .alert("Confirm Delete", isPresented: $showingDeleteConfirmation) {
                Button("Cancel Delete", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let categoryToDelete = categoryToDelete {
                        Task {
                            await viewModel.deleteCategory(categoryToDelete.id)
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete this category?")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchCategories()
            }
        }
    }
    
    func actionSheet(for category: Category?) -> ActionSheet {
        ActionSheet(title: Text("Select Action"), message: nil, buttons: [
            .default(Text("Edit")) { 
                self.navigateToEditView = true
            },
            .destructive(Text("Delete")) {
                self.categoryToDelete = category
                self.showingDeleteConfirmation = true
            },
            .cancel()
        ])
    }
}

struct CategoryView_Previews: PreviewProvider {
    
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
            // Instantiate CategoryView normally
        
        CategoryView().environmentObject(viewModel)

            
        }
}
