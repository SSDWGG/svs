import Foundation

@MainActor
final class LessonViewModel: ObservableObject {
    @Published var selectedStage: LessonStage = .vowels
    @Published var selectedLessonID: Lesson.ID = Lesson.curriculum[0].id
    @Published var speed: Double = 1
    @Published private(set) var completedLessonIDs: Set<Lesson.ID> = []

    let tts = TTSService()
    let practice = SpeechPracticeService()
    let studyReminder = StudyReminderActivityService()
    private let completedLessonsKey = "orange-speaking-completed-lessons"

    init() {
        let savedIDs = UserDefaults.standard.stringArray(forKey: completedLessonsKey) ?? []
        completedLessonIDs = Set(savedIDs)
    }

    var lessons: [Lesson] { Lesson.curriculum }

    var stageLessons: [Lesson] {
        lessons.filter { $0.stage == selectedStage }
    }

    var selectedLesson: Lesson {
        lessons.first { $0.id == selectedLessonID } ?? lessons[0]
    }

    var selectedIndexText: String {
        let index = stageLessons.firstIndex { $0.id == selectedLessonID } ?? 0
        return "\(index + 1)/\(stageLessons.count)"
    }

    var completedCount: Int {
        lessons.filter { completedLessonIDs.contains($0.id) }.count
    }

    var totalProgressText: String {
        "\(completedCount)/\(lessons.count)"
    }

    var totalProgress: Double {
        guard !lessons.isEmpty else { return 0 }
        return Double(completedCount) / Double(lessons.count)
    }

    var stageProgressText: String {
        "\(completedCount(in: selectedStage))/\(stageLessons.count)"
    }

    var stageProgress: Double {
        guard !stageLessons.isEmpty else { return 0 }
        return Double(completedCount(in: selectedStage)) / Double(stageLessons.count)
    }

    func completedCount(in stage: LessonStage) -> Int {
        lessons.filter { $0.stage == stage && completedLessonIDs.contains($0.id) }.count
    }

    func isCompleted(_ lesson: Lesson) -> Bool {
        completedLessonIDs.contains(lesson.id)
    }

    func openDeepLink(_ url: URL) {
        guard url.scheme == "orangespeaking" else {
            return
        }

        if url.host == "lesson",
           let lessonID = url.pathComponents.dropFirst().first?.removingPercentEncoding {
            selectLesson(id: lessonID)
            return
        }

        if url.host == "today" {
            selectLesson(id: dailyLessonID(for: Date()))
        }
    }

    func selectStage(_ stage: LessonStage) {
        selectedStage = stage
        if let first = lessons.first(where: { $0.stage == stage }) {
            selectedLessonID = first.id
        }
        practice.reset()
    }

    func selectLesson(_ lesson: Lesson) {
        selectedLessonID = lesson.id
        practice.reset()
    }

    func move(_ direction: Int) {
        guard let currentIndex = stageLessons.firstIndex(where: { $0.id == selectedLessonID }) else {
            return
        }

        let nextIndex = (currentIndex + direction + stageLessons.count) % stageLessons.count
        selectedLessonID = stageLessons[nextIndex].id
        practice.reset()
    }

    func playSelected() async {
        await tts.play(text: selectedLesson.practiceText, speed: speed)
    }

    func playText(_ text: String) async {
        await tts.play(text: text, speed: speed)
    }

    func toggleSelectedCompletion() {
        if completedLessonIDs.contains(selectedLesson.id) {
            completedLessonIDs.remove(selectedLesson.id)
        } else {
            completedLessonIDs.insert(selectedLesson.id)
        }
        saveCompletedLessons()
    }

    func toggleRecording() async {
        if practice.state == .recording {
            practice.stopRecording(expectedText: selectedLesson.practiceText)
        } else {
            await practice.startRecording()
        }
    }

    private func saveCompletedLessons() {
        UserDefaults.standard.set(Array(completedLessonIDs).sorted(), forKey: completedLessonsKey)
    }

    private func selectLesson(id: Lesson.ID) {
        guard let lesson = lessons.first(where: { $0.id == id }) else {
            return
        }

        selectedStage = lesson.stage
        selectedLessonID = lesson.id
        practice.reset()
    }

    private func dailyLessonID(for date: Date) -> Lesson.ID {
        let phonemeLessons = lessons.filter { $0.stage == .vowels || $0.stage == .ipa }
        guard !phonemeLessons.isEmpty else {
            return selectedLessonID
        }

        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return phonemeLessons[day % phonemeLessons.count].id
    }
}
