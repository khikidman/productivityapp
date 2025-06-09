//
//  Week.swift
//  Productivity
//
//  Created by Khi Kidman on 6/8/25.
//

import Foundation

struct Week: Identifiable {
    let id = UUID()
    let startDate: Date
    let days: [Day]
}

extension Calendar {
    func generateWeek(for date: Date, calendar: Calendar = Calendar.current) -> Week {
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date)!
        let startDate = weekInterval.start
        
        var days: [Day] = []
        for i in 0..<7 {
            if let dayDate = calendar.date(byAdding: .day, value: i, to: startDate) {
                days.append(Day(date: dayDate))
            }
        }
        
        return Week(startDate: startDate, days: days)
    }
}
