//
//  DashboardView.swift
//  budget_app
//
//  Created by Alina Novikova on 28/02/2024.
//

import SwiftUI


struct DashboardView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        if let user = viewModel.currentUser {
            Text(user.username)
            Button{
                Task {
                    viewModel.signOut()
                }
            } label: {
                PrimaryButton(title: "Sign Out")
                    .padding(.bottom, 35)
            }
        }
        
    }
}

#Preview {
    DashboardView()
}
