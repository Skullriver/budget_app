//
//  PrimaryButton.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI

struct PrimaryButton: View {
    @State var title: String = "Title"
    
    var body: some View {
        
        Text(title)
            .frame(maxWidth: .screenWidth*0.6)
            .foregroundColor(.white)
            .font(.system(size: 18).monospaced())
            .padding(.vertical, 17)
            .padding(.horizontal, 25)
            .background(Color.primaryButton)
            .cornerRadius(150)
            .shadow(color: .gray.opacity(0.5), radius: 5, y: 5)
        
    }
}


#Preview {
    PrimaryButton()
}
