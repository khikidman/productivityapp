//
//  TabBarBottomAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/29/25.
//

import SwiftUI
import AlarmKit
import WidgetKit
import ActivityKit

struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentTime: TimeInterval
        var isRunning: Bool
    }
    var countdown: TimeInterval
}

struct TabBarBottomAccessory: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    var body: some View {
        HStack {
            Text("Start Laundry")
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "play.fill")
                    .foregroundStyle(.pink)
            }
            
            .frame(width: 30)
            .clipShape(Circle())
//            Button {
//                
//            } label: {
//                Image(systemName: "timer")
//                    .foregroundStyle(.white)
//            }
//            .frame(width: 40)
//            .glassEffect(.regular.tint(.pink).interactive())
//            .clipShape(Circle())
        }
        .padding(.horizontal, 12)
    }
}

struct TimerSheetView: View {
    var body: some View {
        EmptyView()
            .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
//    MainView(showSignInView: .constant(false))
//        .environmentObject(TodoViewModel())
//        .environmentObject(HabitViewModel())
    EmptyView()
        .sheet(isPresented: .constant(true), content: { TimerSheetView() })
}
