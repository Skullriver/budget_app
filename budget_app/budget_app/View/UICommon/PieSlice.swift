//
//  PieSlice.swift
//  budget_app
//
//  Created by Alina Novikova on 05/04/2024.
//

import SwiftUI

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.closeSubpath()
        }
    }
}


#Preview {
    PieSlice(startAngle: Angle(degrees: 10), endAngle: Angle(degrees: 30))
}
