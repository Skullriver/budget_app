//
//  DashboardView.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import SwiftUI


struct DashboardView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var walletsViewModel: WalletsViewModel
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
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
                            
                            if walletsViewModel.isLoading {
                                ProgressView()
                            }else{
                                ZStack{
                                    ForEach(0..<walletsViewModel.displayableWallets.count, id: \.self ) { index in
                                        
                                        VStack {
                                            HStack{
                                                Text(walletsViewModel.displayableWallets[index].name)
                                                    .font(.headline)
                                            }
                                            .padding()
                                            
                                            Spacer()
                                            
                                            HStack{
                                            
                                                Text((currencySymbols[walletsViewModel.displayableWallets[index].currency] ?? "$"))
                                                    .font(.title3.monospaced())
                                                
                                                Text(String(format: "%.2f", Float(walletsViewModel.displayableWallets[index].balance) / 100.0))
                                                    .font(.title3.monospaced())
                                                Spacer()
                                                Image(systemName: walletsViewModel.displayableWallets[index].iconCode)
                                                    .font(.largeTitle)
                                            }
                                            .padding()
                                        }
                                        .frame(width: 250, height: 150)
                                        .background(Color(hex: walletsViewModel.displayableWallets[index].colorCode))
                                        .cornerRadius(20)
                                        .opacity(currentIndex == index ? 1.0 : 0.5)
                                        .scaleEffect(currentIndex == index ? 1.2 : 1)
                                        .offset(x: CGFloat(index - currentIndex) * 285 + dragOffset, y: 0)
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .gesture(
                                    DragGesture()
                                        .onEnded({ value in
                                            let threashold: CGFloat = 50
                                            if value.translation.width > threashold {
                                                withAnimation {
                                                    currentIndex = max(0, currentIndex - 1)
                                                }
                                            }else if value.translation.width < -threashold{
                                                withAnimation {
                                                    currentIndex = min(walletsViewModel.displayableWallets.count - 1, currentIndex + 1)
                                                }
                                            }
                                        })
                                )
                                .padding(.top, 20)
                                HStack(spacing: 8) {
                                    ForEach(0..<walletsViewModel.displayableWallets.count, id: \.self) { index in
                                        Circle()
                                            .fill(currentIndex == index ? Color.primary : Color.gray) // Active dot is primary color; others are gray
                                            .frame(width: 8, height: 8)
                                            .opacity(currentIndex == index ? 1.0 : 0.5) // Active dot is fully opaque; others are semi-transparent
                                            .scaleEffect(currentIndex == index ? 1.2 : 1) // Active dot is slightly larger
                                    }
                                }
                                .padding(.top, 20)
                                .onChange(of: currentIndex) { oldValue, newValue in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust delay to match your animation duration
                                        let walletID = walletsViewModel.displayableWallets[newValue].id
                                        Task {
                                            await walletsViewModel.fetchWalletStatistics(walletID: walletID)
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                            if let stats = walletsViewModel.walletStatistics {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text("Income").padding(.bottom, 2)
                                            .font(.title3.monospaced())
                                        HStack{
                                            Text((currencySymbols[walletsViewModel.displayableWallets[currentIndex].currency] ?? "$"))
                                                .font(.system(size: 16).monospaced().bold())
                                                .foregroundColor(.green)
                                            
                                            Text(String(format: "%.2f", Float(stats.totalIncome) / 100.0))
                                                .font(.system(size: 16).monospaced().bold())
                                                .foregroundColor(.green)
                                        }
                                    }
                                    Spacer()
                                    VStack {
                                        Text("Expenses").padding(.bottom, 2)
                                            .font(.title3.monospaced())
                                        HStack{
                                            Text((currencySymbols[walletsViewModel.displayableWallets[currentIndex].currency] ?? "$"))
                                                .font(.system(size: 16).monospaced().bold())
                                                .foregroundColor(.red)
                                            
                                            Text(String(format: "%.2f", Float(stats.totalExpenses) / 100.0))
                                                .font(.system(size: 16).monospaced().bold())
                                                .foregroundColor(.red)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                            Spacer()
                            
                            
                            
                            
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
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            Task {
                                viewModel.signOut()
                            }
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.text)
                        }
                    }
                }
                .onAppear {
                    Task {
                        await walletsViewModel.fetchWallets()
                        
                        if let initialWalletID = walletsViewModel.displayableWallets.first?.id {
                            
                            await walletsViewModel.fetchWalletStatistics(walletID: initialWalletID)
                            
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
    
    static let transactionViewModel: TransactionViewModel = {
            let vm = TransactionViewModel()
            
            return vm
    }()
    
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
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        DashboardView()
            .environmentObject(viewModel)
            .environmentObject(transactionViewModel)
            .environmentObject(walletsViewModel)
            .environmentObject(CategoriesViewModel())
        }
}

