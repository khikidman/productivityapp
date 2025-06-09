//
//  ScheduledEvent.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ScheduledEvent: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    var startTime: Date
    let endTime: Date
    let sourceType: SourceType

    enum SourceType : String, Codable {
        case todo, habit
    }
    
}

//extension ScheduledEvent: Transferable {
//    static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .scheduledEvent)
//    }
//}
//
//extension UTType {
//    static var scheduledEvent: UTType {
//        .data
//    }
//}
