//
//  MainView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI
import UIKit

struct MainView: View {
    
    @EnvironmentObject var habitVM: HabitViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    @Binding var showSignInView: Bool
    @State private var selectedTab: MainTab = .dashboard
    
    @State var timerDuration: TimeInterval = 20 * 60
    @State var breakDuration: TimeInterval = 4 * 60
    @State var timerType: TimerTypeOption = .pomodoro
    
    @State var selectedDay: Day = Day.init(date: Date())
    
    var body: some View {
        TabView (selection: $selectedTab) {
            Tab(value: MainTab.dashboard) {
                NavigationStack {
                    DashboardView(selectedTab: $selectedTab)
                }
            } label: {
                Label("Dashboard", systemImage: "house")
            }
            
            Tab(value: MainTab.schedule) {
                NavigationStack {
                    NewScheduleView(selectedDay: $selectedDay)
                        .environmentObject(todoVM)
                        .environmentObject(habitVM)
                }
            } label: {
                Label("Schedule", systemImage: "calendar.day.timeline.left")
            }
            
            if (!showSignInView) {
                Tab(value: MainTab.profile) {
                    NavigationStack {
                        ProfileView()
                    }
                } label: {
                    Label("Profile", systemImage: "person.fill")
                }
            }
            
            if (selectedTab == .schedule || selectedTab == .tasks || selectedTab == .search || selectedTab == .profile) {
                Tab(value: MainTab.search, role: .search) {
                    NavigationStack {
                        SearchView()
                    }
                }
            } else if (selectedTab == .dashboard || selectedTab == .timer) {
                Tab(value: MainTab.timer, role: .search) {
                    TimerView(timerType: $timerType, timerDuration: $timerDuration, breakDuration: $breakDuration)
                } label: {
                    Label("Action", systemImage: "timer")
                }
            }
        }
        .tabViewStyle(.automatic)
        .tint(.pink)
        .backgroundStyle(.windowBackground)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            switch selectedTab {
            case .dashboard:
                TabBarBottomAccessory()
            case .tasks:
                Text("Temp")
            case .profile:
                Text("Temp")
            case .schedule:
                ScheduleBottomBarAccessory(selectedDay: $selectedDay)
            case .search:
                Text("Temp")
            case .timer:
                TimerBottomBarAccessory(timerTypeOption: $timerType, timerDuration: $timerDuration, breakDuration: $breakDuration)
            }
        }
        
    }
}

enum MainTab: Hashable {
    case dashboard, tasks, profile, schedule, search, timer
}

#Preview {
    MainView(showSignInView: .constant(false))
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}
