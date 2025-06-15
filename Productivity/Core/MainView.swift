//
//  MainView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var habitVM: HabitViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    @Binding var showSignInView: Bool
    
    var body: some View {
            TabView {
//                NavigationStack {
//                    DashboardView()
//                }
//                .tabItem {
//                    Label("Dashboard", systemImage: "calendar")
//                }
//                
//                NavigationStack {
//                    TaskView()
//                        
//                }
//                .tabItem {
//                    Label("Tasks", systemImage: "checkmark.circle")
//                }
//                
//                if !showSignInView {
//                    NavigationStack {
//                        ProfileView(showSignInView: $showSignInView)
//                            
//                    }
//                    .tabItem {
//                        Label("Settings", systemImage: "gear")
//                    }
//                }
                Tab {
                    NavigationStack {
                        DashboardView()
                    }
                } label: {
                    Label("Dashboard", systemImage: "house")
                }
                
                Tab {
                    NavigationStack {
                        TaskView()
                    }
                } label: {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
                
                if (!showSignInView) {
                    Tab {
                        NavigationStack {
                            ProfileView()
                        }
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                
                Tab(role: .search) {
                    NavigationStack {
                        SearchView()
                    }
                }
                
                
                
            }
            .tabViewStyle(.automatic)
            .tint(.pink)
            .backgroundStyle(.windowBackground)
//            .tabBarMinimizeBehavior(.onScrollDown)
//            .tabViewBottomAccessory {
//                FitnessToolbarAccessory()
//            }
//            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "magnifyingglass")
//                    }
//                }
//            }
        
    }
}

#Preview {
    MainView(showSignInView: .constant(false))
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}
