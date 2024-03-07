//
//  SecondaryButton.swift
//  budget_app
//
//  Created by Alina Novikova on 07/03/2024.
//

import SwiftUI

struct SecondaryButton: View {
    @State var title: String = "Title"
    
    var body: some View {
        
        Text(title)
            .frame(maxWidth: .screenWidth*0.6)
            .foregroundColor(.white)
            .font(.system(size: 18).monospaced())
            .padding(.vertical, 17)
            .padding(.horizontal, 25)
            .background(Color.secondaryButton)
            .cornerRadius(150)
            .shadow(color: .gray.opacity(0.5), radius: 5, y: 5)
        
    }
}

#Preview {
    SecondaryButton()
}
