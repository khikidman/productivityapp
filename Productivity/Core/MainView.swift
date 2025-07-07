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
                    Tab(value: MainTab.settings) {
                        NavigationStack {
                            ProfileView()
                        }
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
            Tab(value: MainTab.search, role: .search) {
                    NavigationStack {
                        SearchView()
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
                case .settings:
                    Text("Temp")
                case .schedule:
                    ScheduleBottomBarAccessory(selectedDay: $selectedDay)
                case .search:
                    Text("Temp")
                }
            }
        
    }
}

enum MainTab: Hashable {
    case dashboard, tasks, settings, schedule, search
}

#Preview {
    MainView(showSignInView: .constant(false))
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}

