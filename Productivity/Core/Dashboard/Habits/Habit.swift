import Foundation

struct Habit: Identifiable, Codable {
    let id: String
    let userId: String
    var title: String
    var description: String
    var createdDate: Date
    var startTime: Date?
    var endTime: Date?
    var iconName: String
    var category: String?
    
//    mutating func markComplete(on date: Date = Date()) {
//        completions.insert(date.stripTime())
//    }
//    
//    mutating func toggleCompletion(on date: Date = Date()) {
//        let day = date.stripTime()
//        if completions.contains(day) {
//            completions.remove(day)
//        } else {
//            completions.insert(day)
//        }
//    }
//    
//    func isCompleted(on date: Date = Date()) -> Bool {
//        return completions.contains(date.stripTime())
//    }
    
    init(id: String, userId: String, title: String, description: String, createdDate: Date = Date(), startTime: Date = Date(), endTime: Date? = nil, iconName: String = "repeat", category: String = "Uncategorized") {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.createdDate = createdDate
        self.startTime = startTime
        self.endTime = endTime
        self.iconName = iconName
        self.category = category
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
        case category = "category"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.createdDate = try container.decode(Date.self, forKey: .createdDate)
        self.startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        self.endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        self.iconName = try container.decode(String.self, forKey: .iconName)
        self.category = try container.decodeIfPresent(String.self, forKey: .category)
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
        try container.encodeIfPresent(self.category, forKey: .category)
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
        return try await UserManager.shared.getHabits(userId: userId, date: date)
    }
    
    func loadHabit(habitId: String) async throws -> Habit {
        return try await UserManager.shared.getHabit(habitId: habitId)
    }
    
}


extension Date {
    func stripTime() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}
