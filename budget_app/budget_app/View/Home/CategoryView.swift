//
//  CategoryView.swift
//  budget_app
//
//  Created by Alina Novikova on 06/03/2024.
//

import SwiftUI

struct CategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var isPresented: Bool = false
    
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
                        // Present your CategoryView here
                        EditCategoryView(category: selectedCategory ?? Category.placeholder)
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
                AddCategoryView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
//            tabViewModel.isTabBarVisible = false
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
            .destructive(Text("Delete")) { /* Handle Delete Action */ },
            .cancel()
        ])
    }
}

#Preview {
    CategoryView()
}
