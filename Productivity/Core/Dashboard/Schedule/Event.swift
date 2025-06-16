//
//  Event.swift
//  Productivity
//
//  Created by Khi Kidman on 6/3/25.
//

import Foundation
import SwiftUI

struct Event: Codable, Identifiable {
    let id: UUID
    var title: String
    var startTime: Date
    var endTime: Date
    var colorHex: String
    let sourceType: SourceType
    
    init(id: UUID, title: String, startTime: Date, endTime: Date, colorHex: String = "#ff375f", sourceType: SourceType = .todo) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.colorHex = colorHex
        self.sourceType = sourceType
    }

    enum SourceType : String, Codable {
        case todo, habit
    }
}

extension Event {
    var color: Color {
        Color(hex: colorHex) ?? .blue // fallback if invalid
    }
}


