//
//  Formula1XWidgetLiveActivity.swift
//  Formula1XWidget
//
//  Created by Vaidik Dubey on 11/05/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Formula1XWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Formula1XWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Formula1XWidgetAttributes.self) { context in
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

extension Formula1XWidgetAttributes {
    fileprivate static var preview: Formula1XWidgetAttributes {
        Formula1XWidgetAttributes(name: "World")
    }
}

extension Formula1XWidgetAttributes.ContentState {
    fileprivate static var smiley: Formula1XWidgetAttributes.ContentState {
        Formula1XWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Formula1XWidgetAttributes.ContentState {
         Formula1XWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Formula1XWidgetAttributes.preview) {
   Formula1XWidgetLiveActivity()
} contentStates: {
    Formula1XWidgetAttributes.ContentState.smiley
    Formula1XWidgetAttributes.ContentState.starEyes
}
