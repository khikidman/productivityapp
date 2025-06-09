//
//  DayEvent.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DayEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    var startHour: Int
    let durationHours: Int
    
    init(id: UUID = UUID(), title: String, startHour: Int, durationHours: Int) {
        self.id = id
        self.title = title
        self.startHour = startHour
        self.durationHours = durationHours
    }
}

extension DayEvent: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .dayEvent)
    }
}

extension UTType {
    static var dayEvent: UTType {
        .data
    }
}
