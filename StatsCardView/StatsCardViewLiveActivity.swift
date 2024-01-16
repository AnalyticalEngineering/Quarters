//
//  StatsCardViewLiveActivity.swift
//  StatsCardView
//
//  Created by J. DeWeese on 1/16/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StatsCardViewAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StatsCardViewLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StatsCardViewAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension StatsCardViewAttributes {
    fileprivate static var preview: StatsCardViewAttributes {
        StatsCardViewAttributes(name: "World")
    }
}

extension StatsCardViewAttributes.ContentState {
    fileprivate static var smiley: StatsCardViewAttributes.ContentState {
        StatsCardViewAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: StatsCardViewAttributes.ContentState {
         StatsCardViewAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: StatsCardViewAttributes.preview) {
   StatsCardViewLiveActivity()
} contentStates: {
    StatsCardViewAttributes.ContentState.smiley
    StatsCardViewAttributes.ContentState.starEyes
}
