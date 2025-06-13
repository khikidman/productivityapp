//
//  EventCardView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/3/25.
//

import SwiftUI

class EventCardViewModel: ObservableObject {
    
}

struct EventCardView: View {
    @Binding var event: Event
    
    var habit: Habit?
    var task: TodoItem?
    
    @State private var isNavigating = false
    @State private var habitForDetail: Habit? = nil
    
    @State var previewedStartTime: Date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    
    var hourHeight: CGFloat = 52
    
    @State var offset: CGSize = .zero
    @State var deltaY: CGFloat = .zero
    
    @State var isDragging: Bool = false
    @State private var editModeEnabled: Bool = false
    
    @State private var dragAnchorTime: Date = Date()
    @State private var resizingTop = false
    @State private var resizingBottom = false
    @State private var dragAnchorOffset: CGFloat = 0
    @State private var showHandleHint = false
    
    
    var initialY: CGFloat {
        let hour = Calendar.current.component(.hour, from: event.startTime)
        let minute = Calendar.current.component(.minute, from: event.startTime)
        let fractionalHour = CGFloat(hour) + CGFloat(minute) / 60
        return fractionalHour * hourHeight + (hourHeight / 2)
    }
    var duration: CGFloat {
        let start = event.startTime
        let end = event.endTime
        return end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
    }
    
    var cardHeight: CGFloat {
        return duration / 60 / 60 * hourHeight
    }
    
