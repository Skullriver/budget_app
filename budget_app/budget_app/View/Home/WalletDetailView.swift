//
//  WalletDetailView.swift
//  budget_app
//
//  Created by Alina Novikova on 18/03/2024.
//

import SwiftUI

struct WalletDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var viewModel: WalletsViewModel
    
    var wallet: Wallet?
    var isNewWallet: Bool
    
    @State private var editableWallet: Wallet
    
    @State private var selectedIcon: String

    let predefinedColors: [String] = ["#E0ACD5", "#B5E2FA", "#F7A072", "#0FA3B1", "#A63A50"]
    
    let icons = ["star.fill", "heart.fill", "house.fill", "car.fill", "airplane", "bicycle", "pencil", "book.fill", "cart.fill", "paperplane.fill"]
    
    
    @State private var pickerColor: Color = .secondary
    @State private var selectedColor: Color
    
    func currencyDisplayString(code: String, symbol: String) -> String {
        return "\(symbol) \(code)"
    }
    
    init(wallet: Wallet? = nil, isNewWallet: Bool) {
        self.wallet = wallet
        self.isNewWallet = isNewWallet
        // Initialize editableCategory and selectedColor in the body instead due to access to EnvironmentObject
        _editableWallet = State(initialValue: wallet ?? Wallet.placeholder)
        _selectedColor = State(initialValue: .gray)
        _selectedIcon = State(initialValue: wallet?.iconCode ?? Wallet.placeholder.iconCode)
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    ZStack{
                        Circle()
                            .fill(Color.secondary.opacity(0.5)) // Adjust the color and opacity as needed
                            .frame(width: 290, height: 150) // Adjust the size to fit your card's perspective
                            .blur(radius: 35) // Adjust the blur to control the softness of the shadow
                            .offset(x: 0, y: 30)
                            .rotation3DEffect(
                                .degrees(20),
                                axis: (x: 1.0, y: 0.0, z: 0.0),
                                anchor: UnitPoint.center,
                                anchorZ: 0.0,
                                perspective: 1.0
                            )
                        VStack {
                            HStack{
                                Text("Name"+editableWallet.name)
                                    .font(.headline.monospaced())
                                    .foregroundColor(selectedColor.isLight ? .text : .white)
                            }
                            .padding()
                            
                            Spacer()
                            
                            HStack{
                                Text((currencySymbols[editableWallet.currency] ?? "$"))
                                    .font(.title.monospaced())
                                    .foregroundColor(selectedColor.isLight ? .text : .white)
                                Text(String(format: "%.2f", Float(editableWallet.initialBalance) / 100.0))
                                    .font(.title.monospaced()) // Apply the same font for consistency
                                    .foregroundColor(selectedColor.isLight ? .text : .white)
                                Spacer()
                                Image(systemName: editableWallet.iconCode)
                                    .font(.title)
                                    .foregroundColor(selectedColor.isLight ? .text : .white)
                            }
                            .padding()
                        }
                        .background(selectedColor)
                        .frame(width: 290, height: 130)
                        .cornerRadius(20)
                        .rotation3DEffect(
                            .degrees(10),
                            axis: (x: 1.0, y: 0.0, z: 0.0),
                            anchor: UnitPoint.center,
                            anchorZ: 0.0,
                            perspective: 1.0
                        )
                    
                    }
                }
                .padding(.bottom, 35)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Wallet Name")
                        .font(.headline.monospaced())
                    
                    TextField("Enter wallet name", text: $editableWallet.name)
                        .padding()
                        .font(.system(size: 16).monospaced())
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                        .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(Color.clear, lineWidth: 1))
                        
                    
                    Text("Initial Balance and Currency")
                        .font(.headline.monospaced())
                    
                    HStack {
                        CurrencyField(value: $editableWallet.initialBalance)
                            .font(.system(size: 16).monospaced())
                        
                        Picker("Currency", selection: $editableWallet.currency) {
                            ForEach(currencySymbols.sorted(by: { $0.key < $1.key }),
                                    id: \.key) { key, value in
                                Text(self.currencyDisplayString(code: key, symbol: value)).tag(key)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Adjust the picker style as needed
                    }
                    
                    // Icon and Label Line
                    HStack {
                        Text("Icon")
                            .font(.headline.monospaced())
                    }
                    
                    // Icon Slider
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(icons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .padding()
                                    .onTapGesture {
                                        self.selectedIcon = icon
                                        editableWallet.iconCode = icon
                                    }
                                    .background(self.selectedIcon == icon ? Color.gray.opacity(0.2) : Color.clear) // Highlight selected icon
                                    .cornerRadius(8)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Color")
                            .font(.headline.monospaced())
                    }
                    ColorSelectionView(selectedColor: $selectedColor,
                                       pickerColor: $pickerColor,
                                       predefinedColors: predefinedColors,
                                       onColorChange: { colorHex in
                                           editableWallet.colorCode = colorHex
                                       })
                    
                    
                }
                .padding()
                
                Spacer()
                
                Button{
                    if (isNewWallet){
                        Task {
                            await viewModel.createWallet(editableWallet)
                            dismiss()
                        }
                    }else{
                        Task {
                            await viewModel.updateWallet(editableWallet)
                            dismiss()
                        }
                    }
                } label: {
                    SecondaryButton(title: "Save")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    if isNewWallet {
                        Text("Add new wallet")
                            .font(.system(size: 20).monospaced().bold())
                            .foregroundColor(Color.text)
                    }else{
                        Text("Edit wallet")
                            .font(.system(size: 20).monospaced().bold())
                            .foregroundColor(Color.text)
                    }
                    
                }
            }
        
        }
        .onAppear {
            // Check if we're adding a new wallet (wallet is nil)
            if wallet == nil {
                // Since this is a new category, set the user_id from the environment object
                editableWallet.userID = authModel.currentUser?.id ?? 0
                // Initialize selectedColor with a default value
                
            } else {
                // For editing an existing category, ensure selectedColor matches the category's color
                selectedColor = Color(hex: wallet?.colorCode ?? "#CCCCCC")
            }
        }
    }
}

struct WalletDetailView_Previews: PreviewProvider {
    
    static let viewModel: CategoriesViewModel = {
            let vm = CategoriesViewModel()
            return vm
    }()
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        WalletDetailView(wallet: Wallet.placeholder, isNewWallet: true).environmentObject(viewModel)
            
        }
}
