//
//  extensions.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

extension Array where Element == Habit {
    func groupedByCategory() -> [String: [Habit]] {
        Dictionary(grouping: self) { $0.category ?? "Uncategorized" }
    }
}

func currentWeekDays() -> [Int] {
    let calendar = Calendar.current
    let today = Date()

    // Get the weekday index of today (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
    let weekday = calendar.component(.weekday, from: today)

    // Get the start of the week (e.g., previous Sunday or Monday depending on locale)
    let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - calendar.firstWeekday), to: today)!

    // Collect the 7 days in the current week
    return (0..<7).compactMap { offset in
        let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
        return calendar.component(.day, from: date)
    }
}

extension NewScheduleView {

    static func formatHour(_ hour: Int) -> some View {
        let label: String
        let suffix: String?

        if hour == 0 {
            label = "12"
            suffix = "AM"
        } else if hour == 12 {
            label = "Noon"
            suffix = nil
        } else if hour < 12 {
            label = "\(hour)"
            suffix = "AM"
        } else {
            label = "\(hour - 12)"
            suffix = "PM"
        }

        return HStack(spacing: 0) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.primary.opacity(0.7))
                .padding(.bottom, 2)
                .bold()
            if let suffix {
                Text(" \(suffix)")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .opacity(0.6)
            }
        }
    }
}

extension DateComponents {
    var date: Date? {
        Calendar.current.date(from: self)
    }
}
