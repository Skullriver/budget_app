//
//  budget_appApp.swift
//  budget_app
//
//  Created by Alina Novikova on 15/02/2024.
//

import SwiftUI

@main
struct budget_appApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
