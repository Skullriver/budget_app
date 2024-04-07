//
//  PieChartView.swift
//  budget_app
//
//  Created by Alina Novikova on 05/04/2024.
//

import SwiftUI

struct PieChartView: View {
    var statistics: [CategoryStatistic]

    private var totalAmount: Int {
        statistics.reduce(0) { $0 + $1.amount }
    }

    private func angle(for statistic: CategoryStatistic) -> Angle {
        Angle(degrees: Double(360 * statistic.amount / totalAmount))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(statistics.enumerated()), id: \.element.category) { (index, statistic) in
                    PieSlice(startAngle: self.startAngle(at: index), endAngle: self.endAngle(at: index))
                        .fill(statistic.color)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func startAngle(at index: Int) -> Angle {
        if index == 0 { return Angle(degrees: 0) }
        let previousAmounts = statistics.prefix(index).reduce(0) { $0 + $1.amount }
        return Angle(degrees: Double(360 * previousAmounts / totalAmount))
    }
    
    private func endAngle(at index: Int) -> Angle {
        let amounts = statistics.prefix(index + 1).reduce(0) { $0 + $1.amount }
        return Angle(degrees: Double(360 * amounts / totalAmount))
    }
}

