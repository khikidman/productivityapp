//
//  FitnessToolbarAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/14/25.
//

import SwiftUI

struct FitnessToolbarAccessory: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    var body: some View {
        if (placement == .inline) {
            Text("hello")
        } else {
            HStack {
                HStack {
                    Image(systemName: "dumbbell.fill")
                    VStack(alignment: .leading) {
                        Text("Active Workout")
                        Text("Push Day - Chest")
                            .font(.system(size: 13))
                    }
                    Spacer()
                    Image(systemName: "pause.fill")
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainView(showSignInView: .constant(false))
        .environmentObject(TodoViewModel())
        .environmentObject(HabitViewModel())
}
