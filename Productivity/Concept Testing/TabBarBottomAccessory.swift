//
//  TabBarBottomAccessory.swift
//  Productivity
//
//  Created by Khi Kidman on 6/29/25.
//

import SwiftUI

struct TabBarBottomAccessory: View {
    @Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Label("Box Breathing", systemImage: "clock")
            }
            .frame(maxWidth: .infinity)
            .glassEffect(.regular.interactive())
            Button("Timer") {
                
            }
            .frame(maxWidth: .infinity)
            .glassEffect(.regular.interactive())
        }
        .padding(.horizontal, 8)
    }
}
