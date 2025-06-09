//
//  WeekdayHeaderView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct WeekdayHeaderView: View {
    let weekdayLetters: [String] = {
        let formatter = DateFormatter()
        formatter.locale = .current
        return formatter.shortWeekdaySymbols.map { String($0.prefix(1)) }
    }()

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(weekdayLetters.enumerated()), id: \.offset) { index, letter in
                Text(letter)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
        }
        .frame(height: 20)
    }
}
