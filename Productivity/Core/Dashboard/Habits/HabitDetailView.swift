//
//  HabitView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct HabitDetailView: View {
    var habit: Habit
    
    var body: some View {
        let formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .medium
            f.timeStyle = .short
            return f
        }()
        
        let weekdayLetters: [String] = {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            return formatter.shortWeekdaySymbols.map { String($0.prefix(1)) }
        }()
        
        let calendar = Calendar.current
        let currentDate = Date()
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let weeksInMonth = calendar.range(of: .weekOfMonth, in: .month, for: currentDate)!
        
        VStack {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.0))
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    
                VStack() {
                    HStack() {
                        Text("Activity")
                        Spacer()
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 8).fill(.pink.opacity(0.2))
                                .overlay {
                                    Image(systemName: "circle.circle")
                                }
                                .frame(width: 36)
                        }
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 8).fill(.pink.opacity(0.2))
                                .overlay {
                                    Image(systemName: "ellipsis")
                                }
                                .frame(width: 36)
                        }
                    }
                    .frame(height: 28)
                    Grid(alignment: .topLeading, horizontalSpacing: 14, verticalSpacing: 12){
                        GridRow {
                            ForEach(weekdayLetters, id: \.self) { weekdayLetter in
                                Text(weekdayLetter)
                                    .frame(maxWidth: .infinity)
                                    .font(.caption)
                            }
                        }
                        ForEach(Array(weeksInMonth), id:\.self) { weekInMonth in
                            GridRow {
                                if let daysInWeek = calendar.range(of: .weekday, in: .weekOfMonth, for: currentDate) {
                                    ForEach(Array(daysInWeek), id: \.self) { dayInWeek in
                                        
                                        let date: Date = {
                                            var components = calendar.dateComponents([.year, .month], from: currentDate)
                                            components.weekOfMonth = weekInMonth
                                            components.weekday = dayInWeek
                                            return calendar.date(from: components) ?? Date()
                                        }()
                                        
                                        Button {
                                            
                                        } label: {
                                            let dateMonth = calendar.component(.month, from: date)
                                            let currentMonth = calendar.component(.month, from: currentDate)
                                            Image(systemName: /*habit.isCompleted(on: date) ? "checkmark.square.fill" : */"square")
                                                .foregroundStyle(dateMonth == currentMonth ? .pink : .gray)
                                                .frame(width: .infinity, height: 20)
                                                .font(.system(size: 28))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(16)
            }
            .navigationTitle(habit.title)
            .frame(width: .infinity, height: 200)
            .padding(16)
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.0))
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                
//                VStack(alignment: .leading, spacing: 0) {
//                    Text("\(Array(habit.completions).count) completions")
//                        .padding(16)
//                    List {
//                        ForEach(Array(habit.completions).sorted(), id: \.self) { completion in
//                            Text(formatter.string(from: completion))
//                        }
//                    }
//                }
            }
            .frame(width: .infinity, height: 200)
            .padding(16)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Button {
                        Task {
                            do {
                                try await UserManager.shared.deleteHabit(userId: AuthenticationManager.shared.getAuthenticatedUser().uid, habit: habit)
                            } catch {
                                
                            }
                        }
                    } label: {
                        Label("Delete Habit", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    func rowsNeededForMonth(numberOfDays n: Int, startingOn i: Int) -> Int {
        let (quot,rem) = (n+i).quotientAndRemainder(dividingBy: 7)
        return quot + (rem == 0 ? 0 : 1)
    }
}
