//
//  TabBarBottomAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/29/25.
//

import SwiftUI

struct TabBarBottomAccessory: View {
    @State var selectedTab: MainTabTest = .dashboard
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: MainTabTest.dashboard) {
                NavigationStack {
                    List {
                        Section("Section 1") {
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                        }
                        Section("Section 1") {
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Label("Xbox", systemImage: "xbox")
                            }
                        }
                    }
                }
            } label: {
                Label("Dashboard", systemImage: "house")
            }
            Tab(value: MainTabTest.schedule) {
                EmptyView()
            } label: {
                Label("Schedule", systemImage: "calendar.day.timeline.left")
            }
            Tab(value: MainTabTest.settings) {
                EmptyView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            FitnessToolbarAccessory()
        }
    }
}

enum MainTabTest: Hashable {
    case dashboard, tasks, settings, schedule, search
}

#Preview {
    TabBarBottomAccessory()
}
