//
//  CategoryDetailView.swift
//  budget_app
//
//  Created by Alina Novikova on 11/03/2024.
//

import SwiftUI

struct CategoryDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var viewModel: CategoriesViewModel
    
    var isNewCategory: Bool
    var category: Category?
    
    // If adding a new category, use a temporary in-memory category object
    @State private var editableCategory: Category

    // Predefined colors for quick selection
    let predefinedColors: [String] = ["#E0ACD5", "#B5E2FA", "#F7A072", "#0FA3B1", "#A63A50"]
        // Example icons
    let icons = ["cart.fill", "cart", "basket.fill", "creditcard.fill", "bolt.fill", "house.fill", "music.note", "book.fill", "car.fill", "fork.knife",
                 "leaf.fill", "person.fill", "sun.max.fill", "crown.fill", "moon.fill", "flame.fill", "drop.fill", "cross.case.fill", "suitcase.cart.fill", "movieclapper", "film", "gamecontroller.fill", "cup.and.saucer.fill", "wineglass.fill", "gift.fill",
                 "heart.fill", "star.fill", "airplane", "phone.fill", "envelope.fill", "waveform",
                 "sparkles", "cloud.fill", "snowflake", "hurricane", "map.fill", "bus.doubledecker",
                 "tram.fill", "bicycle", "fuelpump.fill", "binoculars.fill", "pencil.line", "headphones", "pencil.and.outline", "theatermasks.fill", "lightbulb.fill", "powerplug.fill",
                 "trash.fill", "folder.fill", "books.vertical.fill", "text.book.closed.fill", "bookmark.fill", "graduationcap.fill", "shower.fill",
                 "pencil.and.ruler.fill", "backpack.fill", "paperclip", "link", "photo.artframe", "dumbbell.fill", "soccerball.inverse",
                 "baseball.fill", "basketball.fill", "tennis.racket",
                 "volleyball.fill", "gym.bag.fill", "trophy.fill", "medal.fill", "beach.umbrella.fill", "megaphone.fill", "music.mic", "magnifyingglass", "shield.lefthalf.filled", "shield.checkered", "flag.fill", "flag.checkered", "bell.fill", "tag.fill", "camera.fill", "scissors", "pianokeys.inverse", "die.face.6", "paintbrush.fill", "hammer.fill", "wrench.and.screwdriver.fill", "handbag.fill", "party.popper.fill", "balloon.2.fill", "popcorn.fill", "washer.fill", "key.fill", "stroller.fill", "bandage.fill", "pills.fill","camera.macro", "eyes.inverse", "mustache.fill", "brain.fill", "banknote.fill", "globe.europe.africa.fill", "cat.fill", "dog.fill",
    ]
    
    private var gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 6) // Adjust count based on your preference


    @State private var selectedColor: Color
    @State private var pickerColor: Color = .secondary
    
    init(category: Category? = nil, isNewCategory: Bool) {
        self.category = category
        self.isNewCategory = isNewCategory
        // Initialize editableCategory and selectedColor in the body instead due to access to EnvironmentObject
        _editableCategory = State(initialValue: category ?? Category.placeholder)
        _selectedColor = State(initialValue: .gray)
    }
        
    var body: some View {
        
        NavigationView{
            VStack{
                // Current category icon and color
                Circle()
                    .foregroundColor(selectedColor)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: editableCategory.icon)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    )
                    .padding(.top, 20)
                                
                // Text field for category name
                TextField("Category Name", text: $editableCategory.name)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                // Predefined color selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(predefinedColors, id: \.self) { colorHex in
                            Circle()
                                .fill(Color(hex: colorHex))
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    selectedColor = Color(hex: colorHex)
                                    editableCategory.color = colorHex
                                }
                        }
                        ZStack {
                            ColorPicker("", selection: $pickerColor, supportsOpacity: false)
                                .scaleEffect(CGSize(width: 1.4, height: 1.4))
                                .labelsHidden()
                                .padding(.leading, 5)
                        }
                        
                    }
                }
                .padding()

                
                // Horizontal scrolling list of icons
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.secondary)
                                .onTapGesture {
                                    editableCategory.icon = icon
                                }
                        }
                    }
                }
                .padding()
                
                Spacer()
                
            }
            .background(Color.background)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    if isNewCategory {
                        Text("Add new category")
                            .font(.system(size: 20).monospaced().bold())
                            .foregroundColor(Color.text)
                    }else{
                        Text("Edit category")
                            .font(.system(size: 20).monospaced().bold())
                            .foregroundColor(Color.text)
                    }
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if (isNewCategory){
                            Task {
                                await viewModel.createCategory(editableCategory)
                                dismiss()
                            }
                        }else{
                            Task {
                                await viewModel.updateCategory(editableCategory)
                                dismiss()
                            }
                        }
                        
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
        .onChange(of: pickerColor, initial: false) { _,_ in
            self.selectedColor = pickerColor
            editableCategory.color = pickerColor.toHexString() ?? "#CCCCCC"
        }
        .onAppear {
            // Check if we're adding a new category (category is nil)
            if category == nil {
                // Since this is a new category, set the user_id from the environment object
                editableCategory.user_id = authModel.currentUser?.id ?? 0
                // Initialize selectedColor with a default value
                
            } else {
                // For editing an existing category, ensure selectedColor matches the category's color
                selectedColor = Color(hex: category?.color ?? "#CCCCCC")
            }
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    
    static let viewModel: CategoriesViewModel = {
            let vm = CategoriesViewModel()
            return vm
    }()
    
    static var previews: some View {
            // Instantiate CategoryView normally
        
        CategoryDetailView(category: Category.placeholder, isNewCategory: false).environmentObject(viewModel)
            
        }
}
