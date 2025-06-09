//
//  SwiftUIView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/8/25.
//

import SwiftUI

struct CalendarEventCard: View {
    @State private var progress: CGFloat = 0.0
        
        let cardWidth: CGFloat = 300
        let cardHeight: CGFloat = 80
    let barWidth: CGFloat = 2.8
        
        var body: some View {
            ZStack(alignment: .leading) {
                // Background color (optional)
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.blue.opacity(0.3))
                
                // The animated stroke
                RoundedRectangle(cornerRadius: 2)
                    .trim(from: max(0, 0.5 - progress/2), to: min(1, 0.5 + progress/2))
                    .stroke(Color.blue, lineWidth: 3)
                    .padding(5.4)
                
//                RoundedRectangle(cornerRadius: 2)
//                    .fill(Color.blue)
//                    .padding(6)
//                    .frame(width: progress * cardWidth)
//                    .animation( .easeIn, value: progress)
                
                // Left side bar stays visible at all times
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(width: max(barWidth,  progress * cardWidth))
                    .padding(4)
                    .padding(.vertical, 2)
                    .animation(.easeInOut, value: progress)
                
                Text("Go to the gym")
                    .font(.caption.bold())
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(8)
                    .padding(.horizontal, 4)
            }
            .frame(width: cardWidth, height: cardHeight)
            .onTapGesture {
                withAnimation(.snappy(duration: 0.25)) {
                    progress = progress == 0 ? 1.0 : 0.0
                }
            }
        }
}

#Preview {
    CalendarEventCard()
}
