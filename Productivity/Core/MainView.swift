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
                NavigationStack {
                    DashboardView()
                }
                .tabItem {
                    Label("Dashboard", systemImage: "calendar")
                }
                
                NavigationStack {
                    TaskView()
                        
                }
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.circle")
                }
                
                if !showSignInView {
                    NavigationStack {
                        ProfileView(showSignInView: $showSignInView)
                            
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .tabViewStyle(.automatic)
            .tint(.pink)
            .backgroundStyle(.windowBackground)
        
    }
}
