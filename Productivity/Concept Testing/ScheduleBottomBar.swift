//
//  ScheduleBottomBarTest.swift
//  Productivity
//
//  Created by Khi Kidman on 7/2/25.
//

import SwiftUI

struct ScheduleBottomBarTest: View {
    @State private var center: Int = 24
    // For snapping effect in TabView
    @State private var selection: Int = 1 // 0: left, 1: center, 2: right

    var body: some View {
        // Sliding window: [center-1, center, center+1]
        TabView(selection: $selection) {
            ForEach(0..<3) { i in
                let current = center + i - 1
                ZStack {
                    Color.clear
                    HStack(spacing: 40) {
                        ForEach(-1...1, id: \.self) { offset in
                            let num = current + offset
                            Text("\(num)")
                                .font(.largeTitle)
                                .fontWeight(offset == 0 ? .bold : .regular)
                                .foregroundColor(offset == 0 ? .blue : .primary)
                                .frame(width: 60, height: 60)
                                .background(offset == 0 ? Color(.systemGray5) : Color.clear)
                                .clipShape(Circle())
                        }
                    }
                }
                .tag(i)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 120)
        .onChange(of: selection) { oldValue, newValue in
            if newValue == 2 {
                center += 1
                selection = 1
            } else if newValue == 0 {
                center -= 1
                selection = 1
            }
        }
    }
}

#Preview {
    ScheduleBottomBarTest()
}
