//
//  ColorSelectionView.swift
//  budget_app
//
//  Created by Alina Novikova on 18/03/2024.
//

import SwiftUI

struct ColorSelectionView: View {
    
    @Binding var selectedColor: Color
    @Binding var pickerColor: Color
    var predefinedColors: [String]
    var onColorChange: (String) -> Void // Callback when a color is selected

    var body: some View {
        HStack {
            ForEach(predefinedColors, id: \.self) { colorHex in
                Circle()
                    .fill(Color(hex: colorHex)) // Utilize your existing extension method
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        self.selectedColor = Color(hex: colorHex)
                        self.onColorChange(colorHex)
                    }
            }
            ZStack {
                ColorPicker("", selection: $pickerColor, supportsOpacity: false)
                    .scaleEffect(CGSize(width: 1.4, height: 1.4))
                    .labelsHidden()
                    .padding(.leading, 5)
                    .onChange(of: pickerColor, initial: false) { _,_ in
                        let colorHex = pickerColor.toHexString() ?? "#CCCCCC"
                        self.selectedColor = pickerColor
                        self.onColorChange(colorHex)
                    }
            }
        }
    }
}


struct ColorSelectionView_Previews: PreviewProvider {

    static var previews: some View {
        
        @State var selectedColor: Color = .secondary // Default color
        @State var pickerColor: Color = .secondary // Default color
        let predefinedColors = ["#E0ACD5", "#B5E2FA", "#F7A072", "#0FA3B1", "#A63A50"]
        
        
        ColorSelectionView(selectedColor: $selectedColor, pickerColor: $pickerColor, predefinedColors: predefinedColors, onColorChange: {_ in })
            
        }
}
