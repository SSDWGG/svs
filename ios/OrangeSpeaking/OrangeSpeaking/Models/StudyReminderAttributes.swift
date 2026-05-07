import ActivityKit
import Foundation

struct StudyReminderAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var lessonTitle: String
        var lessonTarget: String
        var prompt: String
        var catActionPhase: Int
    }

    var startedAt: Date
}
