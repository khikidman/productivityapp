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
    
    var body: some View {
        HStack {
            Image(systemName: habit.iconName)
                .foregroundStyle(.pink)
                .font(.title2)
                .frame(width: 30)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.headline)
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            
            Spacer()
            
            HStack(spacing: 1) {
                Image(systemName: /*habit.isCompleted(on: Date().addingTimeInterval(-172800).stripTime()) ? "checkmark.square.fill" : */"square")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12))
                Image(systemName: /*habit.isCompleted(on: Date().addingTimeInterval(-86400).stripTime()) ? "checkmark.square.fill" : */"square")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                Button{
//                    if let index = habitVM.habitItems.firstIndex(where: { $0.id == habit.id }) {
//                                habitVM.habitItems[index].toggleCompletion(on: Date())
//                            }
                } label: {
                    Image(systemName: /*habit.isCompleted(on: Date().stripTime()) ? "checkmark.square.fill" : */"square")
                        .foregroundStyle(.pink)
                        .font(.system(size: 24))
                }
                .buttonStyle(.plain)
            }
            .padding(.trailing, 20)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                if let index = habitVM.habitItems.firstIndex(where: { $0.id == habit.id }) {
                    habitVM.habitItems.remove(at: index)
                }
            } label: {
                Label("Delete", systemImage:"trash")
            }
            .tint(.red)
        }
    }
}
