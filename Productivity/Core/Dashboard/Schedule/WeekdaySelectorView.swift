//
//  WeekdaySelectorView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct WeekdaySelectorView: View {
    @ObservedObject var weekVM: WeekViewModel
    @Binding var selectedDay: Day
    
    var body: some View {
        TabView(selection: $weekVM.selectedWeek) {
            ForEach(weekVM.weeks.indices, id:\.self) { index in
                HStack {
                    ForEach(weekVM.weeks[index].days) { day in
                        
                        WeekdaySelector(day: day, selectedDay: $selectedDay)
                        
                        
//                        .overlay(Text("\(day.dayNumber)").foregroundStyle(.windowBackground))
                    }
                }
                .backgroundStyle(.clear)
                .padding(5)
                .tag(index)
                
//                TabView(selection: $selectedDay) {
//                    ForEach(weekVM.weeks[index].days) { day in
//                        Text("\(day.dayNumber)")
//                            .tag(day)
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//                .tabViewStyle(.d)
                .tag(index)
                
            }
        }
        .backgroundStyle(.clear)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
        .frame(height: 40)
//        .overlay(Divider().background(.gray), alignment: .bottom)
//        GeometryReader { geometry in
//                let columnWidth = geometry.size.width / CGFloat(7)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 0) {
//                        ForEach(weekVM.selectedWeek, id: \.self) { day in
//                            Button {
//                                selectedDay.day = day
//                            } label: {
//                                if (day == selectedDay.day) {
//                                    Circle()
//                                        .fill(.pink)
//                                        .frame(width: columnWidth, height: 36)
//                                        .overlay(Text("\(day)").foregroundStyle(.windowBackground))
//                                } else {
//                                    Text("\(day)")
//                                        .frame(width: columnWidth)
//                                        .foregroundStyle(Color.primary)
//                                }
//                            }
//                        }
//                    }
//                .scrollTargetLayout()
//                .scrollTargetBehavior(.paging)
//                .padding(.bottom, 8)
//                .scrollIndicators(.hidden)
//            }
//            .overlay(Divider().background(.gray), alignment: .bottom)
//
//        }
//        .frame(height: 36)
    }
}

struct WeekdaySelector: View {
    
    var day: Day
    @Binding var selectedDay: Day
    
    var body: some View {
        Button {
            selectedDay = day
        } label: {
            Text("\(day.dayNumber)")
                .foregroundStyle(day == selectedDay ? (day.isToday() ? Color.primary : Color.pink) : (day.isToday() ? Color.pink : Color.primary))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .glassEffect(.regular.interactive().tint(day == selectedDay ? (day.isToday() ? .pink : .primary) : .clear))
    }
}

#Preview {
    NewScheduleView(selectedDay: .constant(Day(date: Date())))
        .environmentObject(HabitViewModel())
        .environmentObject(TodoViewModel())
}
