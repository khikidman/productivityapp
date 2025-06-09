//
//  HourGrid.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct HourGrid: View {
    @Binding var hourHeight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<25, id: \.self) { hour in
                HStack(alignment: .center) {
                    NewScheduleView.formatHour(hour)
                        .frame(width: 50, alignment: .trailing)
                        .padding(.leading, 4)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .frame(height: hourHeight)
            }
        }
    }
}
