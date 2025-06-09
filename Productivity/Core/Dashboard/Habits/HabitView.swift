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
//                Section("Daily") {
//                    ForEach(habitVM.habitItems) { habit in
//                        NavigationLink {
//                            let formatter: DateFormatter = {
//                                let f = DateFormatter()
//                                f.dateStyle = .medium
//                                f.timeStyle = .short
//                                return f
//                            }()
//
//                            VStack {
//                                ForEach(Array(habit.completions).sorted(), id: \.self) { completion in
//                                    Text(formatter.string(from: completion))
//                                }
//                            }
//                        } label: {
//                            HStack {
//                                Image(systemName: habit.iconName)
//                                    .foregroundStyle(.pink)
//                                    .font(.title2)
//                                    .frame(width: 30)
//                                    .padding(.trailing, 4)
//
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(habit.title)
//                                        .font(.headline)
//                                    if !habit.description.isEmpty {
//                                        Text(habit.description)
//                                            .font(.caption)
//                                            .foregroundStyle(.gray)
//                                    }
//                                }
//
//                                Spacer()
//
//                                HStack(spacing: 1) {
//                                    Image(systemName: habit.isCompleted(on: Date().addingTimeInterval(-172800).stripTime()) ? "checkmark.square.fill" : "square")
//                                        .foregroundStyle(.gray)
//                                        .font(.system(size: 12))
//                                    Image(systemName: habit.isCompleted(on: Date().addingTimeInterval(-86400).stripTime()) ? "checkmark.square.fill" : "square")
//                                        .foregroundStyle(.gray)
//                                        .font(.system(size: 14))
//                                    Button{
//                                        if let index = habitVM.habitItems.firstIndex(where: { $0.id == habit.id }) {
//                                                    habitVM.habitItems[index].toggleCompletion(on: Date())
//                                                }
//                                    } label: {
//                                        Image(systemName: habit.isCompleted(on: Date().stripTime()) ? "checkmark.square.fill" : "square")
//                                            .foregroundStyle(.pink)
//                                            .font(.system(size: 24))
//                                    }
//                                    .buttonStyle(.plain)
//                                }
//                                .padding(.trailing, 20)
//                            }
//                            .swipeActions(edge: .trailing) {
//                                Button(role: .destructive) {
//                                    if let index = habitVM.habitItems.firstIndex(where: { $0.id == habit.id }) {
//                                        habitVM.habitItems.remove(at: index)
//                                    }
//                                } label: {
//                                    Label("Delete", systemImage:"trash")
//                                }
//                                .tint(.red)
//                            }
//                        }
//                        .frame(height: 60)
//                    }
//                }
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
                    onSave: {
                        Task {
                            do {
                                let user = try AuthenticationManager.shared.getAuthenticatedUser()
                                let userId = user.uid
                                let newHabit = Habit(id: UUID().uuidString, userId: userId, title: newHabitTitle, description: newHabitDescription, startTime: newHabitStartTime, endTime: newHabitStartTime.addingTimeInterval(1800))
                                try await UserManager.shared.createHabit(userId: userId, habit: newHabit)
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
