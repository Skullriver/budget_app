//
//  DashboardView.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import SwiftUI


struct DashboardView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var transactionViewModel: AddTransactionViewModel
    
    @State private var showingCategoryView = false
    
    var body: some View {
        
        if let user = viewModel.currentUser {
            NavigationView {
                VStack{
                    ScrollView{
                        VStack{
                            
                            HStack {
                                Text("Dashboard")
                                    .font(.system(size: 30).monospaced().bold())
                                Spacer()
                                Text("Hello,"+user.username)
                                    .font(.system(size: 16).monospaced())
                                    .foregroundColor(Color.text)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            Divider()
                            
                            
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
                        .sheet(isPresented: $transactionViewModel.isNewTransactionVisible) {
                            AddTransactionView()
                        }
                        .fullScreenCover(isPresented: $showingCategoryView) {
                            // Present your CategoryView here
                            CategoryView()
                        }
                    }
                    .background(Color.background)
                }
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showingCategoryView = true
                        } label: {
                            Image("categories")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .scaledToFit()
                                .foregroundColor(.text)
                        }

                        
                    }
                }
                
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    
    static let viewModel: AuthViewModel = {
            let vm = AuthViewModel()
            vm.currentUser = User.placeholder
            return vm
    }()
    
    static let transactionViewModel: AddTransactionViewModel = {
            let vm = AddTransactionViewModel()
            
            return vm
    }()
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        DashboardView()
            .environmentObject(viewModel)
            .environmentObject(transactionViewModel)
            
        }
}

