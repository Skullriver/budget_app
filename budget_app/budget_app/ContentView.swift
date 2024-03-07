//
//  ContentView.swift
//  budget_app
//
//  Created by Alina Novikova on 15/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView()
            }else{
                WelcomeView()
            }
        }
    }

}

#Preview {
    ContentView()
}
