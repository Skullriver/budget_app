//
//  TabBarView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var transactionViewModel: TransactionViewModel
    
    @Binding var tabSelection: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(height: 65)
                .foregroundColor(.background)
                .shadow(radius: 5, x:0, y:0)
                .mask(Rectangle().padding(.top, -15))
            
            
            HStack {
                Spacer()
                Button{
                    tabSelection = 0
                } label: {
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Image(tabSelection == 0 ? "home.selected" : "home")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                        
                        Text("Home")
                            .font(.system(size: 12).monospaced())
                            .foregroundColor(tabSelection == 0 ? .primaryButton : .text.opacity(0.5))
                        Spacer()
                    }
                    .frame(width: 65)
                }
                
                Button{
                    tabSelection = 1
                } label: {
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Image("budget")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .foregroundColor(tabSelection == 1 ? .primaryButton : .text.opacity(0.5))
                        
                        Text("Budget")
                            .font(.system(size: 12).monospaced())
                            .foregroundColor(tabSelection == 1 ? .primaryButton : .text.opacity(0.5))
                        Spacer()
                    }
                    .frame(width: 65)
                }
                
                Rectangle()
                    .fill(.clear)
                    .frame(width: 74, height: 0)
                
                Button{
                    tabSelection = 2
                } label: {
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Image("transactions")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .foregroundColor(tabSelection == 2 ? .primaryButton : .text.opacity(0.5))
                        
                        Text("Log")
                            .font(.system(size: 9).monospaced())
                            .foregroundColor(tabSelection == 2 ? .primaryButton : .text.opacity(0.5))
                        Spacer()
                    }
                    .frame(width: 65)
                }
                
                Button{
                    tabSelection = 3
                } label: {
                    VStack(spacing: 8) {
                        Spacer()
                        
                        Image("wallets")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .foregroundColor(tabSelection == 3 ? .primaryButton : .text.opacity(0.5))
                        
                        Text("Wallets")
                            .font(.system(size: 12).monospaced())
                            .foregroundColor(tabSelection == 3 ? .primaryButton : .text.opacity(0.5))
                        Spacer()
                    }
                    .frame(width: 65)
                }
                Spacer()
            }
            .frame(height: 65)
            
            Button{
                transactionViewModel.isNewTransactionVisible.toggle()
            }label: {
                Image("plus")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
            }
            .padding(.bottom, 15)
        }
    }
}

struct TabBarView_Previews : PreviewProvider {
    static var previews: some View {
        TabBarView(tabSelection: .constant(1))
    }
}