    var body: some View {
        ZStack {
            // 👇 Invisible background tap catcher when editing
            if editModeEnabled {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring()) {
                            editModeEnabled = false
                        }
                    }
                    .zIndex(0) // behind the card
            }
        }
        ZStack {
            // begin event card
            RoundedRectangle(cornerRadius: 4)
                .glassEffect(in: .rect(cornerRadius: 4))
                .padding(.vertical, 2)
                .foregroundStyle(editModeEnabled ? .blue : .blue.opacity(0.3))
                .frame(width: 325, height: max(cardHeight, 20))
                .overlay(
                    ZStack (alignment: .leading){
                        HStack(alignment: .top, spacing:0) {
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundStyle(.blue)
                                .frame(width: 3)
                                .frame(maxHeight: .infinity)
                                .padding(.vertical, 2)
                            
                            if (cardHeight >= 50) {
                                VStack (alignment: .leading, spacing: 2) {
                                    Text(event.title)
                                        .font(.caption.bold())
                                    Label {
                                        let timeMarker = eventCardTimeMarker(start: event.startTime, end: event.endTime)
                                        Text("\(timeMarker)")
                                            .font(.system(size: 10))
                                    } icon: {
                                        Image(systemName: "clock")
                                            .font(.system(size: 9))
                                            .frame(maxWidth: 0)
                                    }
                                    .padding(.horizontal, 4)
                                    
                                }
                                .padding(.horizontal, 4)
                            } else {
                                HStack (alignment: .center, spacing: 8) {
                                    Text(event.title)
                                        .font(.caption.bold())
                                    Label {
                                        let timeMarker = eventCardTimeMarker(start: event.startTime, end: event.endTime)
                                        Text("\(timeMarker)")
                                            .font(.system(size: 9))
                                            .lineLimit(1)
                                    } icon: {
                                        Image(systemName: "clock")
                                            .font(.system(size: 10))
                                            .frame(maxWidth: 0)
                                    }
                                    .padding(.horizontal, 4)
                                    
                                }
                                .padding(.horizontal, 4)
                                .frame(maxHeight: .infinity, alignment: .center) // center contents
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(maxHeight: .infinity)
                        .padding(3)
                        
                        if editModeEnabled {
                            // Top resize bar
                            RoundedRectangle(cornerRadius: 1)
                                .glassEffect(in: .rect(cornerRadius: 1))
                                .frame(width: 30, height: 4)
                                .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.blue, lineWidth: 1))
                                .overlay(
                                    Image(systemName: "chevron.up").foregroundStyle(.gray).offset(y: -14)
                                        .opacity(showHandleHint ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.5), value: showHandleHint)
                                )
                                .position(x: 325 - 20, y: 8) // inside top-right (adjust x/y as needed)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            resizingTop = true
                                            if !isDragging {
                                                dragAnchorTime = snapToNearest15Minutes(event.startTime)
                                            }
                                            
                                            let deltaHours = value.translation.height / hourHeight
                                            let deltaSeconds = deltaHours * 3600
                                            let newStartTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                                            event.startTime = snapToNearest15Minutes(newStartTime)
                                            
                                            // Safety: keep min duration
                                            if event.startTime >= event.endTime {
                                                event.startTime = event.endTime.addingTimeInterval(-15*60)
                                            }
                                        }
                                        .onEnded { _ in
                                            if (event.sourceType == .habit) {
                                                Task {
                                                    do {
                                                        try await UserManager.shared.updateHabitTime(habit: Habit(
                                                            id: event.id.uuidString,
                                                            userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                                                            title: event.title,
                                                            description: "",
                                                            startTime: event.startTime,
                                                            endTime: event.endTime,
                                                            iconName: ""),
                                                            startTime: event.startTime,
                                                            endTime: event.endTime)
                                                    }
                                                    catch {
                                                        
                                                    }
                                                }
                                                resizingTop = false
                                            }
                                        }
                                )
                            
                            // Bottom resize bar
                            RoundedRectangle(cornerRadius: 1)
                                .glassEffect(in: .rect(cornerRadius: 1))
                                .frame(width: 30, height: 4)
                                .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.blue, lineWidth: 1))
                                .overlay(
                                    Image(systemName: "chevron.down").foregroundStyle(.gray).offset(y: 14)
                                        .opacity(showHandleHint ? 1 : 0)
                                        .animation(.easeInOut(duration: 0.5), value: showHandleHint)
                                )
                                .position(x: 20, y: cardHeight - 8) // inside bottom-left (adjust x/y as needed)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if !resizingBottom {
                                                resizingBottom = true
                                                dragAnchorTime = snapToNearest15Minutes(event.endTime)
                                                dragAnchorOffset = value.startLocation.y
                                            }

                                            let deltaY = value.location.y - dragAnchorOffset
                                            let deltaHours = deltaY / hourHeight
                                            let deltaSeconds = deltaHours * 3600

                                            let newEndTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                                            event.endTime = snapToNearest15Minutes(newEndTime)

                                            if event.endTime <= event.startTime.addingTimeInterval(15 * 60) {
                                                event.endTime = event.startTime.addingTimeInterval(15 * 60)
                                            }
                                        }
                                        .onEnded { _ in
                                            if (event.sourceType == .habit) {
                                                Task {
                                                    do {
                                                        try await UserManager.shared.updateHabitTime(habit: Habit(
                                                            id: event.id.uuidString,
                                                            userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                                                            title: event.title,
                                                            description: "",
                                                            startTime: event.startTime,
                                                            endTime: event.endTime,
                                                            iconName: ""),
                                                            startTime: event.startTime,
                                                            endTime: event.endTime)
                                                    }
                                                    catch {
                                                        
                                                    }
                                                }
                                                resizingBottom = false
                                            }
                                        }
                                )
                        }
                    }
                )
                .offset(offset)
                .offset(y: initialY)
                .zIndex(1)
            // end event card
            
        }
        .disabled(isNavigating)
        .highPriorityGesture(
            TapGesture()
                .onEnded { value in
                    if (event.sourceType == .habit) {
                        Task {
                            do {
                                let habit = try await HabitManager.shared.loadHabit(habitId: event.id.uuidString)
                                habitForDetail = habit
                                isNavigating = true
                            } catch {
                                
                            }
                        }
                    }
                }
            )
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .sequenced(before: DragGesture())
                    .onChanged { value in
                        switch value {
                        case .second(true, let drag):
                            // Drag in progress after long press
                            withAnimation(.spring()) {
                                editModeEnabled = true
                                showHandleHint = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeOut) {
                                        showHandleHint = false
                                    }
                                }
                            }
                            if let drag = drag {
                                if !isDragging {
                                    dragAnchorTime = snapToNearest15Minutes(event.startTime)
                                }
                                
                                offset = drag.translation
                                isDragging = true
                                
                                let deltaHours = drag.translation.height / hourHeight
                                let deltaSeconds = deltaHours * 3600
                                let newTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                                previewedStartTime = snapToNearest15Minutes(newTime)
                            }
                        default:
                            break
                        }
                    }
                    .onEnded { value in
                        switch value {
                        case .second(true, let drag):
                            // Drag finished
                            if let drag = drag {
                                withAnimation(.spring()) {
                                    let deltaHours = drag.translation.height / hourHeight
                                    let deltaSeconds = deltaHours * 3600
                                    
                                    let newStartTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                                    
                                    let originalDuration = event.endTime.timeIntervalSince(event.startTime)
                                    event.startTime = snapToNearest15Minutes(newStartTime)
                                    event.endTime = event.startTime.addingTimeInterval(originalDuration)
                                    
                                    if (event.sourceType == .habit) {
                                        Task {
                                            do {
                                                try await UserManager.shared.updateHabitTime(
                                                    habit: Habit(
                                                        id: event.id.uuidString,
                                                        userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                                                        title: event.title,
                                                        description: "",
                                                        startTime: event.startTime,
                                                        endTime: event.endTime,
                                                        iconName: ""),
                                                    startTime: event.startTime,
                                                    endTime: event.endTime)
                                            } catch {
                                                // handle error
                                            }
                                        }
                                    }
                                    
                                    offset = .zero
                                    isDragging = false
                                    editModeEnabled = false
                                }
                            }
                        default:
                            // No drag, just long press end
                            break
                        }
                    })
        
        .gesture(
            editModeEnabled ? DragGesture()
                .onChanged { value in
                    if !isDragging {
                        dragAnchorTime = snapToNearest15Minutes(event.startTime)
                    }
                    
                    offset = value.translation
                    isDragging = true
                    
                    let deltaHours = value.translation.height / hourHeight
                    let deltaSeconds = deltaHours * 3600
                    let newTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                    previewedStartTime = snapToNearest15Minutes(newTime)
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        let deltaHours = value.translation.height / hourHeight
                        let deltaSeconds = deltaHours * 3600
                        
                        let newStartTime = dragAnchorTime.addingTimeInterval(deltaSeconds)
                        
                        let originalDuration = event.endTime.timeIntervalSince(event.startTime)
                        event.startTime = snapToNearest15Minutes(newStartTime)
                        event.endTime = event.startTime.addingTimeInterval(originalDuration)
                        
                        if (event.sourceType == .habit) {
                            Task {
                                do {
                                    try await UserManager.shared.updateHabitTime(
                                        habit: Habit(
                                            id: event.id.uuidString,
                                            userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                                            title: event.title,
                                            description: "",
                                            startTime: event.startTime,
                                            endTime: event.endTime,
                                            iconName: ""),
                                        startTime: event.startTime,
                                        endTime: event.endTime)
                                } catch {
                                    // handle error
                                }
                            }
                        }
                        
                        offset = .zero
                        isDragging = false
                        editModeEnabled = false;
                    }
                }
            : nil
        )
        
        .navigationDestination(isPresented: $isNavigating) {
            if let habit = habitForDetail {
                HabitDetailView(habit: habit)
            }
        }
        
        if isDragging {
            let snappedY = round((initialY + offset.height) / (hourHeight/4)) * (hourHeight/4) - 6
            
            Text(eventDragTimePreview(start: previewedStartTime))
                .offset(x: -25, y: snappedY)
                .foregroundStyle(.primary.opacity(0.7))
                .font(.system(size:10))
        }
    }
    
    func snapToNearest15Minutes(_ date: Date) -> Date {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let hour = comps.hour, let minute = comps.minute else { return date }
        let total = hour * 60 + minute
        let snapped = Int(round(Double(total) / 15)) * 15
        comps.hour = snapped / 60
        comps.minute = snapped % 60
        comps.second = 0
        return calendar.date(from: comps) ?? date
    }
}

extension EventCardView {
    func eventCardTimeMarker(start: Date, end: Date?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        
        let start = start
        
        var formattedString = "\(formatter.string(from: start))"
        if let end = end {
            formattedString += " - \(formatter.string(from: end))"
        }
        
        return formattedString
        
    }
    
    func eventDragTimePreview(start: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = ":mm"
        
        if (Calendar.current.component(.minute, from: start) == 0) {
            return ""
        }
        
        
        return "\(formatter.string(from: start))"
        
    }
    

    func startOfHour(date: Date) -> Date? {
        let calendar = Calendar.current

        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.minute = 0
        components.second = 0

        return calendar.date(from: components)
    }
}

#Preview {
    NewScheduleView()
}
