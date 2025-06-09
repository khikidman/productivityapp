//
//  ProductivityApp.swift
//  Productivity
//
//  Created by Khi Kidman on 5/10/25.
//

import SwiftUI
import Firebase

@main
struct ProductivityApp: App {
    @StateObject private var todoVM = TodoViewModel()
    @StateObject private var habitVM = HabitViewModel()
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase!")
    }
    
    var body: some Scene {
        WindowGroup {
//            NewScheduleView()
            RootView()
                .environmentObject(todoVM)
                .environmentObject(habitVM)

            .tint(.pink)
        }
    }
}

#Preview {
    MainView(showSignInView: .constant(true))
        .environmentObject(HabitViewModel())
        .environmentObject(TodoViewModel())
}
