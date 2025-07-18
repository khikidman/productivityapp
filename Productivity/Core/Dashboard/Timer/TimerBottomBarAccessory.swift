//
//  TimerBottomBarAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 7/11/25.
//

import SwiftUI

struct TimerBottomBarAccessory: View {
    @Binding var timerTypeOption: TimerTypeOption
    @Binding var timerDuration: TimeInterval
    @Binding var breakDuration: TimeInterval
    
    var body: some View {
        let minutesBinding = Binding<Int>(
            get: { Int(timerDuration) / 60 },
            set: { timerDuration = TimeInterval($0 * 60 + Int(timerDuration) % 60) }
        )
        let secondsBinding = Binding<Int>(
            get: { Int(timerDuration) % 60 },
            set: { timerDuration = TimeInterval((Int(timerDuration) / 60) * 60 + $0) }
        )
        
        HStack {
            Picker("Type", selection: $timerTypeOption){
                ForEach(TimerTypeOption.allCases, id: \.self) { type in
                    //                    Button(action: { withAnimation { timerTypeOption = type } }) {
                    Text(type.typeName).tag(type)
                    //                    }
                }
                //            } label: {
                //                HStack {
                //                    Text(timerTypeOption.typeName)
                //                        .fontWeight(.medium)
                ////                    Image(systemName: "chevron.up.chevron.down")
                ////                        .font(.system(size: 10))
                ////                        .fontWeight(.medium)
                //                }
                //                .padding(.horizontal, 10)
            }
            .pickerStyle(.menu)
            .foregroundStyle(.pink)
            .tint(.pink)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            HStack {
                Picker("Minutes", selection: minutesBinding) {
                    ForEach(0..<60) { Text("\($0) m") }
                }
                .pickerStyle(.wheel)
                Picker("Seconds", selection: secondsBinding) {
                    ForEach(0..<60) { Text("\($0) s") }
                }
                .pickerStyle(.wheel)
                .tint(.pink)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .padding(7)
        
    }
}
