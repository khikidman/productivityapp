////
////  ScheduleView.swift
////  Productivity
////
////  Created by Khi Kidman on 5/28/25.
////
//
//import Foundation
//import SwiftUI
//
//struct ScheduleView: View{
//    @State private var showAddTask = false
//    @State private var newTaskTitle = ""
//    @State private var newTaskDueDate = Date()
//    
//    @State private var showAddHabit = false
//    @State private var newHabitDescription = ""
//    @State private var newHabitTimestamp = DateComponents()
//    @State private var newHabitTitle = ""
//    
//    @State private var scheduleFrame: CGRect = .zero
//    @State private var scrollViewFrame: CGRect = .zero
//    @State var selectedDay = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//    
//    @EnvironmentObject var todoVM: TodoViewModel
//    
//
//    @EnvironmentObject var habitVM: HabitViewModel
//    
//    
//    var filteredEvents: [ScheduledEvent] {
//        guard let selectedDate = Calendar.current.date(from: selectedDay) else { return [] }
//        let calendar = Calendar.current
//
//        // Filter todos using dueDate directly
//        let todosForDay = todoVM.todoItems.compactMap { todo -> ScheduledEvent? in
//            guard calendar.isDate(todo.dueDate, inSameDayAs: selectedDate) else { return nil }
//
//            let hour = calendar.component(.hour, from: todo.dueDate)
//            let minute = calendar.component(.minute, from: todo.dueDate)
//            let fractionalHour = snappedHour(from: hour, minute: minute)
//
//            return ScheduledEvent(
//                id: todo.id,
//                title: todo.title,
//                startHour: fractionalHour,
//                durationHours: 1,
//                sourceType: .todo
//            )
//        }
//
//        // Filter habits using timestamp (DateComponents)
//        let habitsForDay = habitVM.habitItems.compactMap { habit -> ScheduledEvent? in
//            guard let timestamp = habit.timestamp,
//                  let hour = timestamp.hour else { return nil }
//            
//            let minute = timestamp.minute ?? 0
//            let fractionalHour = snappedHour(from: hour, minute: minute)
//
//            var components = selectedDay
//            components.hour = hour
//            components.minute = minute
//
//            return ScheduledEvent(
//                id: habit.id,
//                title: habit.title,
//                startHour: fractionalHour,
//                durationHours: 1,
//                sourceType: .habit
//            )
//        }
//
//        return (todosForDay + habitsForDay).sorted { $0.startHour < $1.startHour }
//    }
//    
//    let hourHeight: CGFloat = 52
//    
//    var body: some View {
//        VStack {
//            WeekdayHeaderView()
//            WeekdaySelectorView(selectedDay: $selectedDay)
//            ScrollView {
//                ZStack(alignment: .topLeading) {
//                    HourGridView(hourHeight: hourHeight)
//                        .background(
//                            GeometryReader { geo in
//                                Color.clear
//                                    .onAppear {
//                                        scheduleFrame = geo.frame(in: .global)
//                                    }
//                                    .onChange(of: geo.frame(in: .global)) { newFrame in
//                                        scheduleFrame = newFrame
//                                    }
//                            }
//                        )
//
//                    ForEach(filteredEvents) { event in
//                        if event.sourceType == .habit,
//                               let habit = habitVM.habitItems.first(where: { $0.id == event.id }) {
//                                EventCardView(
//                                    event: event,
//                                    hourHeight: hourHeight,
//                                    selectedDate: selectedDay,
//                                    destination: HabitDetailView(habit: habit)
//                                )
//                            } else {
//                                EventCardView(
//                                    event: event,
//                                    hourHeight: hourHeight,
//                                    selectedDate: selectedDay,
//                                    destination: TaskView()
//                                )
//                            }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu {
//                    Button(action: {
//                        showAddTask = true
//                    }) {
//                        Label("Add task", systemImage: "plus")
//                    }
//                    
//                    Button(action: {
//                        showAddHabit = true
//                    }) {
//                        Label("Add habit", systemImage: "plus")
//                    }
//                    
//                    Button(action: {
//                        
//                    }) {
//                        Label("Add event", systemImage: "plus")
//                    }
//                } label: {
//                    Image(systemName: "plus")
//                        .foregroundStyle(.pink)
//                        .imageScale(.large)
//                }
//            }
//        }
//        .dropDestination(for: ScheduledEvent.self) { items, location in
//            guard let dropped = items.first else { return false }
//
//            // Convert drop Y to scroll-relative space
//            let relativeY = location.y - scheduleFrame.minY + hourHeight
//            let totalMinutes = max(0, min(24 * 60 - 15, Int((relativeY / hourHeight) * 60)))
//            
//            let snappedMinutes = Int((Double(totalMinutes) / 15.0).rounded() * 15.0)
//            let newStartHour = snappedMinutes / 60
//            let newStartMinute = snappedMinutes % 60
//
//            if let index = filteredEvents.firstIndex(where: { $0.id == dropped.id }) {
//                    
//                if (dropped.sourceType == .todo) {
//                    if let todoIndex = todoVM.todoItems.firstIndex(where: {$0.id == dropped.id}) {
//                        var updated = todoVM.todoItems[todoIndex]
//                                        let calendar = Calendar.current
//                                        withAnimation(.spring()) {
//                                            todoVM.todoItems[todoIndex].dueDate = calendar.date(
//                                                bySettingHour: newStartHour,
//                                                minute: newStartMinute,
//                                                second: 0,
//                                                of: updated.dueDate
//                                            ) ?? updated.dueDate
//                                        }
//                    }
//                } else if (dropped.sourceType == .habit) {
//                    if let habitIndex = habitVM.habitItems.firstIndex(where: { $0.id == dropped.id }) {
//                        withAnimation(.spring()) {
//                            habitVM.habitItems[habitIndex].timestamp?.hour = newStartHour
//                            habitVM.habitItems[habitIndex].timestamp?.minute = newStartMinute
//                        }
//                    }
//                }
//                return true
//            }
//
//            return false
//        }
//        .toolbarTitleDisplayMode(.inline)
//        .sheet(isPresented: $showAddTask) {
//            AddTaskView(
//                title: $newTaskTitle,
//                dueDate: $newTaskDueDate,
//                onSave: {
//                    let newItem = TodoItem(title: newTaskTitle, dueDate: newTaskDueDate)
//                    todoVM.todoItems.append(newItem)
//                    newTaskTitle = ""
//                    newTaskDueDate = Date()
//                    showAddTask = false
//                },
//                onCancel: {
//                    showAddTask = false
//                }
//            )
//        }
//        .sheet(isPresented: $showAddHabit) {
//            AddHabitView(
//                title: $newHabitTitle,
//                description: $newHabitDescription,
//                timestamp: $newHabitTimestamp,
//                onSave: {
//                    let newHabit = Habit(title: newHabitTitle, description: newHabitDescription, timestamp: newHabitTimestamp)
//                    habitVM.habitItems.append(newHabit)
//                    newHabitTitle = ""
//                    newHabitDescription = ""
//                    newHabitTimestamp = DateComponents()
//                    showAddHabit = false
//                },
//                onCancel: {
//                    showAddHabit = false
//                }
//            )
//        }
//    }
//    
//    func snappedHour(from hour: Int, minute: Int) -> Double {
//        let totalMinutes = Double(hour * 60 + minute)
//        let snappedMinutes = (totalMinutes / 15.0).rounded() * 15.0
//        return snappedMinutes / 60.0
//    }
//}
//
//#Preview {
//    ScheduleView()
//        .environmentObject(TodoViewModel())
//        .environmentObject(HabitViewModel())
//}
