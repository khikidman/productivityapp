import Foundation

struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var startTime: Date
    var endTime: Date?
    var completed: Bool = false
    
    init(id: UUID = UUID(), title: String, startTime: Date = Date(), endTime: Date = Date().addingTimeInterval(3600), completed: Bool = false) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.completed = completed
    }
}
