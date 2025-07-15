//
//  PomodoroWidgetLiveActivity.swift
//  PomodoroWidget
//
//  Created by Khi Kidman on 7/8/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var currentTime: TimeInterval
        var isRunning: Bool
    }

    var countdown: TimeInterval
}

struct PomodoroActivityConfiguration: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 8) {
                let remaining = max(context.state.currentTime, 0)
                let minutes = Int(remaining) / 60
                let seconds = Int(remaining) % 60
                Text("\(minutes) min \(seconds) sec left")
                    .font(.headline)
                ProgressView(value: (context.attributes.countdown - remaining) / context.attributes.countdown)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
            }
            .padding()
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            let remaining = max(context.state.currentTime, 0)
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60

            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "clock")
                        .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("\(minutes) min \(seconds) sec")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: context.state.isRunning ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
            } compactLeading: {
                Image(systemName: "clock")
            } compactTrailing: {
                Text("\(seconds)s")
            } minimal: {
                Text("\(minutes) min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PomodoroAttributes {
    fileprivate static var preview: PomodoroAttributes {
        PomodoroAttributes(countdown: 1500)
    }
}

extension PomodoroAttributes.ContentState {
    fileprivate static var running: PomodoroAttributes.ContentState {
        PomodoroAttributes.ContentState(currentTime: 900, isRunning: true)
    }

    fileprivate static var paused: PomodoroAttributes.ContentState {
        PomodoroAttributes.ContentState(currentTime: 600, isRunning: false)
    }
}

#Preview("Notification", as: .content, using: PomodoroAttributes.preview) {
    PomodoroActivityConfiguration()
} contentStates: {
    PomodoroAttributes.ContentState.running
    PomodoroAttributes.ContentState.paused
}
