//
//  HabitCardView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/4/25.
//

import SwiftUI

struct HabitCardView: View {
    
    @EnvironmentObject var habitVM: HabitViewModel
    @Binding var habit: Habit
    
    // Progress bar
    let goal: CGFloat = 5
    @State var current: CGFloat = 1
    var progressBarWidth: CGFloat = 336
    
    var body: some View {
        
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: habit.iconName)
                        .tint(habit.color)
                        .font(.system(size: 30))
                    Text(habit.title)
                        .bold()
                    Spacer()
                    Button {
                        current += 1
                    } label: {
                        Circle().overlay(
                            Image(systemName: "checkmark")
                                .tint(.black)
                        )
                        .tint(habit.color)
                    }
                    .frame(width: 40, height: 40)
                    .contentShape(Circle())
                    .glassEffect(.regular.interactive())
                }
                .padding(.vertical, 8)
                
                ZStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .frame(width: progressBarWidth, height: 24)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(habit.color.opacity(0.5))
                        .frame(width: current >= goal ? progressBarWidth : min(current / goal, 1) * progressBarWidth)
                        .glassEffect()
                        .animation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5), value: current)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(habit.color)
                        .frame(width: current <= goal ? min(current / goal, 1) * progressBarWidth : (goal / current) * progressBarWidth)
                        .glassEffect()
                        .animation(.bouncy(extraBounce: 0.15), value: current)
                }
                .overlay(
                    HStack {
                        Text("Pages Read")
                            .font(.caption)
                            .bold()
                        Spacer()
                        Text("\(Int(current))/\(Int(goal))")
                            .font(.caption)
                            .frame(alignment: .trailing)
                            .bold()
                    }
                        .padding(.horizontal, 6)
                )
            }
            .padding(.horizontal, 20)
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                if let index = habitVM.habitItems.firstIndex(where: { $0.id == habit.id }) {
                    habitVM.habitItems.remove(at: index)
                }
            } label: {
                Image(systemName: "trash")
            }
            Button {
                HabitDetailView(habit: habit)
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
}
