//
//  RootView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/31/25.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var habitVM: HabitViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            MainView(showSignInView: $showSignInView)
                .environmentObject(habitVM)
                .environmentObject(todoVM)
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .tint(.pink)
    }
}

#Preview {
    RootView()
        .environmentObject(HabitViewModel())
        .environmentObject(TodoViewModel())
}
