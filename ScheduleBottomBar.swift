//
//  ScheduleBottomBarTest.swift
//  Productivity
//
//  Created by Khi Kidman on 7/2/25.
//

import SwiftUI

enum ShiftDirection {
    case backward
    case forward
}

class ScheduleBottomBarViewModel: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedDay: Day = Day(date: Date())
    @Published var targetedWeekStart: Date?
    
    func initWeeks(around date: Date, window: Int = 2) {
        let calendar = Calendar.current
        let startOfCurrentWeek = calendar.dateInterval(of: .weekOfYear, for: date)!.start
        weeks = (-window...window).map { offset in
            let weekStart = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfCurrentWeek)!
            let days = (0..<7).map { dayOffset in
                Day(date: calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!)
            }
            return Week(startDate: weekStart, days: days)
        }
    }
    
    func shift(in direction: ShiftDirection) {
        switch direction {
        case .backward:
            targetedWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: targetedWeekStart!)
            // Handle day selection update
        case .forward:
            targetedWeekStart = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: targetedWeekStart!)
            // Handle day selection update
        }
    }
    
}

struct ScheduleBottomBar: View {
    @StateObject var vm = ScheduleBottomBarViewModel()
    @State var isDragging: Bool = false
    @State var lastSelectedWeekStart: Date?
    
    static let dayOnlyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d"
        return df
    }()
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(vm.weeks) { week in
                    HStack {
                        ForEach(week.days) { day in
                            Circle()
                                .fill(vm.selectedDay == day ? .pink : .white.opacity(0.0))
                                .overlay (
                                    Text(Self.dayOnlyFormatter.string(from: day.date))
                                )
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    vm.selectedDay = day
                            }
                        }
                    }
                    .frame(width: 400)
                    .id(week.startDate)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $vm.targetedWeekStart)
        .gesture {
            DragGesture()
                .updating {
                    if (!isDragging) {
                        isDragging = true
                        lastSelectedWeekStart = vm.targetedWeekStart
                    }
                }
                .onEnded { _ in
                    if (lastSelectedWeekStart != vm.targetedWeekStart) {
                        let diff = vm.targetedWeekStart > lastSelectedWeekStart ? 1 : -1
                        vm.selectedDay = Day(date: Calendar.current.date(byAdding: .day, value: 7 * diff, to: vm.selectedDay.date))
                    }
                    isDragging = false
                }
        }
        .onAppear {
            vm.initWeeks(around: Date())
            vm.targetedWeekStart = vm.weeks[vm.weeks.count / 2].startDate
            vm.selectedDay = vm.weeks[vm.weeks.count / 2].days[Calendar.current.component(.weekday, from: Date()) - 1]
        }
    }
}

#Preview {
    ScheduleBottomBar()
}
