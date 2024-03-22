//
//  WalletsView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI

struct WalletView: View {
    
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    @EnvironmentObject var viewModel: WalletsViewModel
    
    @State private var isPresented: Bool = false
    @State private var showingDeleteConfirmation = false
    @State private var walletToDelete: Wallet?
    
    @State private var showingActionSheet = false
    @State private var selectedWallet: Wallet?
    @State private var navigateToEditView = false
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView() {
                    if viewModel.isLoading {
                        ProgressView()
                    }else{
                        ZStack{
                            ForEach(0..<viewModel.wallets.count, id: \.self ) { index in
                                VStack {
                                    HStack{
                                        Text(viewModel.wallets[index].name)
                                            .font(.headline)
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Text((currencySymbols[viewModel.wallets[index].currency] ?? "$"))
                                            .font(.title3.monospaced())
                                        
                                        Text(String(format: "%.2f", Float(viewModel.wallets[index].balance) / 100.0))
                                            .font(.title3.monospaced())
                                        Spacer()
                                        Image(systemName: viewModel.wallets[index].iconCode)
                                            .font(.largeTitle)
                                    }
                                    .padding()
                                }
                                .frame(width: 250, height: 150)
                                .background(Color(hex: viewModel.wallets[index].colorCode))
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
                                            currentIndex = min(viewModel.wallets.count - 1, currentIndex + 1)
                                        }
                                    }
                                })
                        )
                        HStack(spacing: 8) {
                            ForEach(0..<viewModel.wallets.count, id: \.self) { index in
                                Circle()
                                    .fill(currentIndex == index ? Color.primary : Color.gray) // Active dot is primary color; others are gray
                                    .frame(width: 8, height: 8)
                                    .opacity(currentIndex == index ? 1.0 : 0.5) // Active dot is fully opaque; others are semi-transparent
                                    .scaleEffect(currentIndex == index ? 1.2 : 1) // Active dot is slightly larger
                            }
                        }
                        .padding(.top, 20)
                        
                        LazyVStack {
                            ForEach(0..<viewModel.wallets.count, id: \.self ) { index in
                                HStack {
                                    Circle()
                                        .fill(Color(hex: viewModel.wallets[index].colorCode))
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: viewModel.wallets[index].iconCode)
                                                .foregroundColor(.white)
                                        )
                                    Text(viewModel.wallets[index].name)
                                        .font(.title3.monospaced())
                                    
                                    Spacer()
                                    
                                    Text((currencySymbols[viewModel.wallets[index].currency] ?? "$"))
                                        .font(.title3.monospaced())
                                    
                                    Text(String(format: "%.2f", Float(viewModel.wallets[index].balance) / 100.0))
                                        .font(.title3.monospaced())
                                }
                                .onTapGesture {
                                    self.selectedWallet = viewModel.wallets[index]
                                    self.showingActionSheet = true
                                }
                                .padding()
                            }
                        }
                        .actionSheet(isPresented: $showingActionSheet) {
                            actionSheet(for: selectedWallet)
                        }
                        .fullScreenCover(isPresented: $navigateToEditView) {
                            WalletDetailView(wallet: selectedWallet, isNewWallet: false)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Wallets")
                            .font(.system(size: 20).monospaced().bold())
                          .foregroundColor(Color.text)
                    }
                }
            }
            .background(Color.background)
            .sheet(isPresented: $isPresented) {
                WalletDetailView(isNewWallet: true)
            }
            .alert("Confirm Delete", isPresented: $showingDeleteConfirmation) {
                Button("Cancel Delete", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let walletToDelete = walletToDelete {
                        Task {
                            await viewModel.deleteWallet(walletToDelete.id)
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete this wallet?")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchWallets()
            }
        }
    }
    
    func actionSheet(for wallet: Wallet?) -> ActionSheet {
        ActionSheet(title: Text("Select Action"), message: nil, buttons: [
            .default(Text("Edit")) {
                self.navigateToEditView = true
            },
            .destructive(Text("Delete")) {
                self.walletToDelete = wallet
                self.showingDeleteConfirmation = true
            },
            .cancel()
        ])
    }
}

struct WalletView_Previews: PreviewProvider {
    
    static let viewModel: WalletsViewModel = {
            let vm = WalletsViewModel()
            vm.wallets = [
                Wallet(id: 1, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 2, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 3, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                Wallet(id: 4, userID: -1, name: "Groceries", currency: "USD", initialBalance: 10000, balance: 10000, iconCode: "cart", colorCode: "#FF0000", createdAt: ""),
                
            ]
            return vm
    }()
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        WalletView().environmentObject(viewModel)

            
        }
}
