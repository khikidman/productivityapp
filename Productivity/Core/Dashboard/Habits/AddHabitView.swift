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
    @State var repeatType: HabitRepeatTypeOption = .daily
    @State private var selectedWeekdays: Set<Int> = []
    @State private var nDays: Int = 2
    @State var selectedTime: Date = Date()
    @State private var iconName = "repeat"
    
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
                                    Button(action: {
                                        if selectedWeekdays.contains(weekday.id) {
                                            selectedWeekdays.remove(weekday.id)
                                        } else {
                                            selectedWeekdays.insert(weekday.id)
                                        }
                                    }) {
                                        Text(weekday.shortName)
                                            .padding(8)
                                            .frame(maxWidth: .infinity)
                                            .glassEffect(.regular.interactive().tint(selectedWeekdays.contains(weekday.id) ? .pink : .clear))
                                            .font(.subheadline)
                                        
                                        
                                            .foregroundColor(.white)
                                        
                                    }
                                }
                            }
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
                    .glassEffect(in: .rect(cornerRadius: 13))
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    HStack {
                        VStack {
                            TextField("Habit Name", text: $title)
                                .padding(8)
                                .glassEffect(.regular.interactive())
                            
                            TextField("Description", text: $description)
                                .padding(8)
                                .glassEffect(.regular.interactive())
                        }.padding(.trailing)
                        Menu {
                            
                        } label: {
                            Color.black.frame(width: 76, height: 76)
                                .clipShape(.rect(cornerRadius: 10))
                                .opacity(0.4)
                                .overlay {
                                    ZStack() {
                                        Image(systemName: "repeat")
                                            .font(.system(size: 24))
                                            .foregroundStyle(.pink)
                                            .frame(width: 50, height: 50)
                                        Image(systemName: "chevron.down")
                                            .tint(.gray)
                                            .frame(width: 24)
                                            .padding(.top, 48)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    //                if (repeatType == .weekly) {
                    //                    DatePicker("Weekdays", selection: $selectedWeekdays, displayedComponents: [.])
                    //                }
                    
                    DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .tint(.pink)
                        .padding(.horizontal)
                        .frame(height: 80)
                        .clipped()
                        .contentShape(Rectangle())
                        .onAppear {
                            // Convert DateComponents -> Date
                            selectedTime = startTime
                        }
                        .onChange(of: selectedTime) {
                            // Convert Date -> DateComponents
                            startTime = selectedTime
                        }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
            
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Cancel", action: onCancel)
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
                                    endTime: startTime.addingTimeInterval(1800),
                                    iconName: iconName,
                                    repeatRule: repeatRule // 👈 HERE
                                )
                                
                                onSave(newHabit)
                            } catch {
                                
                            }
                        }
                    }
                }
            }
        }
        .background(.windowBackground)
        
        .presentationDetents([.fraction(0.5), .large])
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
    HabitView()
        .environmentObject(HabitViewModel())
}
