//
//  ScheduleBottomBarAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/20/25.
//

import SwiftUI

enum ShiftDirection {
    case backward
    case forward
}

class AccessoryWeekViewModel: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedDay: Day = Day(date: Date())
    @Published var targetedWeekStart: Date?
    
    func initWeeks(centeredOn date: Date, windowRadius: Int = 1) {
        let calendar = Calendar.current
        weeks = (-windowRadius...windowRadius).map { offset in
            let weekStart = calendar.date(byAdding: .weekOfYear, value: offset, to: date)!
            return calendar.generateWeek(for: weekStart)
        }
        targetedWeekStart = weeks[weeks.count / 2].startDate
    }
    
    func shift(in direction: ShiftDirection) {
        let calendar = Calendar.current
        switch direction {
        case .backward:
            let newWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: weeks.first!.startDate)
            weeks.insert(calendar.generateWeek(for: newWeekStart!), at: 0)
            // Handle day selection update
        case .forward:
            let newWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: weeks.last!.startDate)
            weeks.append(calendar.generateWeek(for: newWeekStart!))
            // Handle day selection update
        }
    }
}

struct ScheduleBottomBarAccessory: View {
    // @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    @StateObject private var vm = AccessoryWeekViewModel()
    @Binding var selectedDay: Day

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack (alignment: .center) {
                ForEach(vm.weeks) { week in
                    HStack(alignment: .center) {
                        ForEach(week.days) { day in
                            WeekdaySelector(day: day, selectedDay: $selectedDay)
                        }
                    }
                    .frame(width: 336)
                    .id(week.startDate)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $vm.targetedWeekStart)
        .onChange(of: vm.targetedWeekStart) { oldValue, newValue in
            let lastWeek = vm.weeks.last!.startDate
            let firstWeek = vm.weeks.first!.startDate
            
            if newValue == lastWeek {
                vm.shift(in: .forward)
            }
            else if newValue == firstWeek {
                vm.shift(in: .backward)
            }
        }
        .onAppear {
            vm.initWeeks(centeredOn: Date())
            DispatchQueue.main.async {
                vm.targetedWeekStart = vm.weeks[vm.weeks.count / 2].startDate
                selectedDay = vm.weeks[vm.weeks.count / 2].days[Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1]
                vm.selectedDay = vm.weeks[vm.weeks.count / 2].days[Calendar.current.component(.weekday, from: Date()) - 1]
            }
        }
        .frame(width: 336, alignment: .center)
    }
}

//#Preview {
//    NavigationStack {
//        TabView {
//            Tab {
//                Text("Filler")
//            }
//        }
//        ScheduleBottomBarAccessory(selectedDay: .constant(Day(date: Date())))
//    }
//    .tabViewBottomAccessory { ScheduleBottomBarAccessory(selectedDay: .constant(Day(date: Date()))) }
//}
