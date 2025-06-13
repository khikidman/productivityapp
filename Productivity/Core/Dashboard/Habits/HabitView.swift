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
    @State private var showAddHabit = false;
    
    @EnvironmentObject var habitVM: HabitViewModel
    
    private let habitCategorizer = HabitCategorizer()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($habitVM.habitItems) { $habit in
                    Section(habitCategorizer.categorize(habitText: habit.title)) {
                        // TEMP
                        NavigationLink() {
                            HabitDetailView(habit: habit)
                        } label: {
                            HabitCardView(habit: $habit)
                                .environmentObject(habitVM)
                        }
                        .frame(height: 60)
                        
                        // END TEMP
                    }
                    
                }
            }
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
