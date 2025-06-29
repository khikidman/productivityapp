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
    
    @State private var completionStatus: [Date: Bool] = [:]
    @State private var loadingStatus: [Date: Bool] = [:]
    
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
        
        let monthYearFormatter: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale.current
            f.dateFormat = "LLLL yyyy"
            return f
        }()
        
        let calendar = Calendar.current
        let currentDate = Date()
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let daysInMonth = Array(range)
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let daysGrid: [[Date]] = stride(from: 0, to: daysInMonth.count, by: 7).map { weekOffset in
            (0..<7).compactMap { weekdayOffset -> Date? in
                let dayIndex = weekOffset + weekdayOffset
                guard dayIndex < daysInMonth.count else { return nil }
                let day = daysInMonth[dayIndex]
                var components = calendar.dateComponents([.year, .month], from: currentDate)
                components.day = day
                return calendar.date(from: components)
            }
        }
        
        
        VStack {
            
            NavigationStack {
//                List {
                    Section {
//                        NavigationLink {
//                            HabitDetailView(habit: habit)
//                        } label: {
//                            Label(monthYearFormatter.string(from: currentDate), systemImage: "chart.bar.xaxis.ascending")
//                                .accentColor(Color.pink)
//                        }
//                        .buttonStyle(.plain)
                        
                        Grid(alignment: .topLeading, horizontalSpacing: 14, verticalSpacing: 16) {
                            GridRow {
                                ForEach(weekdayLetters, id: \.self) { weekdayLetter in
                                    Text(weekdayLetter)
                                        .frame(maxWidth: .infinity)
                                        .font(.caption)
                                }
                            }
                            ForEach(daysGrid, id: \.[0]) { week in
                                GridRow {
                                    ForEach(week, id: \.self) { date in
                                        let isThisMonth = calendar.component(.month, from: date) == calendar.component(.month, from: currentDate)
                                        // Future: specialize for weekly, n-day, monthly
                                        let isScheduled = habit.isScheduled(for: date)
                                        let isCompleted = completionStatus[date] ?? false
                                        let isLoading = loadingStatus[date] ?? false
                                        Button {
                                            if isScheduled {
                                                loadingStatus[date] = true
                                                Task {
                                                    do {
                                                        switch habit.repeatRule {
                                                        case .daily, .weekly, .monthly, .everyNDays:
                                                            try await HabitManager.shared.toggleCompletion(for: habit, on: date)
                                                            print("Habit toggled on \(date)")
                                                            let completed = try await UserManager.shared.isCompleted(habit: habit, date: date)
                                                            completionStatus[date] = completed
                                                        default:
                                                            // TODO: Add custom toggle completion logic for weekly, monthly, everyNDays rules.
                                                            break
                                                        }
                                                    } catch {
                                                        // Optionally handle error
                                                    }
                                                    loadingStatus[date] = false
                                                }
                                            }
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(isScheduled ? .pink : .gray.opacity(0.2), lineWidth: 1)
                                                    .background(
                                                        (isCompleted ? Color.pink.opacity(0.25) : Color.clear)
                                                            .cornerRadius(6)
                                                    )
                                                if isLoading {
                                                    ProgressView()
                                                        .frame(width: 24, height: 24)
                                                } else {
                                                    Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                                                        .foregroundStyle(isScheduled ? .pink : .gray)
                                                        .frame(width: 24, height: 24)
                                                        .font(.system(size: 22))
                                                    Text("\(calendar.component(.day, from: date))")
                                                        .font(.caption2)
                                                        .foregroundColor(isScheduled ? .primary : .gray)
                                                        .offset(y: 16)
                                                }
                                            }
                                            .frame(width: 32, height: 48)
                                            .offset(y: 16)
                                            .opacity(isThisMonth ? 1 : 0.25)
                                        }
                                        .disabled(!isScheduled)
                                    }
                                }
                            }
                        }
                        .padding(.top, 6)
                        .padding(.bottom, 8)
                        .onAppear {
                            Task {
                                for day in daysInMonth {
                                    var components = calendar.dateComponents([.year, .month], from: currentDate)
                                    components.day = day
                                    if let date = calendar.date(from: components), habit.isScheduled(for: date) {
                                        let completed = try? await UserManager.shared.isCompleted(habit: habit, date: date)
                                        completionStatus[date] = completed ?? false
                                    }
                                }
                            }
                            Task {
                                print(daysGrid)
                            }
                        }
                    }
//                }
            }
            
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

#Preview {
    HabitDetailView(habit: Habit(id: "abcdefg", userId: "abcdefg", title: "Test", description: "Test Description", createdDate: Date().addingTimeInterval(-3600), startTime: Date().addingTimeInterval(-1800), endTime: Date(), iconName: "repeat", colorHex: "#ff375f", category: "Uncategorized", repeatRule: .daily, sharedWith: []))
}


#Preview {
    NavigationStack {
        HabitDetailView(habit: Habit(id: "abcdefg", userId: "abcdefg", title: "Test", description: "Test Description", createdDate: Date().addingTimeInterval(-3600), startTime: Date().addingTimeInterval(-1800), endTime: Date(), iconName: "repeat", colorHex: "#ff375f", category: "Uncategorized", repeatRule: .daily, sharedWith: []))
    }
}

