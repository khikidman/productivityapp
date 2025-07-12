//
//  PomodoroWidgetBundle.swift
//  PomodoroWidget
//
//  Created by Khi Kidman on 7/8/25.
//

import WidgetKit
import SwiftUI

@main
struct PomodoroWidgetBundle: WidgetBundle {
    var body: some Widget {
        PomodoroWidget()
        PomodoroWidgetControl()
        PomodoroWidgetLiveActivity()
    }
}
