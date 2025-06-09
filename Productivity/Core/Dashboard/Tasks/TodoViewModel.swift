import Foundation
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todoItems: [TodoItem] = [] {
        didSet {
            saveTasks()
        }
    }

    private let fileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("todoItems.json")
    }()

    init() {
        loadTasks()
    }

    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(todoItems)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save tasks:", error)
        }
    }

    private func loadTasks() {
        do {
            let data = try Data(contentsOf: fileURL)
            todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("No existing task file or failed to load:", error)
            todoItems = []
        }
    }
}
