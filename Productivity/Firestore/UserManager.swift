//
//  UserManager.swift
//  Productivity
//
//  Created by Khi Kidman on 6/2/25.
//


import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.firstName = auth.firstName
        self.lastName = auth.lastName
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
    }
    
    init(userId: String, email: String? = nil, firstName: String? = nil, lastName: String? = nil, photoUrl: String? = nil, dateCreated: Date? = nil, isPremium: Bool? = nil) {
        self.userId = userId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func createHabit(userId: String, habit: Habit) async throws {
        try userDocument(userId: userId).collection("habits").document(habit.id).setData(from: habit, merge: false)
    }
    
    func deleteHabit(userId: String, habit: Habit) async throws {
        try await userDocument(userId: userId).collection("habits").document(habit.id).delete()
    }
    
    func getHabits(userId: String) async throws -> [Habit] {
        var habits: [Habit] = []
        
        let query = try await userDocument(userId: userId).collection("habits").getDocuments()
        
        for document in query.documents {
            try habits.append(document.data(as: Habit.self))
        }
        
        return habits
    }
    
    func getHabits(userId: String, date: Date) async throws -> [Habit] {
        var habits: [Habit] = []
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) else {
            throw URLError(.badServerResponse)
        }
        
        let query = try await userDocument(userId: userId).collection("habits").whereField("start_time", isGreaterThanOrEqualTo: startOfDay).whereField("start_time", isLessThanOrEqualTo: endOfDay).getDocuments()
        print(query.isEmpty)
        
        for document in query.documents {
            try habits.append(document.data(as: Habit.self))
        }
        
        return habits
    }
    
    func getHabit(habitId: String) async throws -> Habit {
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        return try await userDocument(userId: userId).collection("habits").document(habitId).getDocument(as: Habit.self)
    }
    
    func updateHabitTime(habit: Habit, startTime: Date?, endTime: Date?) async throws {
        
        let data: [String:Any] = [
            Habit.CodingKeys.startTime.rawValue : startTime ?? habit.startTime,
            Habit.CodingKeys.endTime.rawValue : endTime ?? habit.endTime
        ]
        
        try await userDocument(userId: habit.userId).collection("habits").document(habit.id).updateData(data)
    }
    
}
