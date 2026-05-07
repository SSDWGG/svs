import ActivityKit
import Foundation

@MainActor
final class StudyReminderActivityService: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var statusText = "灵动岛提醒未开启"

    private var currentActivity: Activity<StudyReminderAttributes>?
    private var updateTask: Task<Void, Never>?

    init() {
        currentActivity = Activity<StudyReminderAttributes>.activities.first
        isRunning = currentActivity != nil
        statusText = isRunning ? "灵动岛提醒运行中" : "灵动岛提醒未开启"
    }

    func start(lessonTitle: String, lessonTarget: String) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            statusText = "请在系统设置中开启实时活动"
            return
        }

        updateTask?.cancel()
        await endExistingActivities()

        let initialState = StudyReminderActivityService.makeState(
            lessonTitle: lessonTitle,
            lessonTarget: lessonTarget,
            phase: 0
        )

        do {
            let activity = try Activity<StudyReminderAttributes>.request(
                attributes: StudyReminderAttributes(startedAt: Date()),
                content: ActivityContent(
                    state: initialState,
                    staleDate: Date().addingTimeInterval(60 * 60)
                ),
                pushType: nil
            )
            currentActivity = activity
            isRunning = true
            statusText = "灵动岛提醒运行中"
            startUpdateLoop(for: activity, lessonTitle: lessonTitle, lessonTarget: lessonTarget)
        } catch {
            isRunning = false
            statusText = "灵动岛提醒启动失败"
        }
    }

    func stop() async {
        updateTask?.cancel()
        updateTask = nil

        if let currentActivity {
            await currentActivity.end(nil, dismissalPolicy: .immediate)
        }

        currentActivity = nil
        isRunning = false
        statusText = "灵动岛提醒未开启"
    }

    private func endExistingActivities() async {
        for activity in Activity<StudyReminderAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    private func startUpdateLoop(
        for activity: Activity<StudyReminderAttributes>,
        lessonTitle: String,
        lessonTarget: String
    ) {
        updateTask = Task { [weak self] in
            var phase = 0

            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 60_000_000_000)
                phase = (phase + 1) % 8
                let state = StudyReminderActivityService.makeState(
                    lessonTitle: lessonTitle,
                    lessonTarget: lessonTarget,
                    phase: phase
                )
                await activity.update(
                    ActivityContent(
                        state: state,
                        staleDate: Date().addingTimeInterval(60 * 60)
                    )
                )

                await MainActor.run {
                    self?.isRunning = true
                    self?.statusText = "小猫正在提醒你学习"
                }
            }
        }
    }

    private static func makeState(
        lessonTitle: String,
        lessonTarget: String,
        phase: Int
    ) -> StudyReminderAttributes.ContentState {
        StudyReminderAttributes.ContentState(
            lessonTitle: lessonTitle,
            lessonTarget: lessonTarget,
            prompt: "快来斯内克口语学习",
            catActionPhase: phase
        )
    }
}
