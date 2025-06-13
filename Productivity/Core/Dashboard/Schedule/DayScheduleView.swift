//
//  DayScheduleView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/3/25.
//

import Foundation
import SwiftUI

class DayScheduleViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    init(events: [Event] = []) {
        self.events = events
    }
    
    func loadEvents(habits: [Habit], todos: [TodoItem]) {
        events = []
        events = todos.map {
            Event(
                id: $0.id,
                title: $0.title,
                startTime: $0.startTime,
                endTime: $0.endTime ?? $0.startTime.addingTimeInterval(1800),
                sourceType: .todo
            )
        } + habits.compactMap {
            let start = $0.startTime
            let end = $0.endTime ?? start.addingTimeInterval(3600)
            return Event(id: UUID(uuidString: $0.id)!, title: $0.title, startTime: start, endTime: end, sourceType: .habit)
        }
    }
}

struct DayScheduleView: View {
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var habitVM: HabitViewModel
    @Binding var selectedDay: Day
    
    @ObservedObject private var viewModel = DayScheduleViewModel()
    
    @State var hourHeight: CGFloat = 52
    
//    @State private var selectedEditingEventId: UUID? = nil
    
    var body: some View {
        
        ScrollView {
            ZStack (alignment: .topLeading) {
                HourGrid(hourHeight: $hourHeight)
//                    .onTapGesture {
//                        selectedEditingEventId = nil // Tap background → exit edit mode
//                    }
                
                ForEach($viewModel.events, id: \.id) { $event in
                    
                    EventCardView(event: $event)
                    
                }
                .padding(.leading, 65)
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.loadEvents(
                        habits: HabitManager.shared.loadHabits(for: selectedDay.date),
                        todos: todoVM.todoItems
                    )
                    print(viewModel.events)
                } catch {
                    print("failure")
                }
            }
        }
        .onChange(of: selectedDay) {
            Task {
                do {
                    try await viewModel.loadEvents(
                        habits: HabitManager.shared.loadHabits(for: selectedDay.date),
                        todos: todoVM.todoItems
                    )
                    print(selectedDay.date)
                    print(viewModel.events)
                } catch {
                    print("failure")
                }
            }
        }
    }
    
    func snappedDate(from date: Date, toNearestMinutes interval: Int = 15) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        guard let hour = components.hour, let minute = components.minute else {
            return date
        }
        
        // Snap minutes to nearest interval
        let totalMinutes = hour * 60 + minute
        let snappedMinutes = Int(round(Double(totalMinutes) / Double(interval))) * interval
        
        let snappedHour = snappedMinutes / 60
        let snappedMinute = snappedMinutes % 60
        
        var newComponents = components
        newComponents.hour = snappedHour
        newComponents.minute = snappedMinute
        newComponents.second = 0

        return calendar.date(from: newComponents) ?? date
    }
}


extension DayScheduleViewModel {
    static func withSampleData() -> DayScheduleViewModel {
        let vm = DayScheduleViewModel()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        vm.events = [
            Event(
                id: UUID(),
                title: "Morning Run",
                startTime: calendar.date(byAdding: .minute, value: 7 * 60 + 0, to: today)!,  // 7:00 AM
                endTime: calendar.date(byAdding: .minute, value: 9 * 60 + 0, to: today)!,    // 8:00 AM
            )]
        return vm
    }
}

#Preview {
    NewScheduleView()
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}
