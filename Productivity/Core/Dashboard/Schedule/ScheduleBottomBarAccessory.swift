//
//  ScheduleBottomBarAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/20/25.
//

import SwiftUI

class AccessoryWeekViewModel: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedWeek: Int = 0
    
    func loadWeeks(centeredOn date: Date) {
        let calendar = Calendar.current
        weeks = []
        for i in -10...10 {
            if let weekDate = calendar.date(byAdding: .weekOfYear, value: i, to: date) {
                weeks.append(calendar.generateWeek(for: weekDate))
            }
        }
    }
    
    func currentDay() -> Day {
        let dayOfWeek = Calendar.current.dateComponents([.weekday], from: Date()).weekday!
        return weeks[selectedWeek].days[dayOfWeek - 1]
    }
}

struct ScheduleBottomBarAccessory: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    @StateObject private var accessoryViewModel = AccessoryWeekViewModel()
    @Binding var selectedDay: Day

    var body: some View {
        TabView(selection: $accessoryViewModel.selectedWeek) {
            ForEach(accessoryViewModel.weeks.indices, id:\.self) { weekIndex in
                Tab(value: weekIndex) {
                    HStack {
                        ForEach(accessoryViewModel.weeks[weekIndex].days) { day in
                            WeekdaySelector(day: day, selectedDay: $selectedDay)
                        }
                    }
                    .padding(5)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            accessoryViewModel.loadWeeks(centeredOn: Date())
            selectedDay = accessoryViewModel.currentDay()
        }
    }
}

#Preview {
    ScheduleBottomBarAccessory(selectedDay: .constant(Day(date: Date())))
}
