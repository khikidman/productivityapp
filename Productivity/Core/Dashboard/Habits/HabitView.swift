//
//  HabitView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct HabitView: View{
    
    @State private var newHabitTitle = ""
    @State private var newHabitDescription = ""
    @State private var newHabitStartTime = Date()
    @State private var newHabitEndTime = Date().addingTimeInterval(3600)
    @State private var showAddHabit = false;
    
    @EnvironmentObject var habitVM: HabitViewModel
    
    private let habitCategorizer = HabitCategorizer()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($habitVM.habitItems) { $habit in
                    HabitCardView(habit: $habit)
                        .environmentObject(habitVM)
//                    Section(habitCategorizer.categorize(habitText: habit.title)) {
//                        // TEMP
//                        NavigationLink() {
//                            HabitDetailView(habit: habit)
//                        } label: {
//                            HabitCardView(habit: $habit)
//                                .environmentObject(habitVM)
//                        }
//                        .frame(height: 60)
//                        
//                        // END TEMP
//                    }
                    
                }
            }
            .listRowSpacing(8)
            .navigationTitle("Habits")
            .toolbar() {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showAddHabit = true
                        } label: {
                            Label("Add Habit", systemImage: "square.and.pencil")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(
                    title: $newHabitTitle,
                    description: $newHabitDescription,
                    startTime: $newHabitStartTime,
                    endTime: $newHabitEndTime,
                    onSave: { habit in
                        Task {
                            do {
                                let user = try AuthenticationManager.shared.getAuthenticatedUser()
                                let userId = user.uid
                                try await UserManager.shared.createHabit(userId: userId, habit: habit)
                                showAddHabit = false
                            } catch {
                                showAddHabit = false
                            }
                        }
                    },
                    onCancel: {
                        showAddHabit = false
                    }
                )
            }
            
        }
    }
}
