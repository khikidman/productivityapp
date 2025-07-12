//
//  TimerView.swift
//  Productivity
//
//  Created by Khi Kidman on 7/10/25.
//

import SwiftUI

enum TimerTypeOption: String, CaseIterable, Identifiable {
    case pomodoro, timer, breakTime, longBreak
    
    var id: String { rawValue }
    
    var typeName: String {
        switch self {
        case .pomodoro:
            return "Pomodoro"
        case .timer:
            return "Timer"
        case .breakTime:
            return "Break"
        case .longBreak:
            return "Long Break"
        }
    }
}

struct TimerView: View {
    @Binding var timerType: TimerTypeOption
    @Binding var timerDuration: TimeInterval
    @Binding var breakDuration: TimeInterval
    @State private var elapsed: TimeInterval = 0
    @State private var timerIsRunning: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(
                        Color.pink.opacity(0.3),
                        lineWidth: 10
                    )
                Circle()
                    .trim(from: 0, to: elapsed / timerDuration)
                    .stroke(
                        Color.pink,
                        // 1
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 150, height: 150)
            Button {
                if !timerIsRunning {
                    timerIsRunning = true
                    startPomodoro()
                } else {
                    timerIsRunning = false
                }
                
            } label: {
                VStack {
                    let remaining = max(timerDuration - elapsed, 0)
                    let minutes = Int(remaining) / 60
                    let seconds = Int(remaining) % 60
                    
                    Text(String(format: "%02d:%02d", minutes, seconds))
                        .font(.system(size: 30))
                        .bold()
                
                    Text(timerIsRunning ? "Pause" : (elapsed == 0 ? "Start" : "Resume"))
                        
                        .font(.system(size: 20))
                        
                        
                }
                .frame(width: 140, height: 140)
                .glassEffect(.regular.tint(.gray.opacity(0.05)).interactive())
                .clipShape(Circle())
                .padding(0)
            }
        }
        .presentationBackground(.background.opacity(0.5))
        .presentationDetents([.fraction(0.3)])
    }
    
    func startPomodoro() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.elapsed < timerDuration {
                withAnimation(.smooth) {
                    self.elapsed += 1
                }
            } else {
                self.elapsed = timerDuration
                self.timerIsRunning = false
            }
        }
    }
}



#Preview {
    TimerView(timerType: .constant(.pomodoro), timerDuration: .constant(1500), breakDuration: .constant(300))
}
