import Foundation
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habitItems: [Habit] = [] {
        didSet {
            saveTasks()
        }
    }

    private let fileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("habitItems.json")
    }()

    init() {
        Task {
            try await loadHabits()
        }
    }

    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(habitItems)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save tasks:", error)
        }
    }

    private func loadHabits() async throws {
        do {
            let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
            habitItems = try await UserManager.shared.getHabits(userId: userId)
        } catch {
            print("Error loading habits: \(error)")
        }
    }
}
