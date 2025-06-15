//
//  AddHabitView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct AddHabitView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var startTime: Date
    @Binding var endTime: Date
    @State var repeatType: HabitRepeatTypeOption = .daily
    @State private var selectedWeekdays: Set<Int> = []
    @State private var nDays: Int = 2
    @State var selectedStartTime: Date = Date()
    @State var selectedEndTime: Date = Date().addingTimeInterval(3600)
    @State private var iconName = "repeat"
    @State private var friends: [DBUser] = []
    @State private var isLoadingFriends = true
    @State private var sharedWith: [String] = []
    
    struct Weekday: Identifiable {
        let id: Int // 1 = Sunday, 7 = Saturday
        let shortName: String
    }

    let weekdays: [Weekday] = [
        Weekday(id: 1, shortName: "S"),
        Weekday(id: 2, shortName: "M"),
        Weekday(id: 3, shortName: "T"),
        Weekday(id: 4, shortName: "W"),
        Weekday(id: 5, shortName: "T"),
        Weekday(id: 6, shortName: "F"),
        Weekday(id: 7, shortName: "S")
    ]
    
    var repeatRule: HabitRepeatRule {
        switch repeatType {
        case .none:
            return .none
        case .daily:
            return .daily
        case .weekly:
            return .weekly(Array(selectedWeekdays).sorted())
        case .monthly:
            // For now just return empty → you can implement day-of-month selector later
            return .monthly([])
        case .everyNDays:
            return .everyNDays(nDays)
        }
    }

    //IconPickerView(iconName: $iconName)
    
    var onSave: (Habit) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(spacing: 20) {
                    VStack {
                        Picker("Repeat", selection: $repeatType) {
                            ForEach(HabitRepeatTypeOption.allCases) { option in
                                Text(option.displayName).tag(option)
                            }
                        }
                        if repeatType == .weekly {
                            HStack {
                                ForEach(weekdays) { weekday in
                                    let containsWeekday = selectedWeekdays.contains(weekday.id)
                                    Button(action: {
                                        if containsWeekday {
                                            selectedWeekdays.remove(weekday.id)
                                        } else {
                                            selectedWeekdays.insert(weekday.id)
                                        }
                                    }) {
                                        Text(weekday.shortName)
                                            .padding(8)
                                            .padding(.horizontal, 6)
                                            .glassEffect(.regular.interactive().tint(containsWeekday ? .pink : .clear))
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 8)
//                                                    .fill(selectedWeekdays.contains(weekday.id) ? Color.pink.opacity(0.3) : Color.clear)
//                                            )
                                            .font(.subheadline)
                                        
                                        
                                            .foregroundColor(.primary)
                                        
                                    }
                                }
                            }
                            .glassEffectTransition(.identity)
                            .padding(.horizontal, 4)
                            .padding(.bottom, 4)
                        }
                        if repeatType == .everyNDays {
                            HStack {
                                Text("Every")
                                
                                Button {
                                    nDays = max(1, nDays - 1)
                                } label: {
                                    Image(systemName: "minus")
                                        .foregroundStyle(.pink)
                                }
                                .frame(width: 20, height: 20)
                                .padding(6)
                                .glassEffect(.regular.interactive())
                                
                                Text("\(nDays)")
                                    .padding(6)
                                
                                Button {
                                    nDays = min(30, nDays + 1)
                                } label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.pink)
                                }
                                .frame(width: 20, height: 20)
                                .padding(6)
                                .glassEffect(.regular.interactive())
                                
                                Text("days")
                            }
                            .padding(.bottom, 4)
                        }
                    }
                    .animation(.smooth, value: repeatType)
                    .glassEffect(in: .rect(cornerRadius: 16))
                    .pickerStyle(.segmented)
                    .controlSize(.regular)
                    .padding(.horizontal)
                    
                    HStack {
                        VStack {
                            TextField("Habit Name", text: $title)
                                .padding(8)
                                .glassEffect(.regular.interactive())
                            
                            TextField("Description", text: $description)
                                .padding(8)
                                .glassEffect(.regular.interactive())
                        }
                        .padding(.trailing, 4)
                        
                        Menu {
                            
                        } label: {
                                Image(systemName: "repeat")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.pink)
                                    .frame(width: 60, height: 60)
                                    .padding(13)
                                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    //                if (repeatType == .weekly) {
                    //                    DatePicker("Weekdays", selection: $selectedWeekdays, displayedComponents: [.])
                    //                }
                    HStack {
                        DatePicker("From", selection: $selectedStartTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .tint(.pink)
                            .onAppear {
                                // Convert DateComponents -> Date
                                selectedStartTime = startTime
                            }
                            .onChange(of: selectedStartTime) {
                                // Convert Date -> DateComponents
                                startTime = selectedStartTime
                            }
                        Spacer()
                        DatePicker("To", selection: $selectedEndTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(.compact)
                            .tint(.pink)
                            .onAppear {
                                // Convert DateComponents -> Date
                                selectedEndTime = endTime
                            }
                            .onChange(of: selectedEndTime) {
                                // Convert Date -> DateComponents
                                endTime = selectedEndTime
                            }
                    }
                    .padding(.horizontal)
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
            
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if isLoadingFriends {
                            ProgressView().disabled(true)
                        } else {
                            ForEach(friends, id: \.userId) { friend in
                                Button {
                                    // Share with this friend
                                    sharedWith.append(friend.userId)
                                    print("Share with \(friend)")
                                } label: {
                                    Label(friend.firstName ?? friend.email ?? friend.userId, systemImage: "person.fill")
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "person.fill.badge.plus")
                    }
                    .onAppear {
                                Task {
                                    do {
                                        let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                                        friends = try await UserManager.shared.getFriends(for: uid)
                                        isLoadingFriends = false
                                    } catch {
                                        print("Error fetching friends: \(error)")
                                        isLoadingFriends = false
                                    }
                                }
                            }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Cancel", action: onCancel)
                        .foregroundStyle(.primary)
                }
                
                ToolbarSpacer(.flexible, placement: .bottomBar)
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Save") {
                        Task {
                            do {
                                let user = try AuthenticationManager.shared.getAuthenticatedUser()
                                let userId = user.uid
                                
                                let newHabit = Habit(
                                    id: UUID().uuidString,
                                    userId: userId,
                                    title: title,
                                    description: description,
                                    startTime: startTime,
                                    endTime: endTime,
                                    iconName: iconName,
                                    repeatRule: repeatRule,
                                    sharedWith: sharedWith
                                )
                                
                                try await UserManager.shared.shareHabit(habit: newHabit, with: sharedWith)
                                
                                onSave(newHabit)
                            } catch {
                                
                            }
                        }
                    }
                }
            }
        }
        .background(.windowBackground.opacity(0.1))
        
        .presentationDetents([.fraction(0.5), .fraction(0.80)])
    }
}

enum HabitRepeatTypeOption: String, CaseIterable, Identifiable {
    case none, daily, weekly, monthly, everyNDays
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .none: return "Once"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .everyNDays: return "Custom"
        }
    }
}

#Preview {
    AddHabitView(
        title: .constant(""),
        description: .constant(""),
        startTime: .constant(Date()),
        endTime: .constant(Date().addingTimeInterval(3600)),
        onSave: { habit in
            Task {
                do {
                    let user = try AuthenticationManager.shared.getAuthenticatedUser()
                    let userId = user.uid
                    try await UserManager.shared.createHabit(userId: userId, habit: habit)
                } catch {
                }
            }
        },
        onCancel: {
        }
    )}
