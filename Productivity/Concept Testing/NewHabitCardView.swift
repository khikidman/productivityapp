//
//  NewHabitCardView.swift
//  Productivity
//
//  Created by Khi Kidman on 7/3/25.
//

import SwiftUI

struct NewHabitCardView: View {
    let goal: CGFloat = 5
    @State var current: CGFloat = 1
    var progressBarWidth: CGFloat = 336
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                HStack {
                    Image(systemName: "book")
                        .font(.system(size: 30))
                    Text("Reading")
                        .bold()
                    Spacer()
                    Button {
                        current += 1
                    } label: {
                        Circle().overlay(
                            Image(systemName: "checkmark")
                                .tint(.black)
                        )
                        .tint(.pink)
                        .frame(width: 40, height: 40)
                        .glassEffect(.regular.interactive())
                    }
                }
                .padding(.vertical, 8)
                
                ZStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .frame(width: progressBarWidth, height: 24)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.pink.opacity(0.5))
                        .frame(width: current >= goal ? progressBarWidth : min(current / goal, 1) * progressBarWidth)
                        .glassEffect()
                        .animation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0.5), value: current)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.pink)
                        .frame(width: current <= goal ? min(current / goal, 1) * progressBarWidth : (goal / current) * progressBarWidth)
                        .glassEffect()
                        .animation(.bouncy(extraBounce: 0.15), value: current)
                }
                .overlay(
                    HStack {
                        Text("Pages Read")
                            .font(.caption)
                            .bold()
                        Spacer()
                        Text("\(Int(current))/\(Int(goal))")
                            .font(.caption)
                            .frame(alignment: .trailing)
                            .bold()
                    }
                        .padding(.horizontal, 6)
                )
            }
            .padding(.horizontal, 20)
            
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                
            } label: {
                Image(systemName: "trash")
            }
            Button {
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            NewHabitCardView()
        }
        
    }
}
