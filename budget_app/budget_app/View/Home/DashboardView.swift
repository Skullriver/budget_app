//
//  DashboardView.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import SwiftUI


struct DashboardView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var isPresented: Bool = false
    
    @State private var showingCategoryView = false
    
    var body: some View {
        
//        if let user = viewModel.currentUser {
//            VStack{
//                Text(user.username)
//                Spacer()
//                Button{
//                    Task {
//                        viewModel.signOut()
//                    }
//                } label: {
//                    PrimaryButton(title: "Sign Out")
//                        .padding(.bottom, 35)
//                }
//            }
//            
//        }
        NavigationView {
            ScrollView{
                VStack{
                    
                    Text("User")
                    
                    Spacer()
                    
                    Button("Add"){
                        isPresented.toggle()
                    }
                    
                    Spacer()
                    
                    Button("Show Categories") {
                        showingCategoryView = true
                    }
                    
                    Spacer()
                    
                    Button{
                        Task {
                            viewModel.signOut()
                        }
                    } label: {
                        PrimaryButton(title: "Sign Out")
                            .padding(.bottom, 35)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $isPresented) {
                    AddTransactionView()
                }
                .fullScreenCover(isPresented: $showingCategoryView) {
                    // Present your CategoryView here
                    CategoryView()
                }
            }
            .background(Color.background)
        }
            
    }
}

#Preview {
    DashboardView()
}
