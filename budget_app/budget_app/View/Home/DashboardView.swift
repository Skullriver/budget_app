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
        }
    }
}

#Preview {
    DashboardView()
}
