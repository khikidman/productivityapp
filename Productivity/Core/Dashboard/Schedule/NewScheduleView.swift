//
//  NewScheduleView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/3/25.
//

import SwiftUI
import UIKit

class WeekViewModel: ObservableObject {
    @Published var weeks: [Week] = []
    @Published var selectedWeek: Int = 10
    
    func loadWeeks(centeredOn date: Date) {
        weeks = []
        let calendar = Calendar.current
        
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

struct NewScheduleView: View {
    
    @StateObject private var weekVM = WeekViewModel()
    
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var habitVM: HabitViewModel
    
    @State var selectedDay: Day = Day.init(date: Date())
    
    var body: some View {
        VStack {
            WeekdayHeaderView()
            WeekdaySelectorView(weekVM: weekVM, selectedDay: $selectedDay)
            DayScheduleView(selectedDay: $selectedDay)
                .environmentObject(todoVM)
                .environmentObject(habitVM)
                .animation(.spring, value: selectedDay)
            
        }
        
        
        
        
        .navigationTitle("Schedule")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.pink)
                        .imageScale(.large)
                }
            }
        }
        .onAppear {
            weekVM.loadWeeks(centeredOn: Date())
            selectedDay = weekVM.currentDay()
        }
    }
}

#Preview {
    NavigationStack {
        NewScheduleView()
            .environmentObject(TodoViewModel())
            .environmentObject(HabitViewModel())
    }
}
