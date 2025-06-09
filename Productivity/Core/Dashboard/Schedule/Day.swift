//
//  Day.swift
//  Productivity
//
//  Created by Khi Kidman on 6/8/25.
//

import Foundation

struct Day: Identifiable, Hashable, Equatable {
    let id = UUID()
    let date: Date
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
}

extension Day {
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(date)
    }
}
