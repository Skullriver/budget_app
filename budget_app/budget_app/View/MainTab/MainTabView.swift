//
//  MainTabView.swift
//  budget_app
//
//  Created by Alina Novikova on 03/03/2024.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var tabSelection = 0
    @EnvironmentObject var tabViewModel: TabViewModel
    
    var body: some View {
        TabView(selection: $tabSelection) {
            DashboardView()
                .tag(0)
            
            BudgetView()
                .tag(1)
            
            TransactionsView()
                .tag(2)
            
            TransactionsView()
                .tag(3)
        }
        .overlay(alignment: .bottom) {
            TabBarView(tabSelection: $tabSelection)
        }
    }
}

struct MainTabView_Previews : PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
