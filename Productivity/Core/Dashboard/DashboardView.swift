//
//  DashboardView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct DashboardView: View{
    
    @State private var showAddTask = false
    @State private var newTaskTitle = ""
    @State private var newTaskStartTime = Date()
    @Binding var selectedTab: MainTab

    
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var habitVM: HabitViewModel
    
    let maxTasksDisplayed = 3
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        NewScheduleView(selectedDay: .constant(Day(date: Date())))
                            .environmentObject(todoVM)
                            .environmentObject(habitVM)
                        
                    } label: {
                        Label() {
                            Text("Schedule")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "calendar")
                                .foregroundStyle(.pink)
                        }
                    }
                    .tint(.pink)
                }
                
                Section {
                    NavigationLink {
                        TaskView()
                            .environmentObject(todoVM)
                    } label: {
                        Label() {
                            Text("Tasks")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(.pink)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    UpcomingTasksScrollView(todoVM: todoVM, maxTasksDisplayed: maxTasksDisplayed, showAddTask: $showAddTask)
                        .frame(maxWidth: .infinity)
                }
                Section() {
                    NavigationLink {
                        HabitView()
                            .environmentObject(habitVM)
                    } label: {
                        Label() {
                            Text("Habits")
                                .foregroundStyle(.primary)
                        } icon: {
                            Image(systemName: "square.grid.3x3.topleft.filled")
                                .foregroundStyle(.pink)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .listSectionSpacing(16)
            .navigationTitle("Dashboard")
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(
                title: $newTaskTitle,
                startTime: $newTaskStartTime,
                onSave: {
                    let newItem = TodoItem(title: newTaskTitle, startTime: newTaskStartTime)
                    todoVM.todoItems.append(newItem)
                    newTaskTitle = ""
                    newTaskStartTime = Date()
                    showAddTask = false
                },
                onCancel: {
                    showAddTask = false
                }
            )
        }
        .tint(.pink)
        .backgroundStyle(.windowBackground)
    }
}

struct DashboardTaskCardView: View {
    @Binding var todoItem: TodoItem
    @ObservedObject var todoVM: TodoViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(todoItem.title)
                .font(.headline)
            
            Text(dateFormatter(for: .timeOnly).string(from: todoItem.startTime))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: {
                todoItem.completed.toggle()
                if let index = todoVM.todoItems.firstIndex(where: { $0.id == todoItem.id }) {
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation {
                            todoVM.todoItems.remove(at: index)
                        }
                    }
                }
            }) {
                Image(systemName: todoItem.completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.pink)
                    .font(.system(size: 20))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 6)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    enum DateDisplayStyle {
        case timeOnly
        case dateOnly
        case dateAndTime
    }
    
    func dateFormatter(for style: DateDisplayStyle) -> DateFormatter {
        let formatter = DateFormatter()
        
        switch style {
        case .timeOnly:
            formatter.dateFormat = "h:mm a"
        case .dateOnly:
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        case .dateAndTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
        }
        
        return formatter
    }
}

struct UpcomingTasksScrollView: View {
    @ObservedObject var todoVM: TodoViewModel
    let maxTasksDisplayed: Int
    @Binding var showAddTask: Bool
    
    var body: some View {
        let numTasksDisplayed = min(maxTasksDisplayed, todoVM.todoItems.count)
        
        VStack(alignment: .leading, spacing: 8) {
            Text("Upcoming")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(Array($todoVM.todoItems).prefix(numTasksDisplayed)) { $todoItem in
                        DashboardTaskCardView(todoItem: $todoItem, todoVM: todoVM)
                        
                    }
                    Button(action: {
                        showAddTask = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                    }
                    .padding(.leading, 4)
                }
                .padding(.horizontal, 3)
            }
        }
    }
}

#Preview {
    MainView(showSignInView: .constant(true))
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}
