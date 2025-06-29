import Foundation
import SwiftUI

struct Habit: Identifiable, Codable {
    let id: String
    let userId: String
    var title: String
    var description: String
    var createdDate: Date
    var startTime: Date
    var endTime: Date?
    var iconName: String
    var colorHex: String
    var category: String?
    var repeatRule: HabitRepeatRule
    var sharedWith: [String]?
    
//    mutating func markComplete(on date: Date = Date()) {
//        completions.insert(date.stripTime())
//    }
//    
    func toggleCompletion(on date: Date = Date()) async throws {
        try await HabitManager.shared.toggleCompletion(for: self, on: date)
    }
//    
//    func isCompleted(on date: Date = Date()) -> Bool {
//        return completions.contains(date.stripTime())
//    }
    
    func isCompleted(on date: Date) async throws -> Bool {
        return try await UserManager.shared.isCompleted(habit: self, date: date)
    }
    
    init(id: String, userId: String, title: String, description: String, createdDate: Date = Date(), startTime: Date = Date(), endTime: Date? = nil, iconName: String = "repeat", colorHex: String = "#ff375f", category: String = "Uncategorized", repeatRule: HabitRepeatRule = .daily, sharedWith: [String] = []) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.createdDate = createdDate
        self.startTime = startTime
        self.endTime = endTime
        self.iconName = iconName
        self.colorHex = colorHex
        self.category = category
        self.repeatRule = repeatRule
        self.sharedWith = sharedWith
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case title = "title"
        case description = "description"
        case createdDate = "created_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case iconName = "icon_name"
        case colorHex = "color_hex"
        case category = "category"
        case repeatRule = "repeat_rule"
        case sharedWith = "shared_with"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.createdDate = try container.decode(Date.self, forKey: .createdDate)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        self.iconName = try container.decode(String.self, forKey: .iconName)
        self.colorHex = try container.decode(String.self, forKey: .colorHex)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
        self.repeatRule = try container.decodeIfPresent(HabitRepeatRule.self, forKey: .repeatRule) ?? .daily
        self.sharedWith = try container.decodeIfPresent([String].self, forKey: .sharedWith) ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.createdDate, forKey: .createdDate)
        try container.encodeIfPresent(self.startTime, forKey: .startTime)
        try container.encodeIfPresent(self.endTime, forKey: .endTime)
        try container.encodeIfPresent(self.iconName, forKey: .iconName)
        try container.encodeIfPresent(self.colorHex, forKey: .colorHex)
        try container.encodeIfPresent(self.category, forKey: .category)
        try container.encode(self.repeatRule, forKey: .repeatRule)
        try container.encodeIfPresent(self.sharedWith, forKey: .sharedWith)
    }
}

extension Habit {
    func isScheduled(for date: Date) -> Bool {
        let calendar = Calendar.current
        switch repeatRule {
            case .none:
                let startTime = startTime
                return calendar.isDate(startTime, inSameDayAs: date)
                
            case .daily:
                return true
                
            case .weekly(let weekdays):
                let weekday = calendar.component(.weekday, from: date)
                return weekdays.contains(weekday)
                
            case .monthly(let days):
                let day = calendar.component(.day, from: date)
                return days.contains(day)
        default:
            return true
        }
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .blue // fallback if invalid
    }
}

enum HabitRepeatRule: Codable {
    case none
    case daily
    case weekly([Int])   // weekdays: 1 = Sunday, ..., 7 = Saturday
    case monthly([Int])  // days of month: 1...31
    case everyNDays(Int) // every N days
}

extension HabitRepeatRule {
    var displayName: String {
        switch self {
        case .none: return "None"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .everyNDays(let n): return "Every \(n) Days"
        }
    }
}


final class HabitManager {
    
    static let shared = HabitManager()
    private init() {}
    
    var habits: [Habit] = []
    
    func loadHabits() async throws -> [Habit] {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        return try await UserManager.shared.getHabits(userId: userId)
    }
    
    func loadHabits(for date: Date) async throws -> [Habit] {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        let allHabits = try await UserManager.shared.getHabits(userId: userId)
        return allHabits.filter { $0.isScheduled(for: date) }
    }
    
    func loadHabit(habitId: String) async throws -> Habit {
        return try await UserManager.shared.getHabit(habitId: habitId)
    }
    
    func shareHabit(habit: Habit, with recipientIds: [String]) async throws {
        try await UserManager.shared.shareHabit(habit: habit, with: recipientIds)
    }
    
    func toggleCompletion(for habit: Habit, on date: Date) async throws {
        if try await UserManager.shared.isCompleted(habit: habit, date: date) {
            try await UserManager.shared.removeCompletion(habit: habit, date: date)
        } else {
            try await UserManager.shared.addCompletion(habit: habit, date: date)
        }
    }
    
}


extension Date {
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}
