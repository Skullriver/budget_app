//
//  UIExtension.swift
//  budget_app
//
//  Created by Alina Novikova on 25/02/2024.
//

import SwiftUI
import Combine

extension CGFloat {
    
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }

}

extension String {
    
    func isEmailValidCheck(_ email: String) -> Bool {
        
        let regExMatchEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let predicateEmail = NSPredicate(format:"SELF MATCHES %@", regExMatchEmail)
        
        return predicateEmail.evaluate(with: email)
        
    }
    
}


struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
       ).eraseToAnyPublisher()
    }

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func keyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}

