import ActivityKit
import SwiftUI
import WidgetKit

private struct DailyLesson {
    let id: String
    let title: String
    let target: String
    let ipa: String
}

private let dailyLessons = [
    DailyLesson(id: "vowel-i", title: "长元音 /iː/", target: "sheep", ipa: "/ʃiːp/"),
    DailyLesson(id: "vowel-ih", title: "短元音 /ɪ/", target: "ship", ipa: "/ʃɪp/"),
    DailyLesson(id: "vowel-e", title: "短元音 /e/", target: "bed", ipa: "/bed/"),
    DailyLesson(id: "vowel-ae", title: "梅花音 /æ/", target: "cat", ipa: "/kæt/"),
    DailyLesson(id: "vowel-er", title: "卷舌元音 /ɜː(ɝ)/", target: "bird", ipa: "/bɝːd/"),
    DailyLesson(id: "vowel-schwa", title: "弱读 /ə/", target: "about", ipa: "/əˈbaʊt/"),
    DailyLesson(id: "vowel-uh", title: "短元音 /ʌ/", target: "cup", ipa: "/kʌp/"),
    DailyLesson(id: "vowel-aa", title: "长元音 /ɑː/", target: "father", ipa: "/ˈfɑːðər/"),
    DailyLesson(id: "vowel-ɒ", title: "短元音 /ɒ/", target: "hot", ipa: "/hɒt/"),
    DailyLesson(id: "vowel-aw", title: "长元音 /ɔː/", target: "law", ipa: "/lɔː/"),
    DailyLesson(id: "vowel-u-short", title: "短元音 /ʊ/", target: "book", ipa: "/bʊk/"),
    DailyLesson(id: "vowel-u-long", title: "长元音 /uː/", target: "food", ipa: "/fuːd/"),
    DailyLesson(id: "vowel-ei", title: "双元音 /eɪ/", target: "day", ipa: "/deɪ/"),
    DailyLesson(id: "vowel-ai", title: "双元音 /aɪ/", target: "my", ipa: "/maɪ/"),
    DailyLesson(id: "vowel-oi", title: "双元音 /ɔɪ/", target: "boy", ipa: "/bɔɪ/"),
    DailyLesson(id: "vowel-ou", title: "双元音 /əʊ(oʊ)/", target: "go", ipa: "/ɡoʊ/"),
    DailyLesson(id: "vowel-au", title: "双元音 /aʊ/", target: "now", ipa: "/naʊ/"),
    DailyLesson(id: "vowel-ear", title: "集中双元音 /ɪə/", target: "near", ipa: "/nɪə/"),
    DailyLesson(id: "vowel-air", title: "集中双元音 /eə/", target: "hair", ipa: "/heə/"),
    DailyLesson(id: "vowel-ure", title: "集中双元音 /ʊə/", target: "pure", ipa: "/pjʊə/"),
    DailyLesson(id: "ipa-p", title: "清爆破音 /p/", target: "pen", ipa: "/pen/"),
    DailyLesson(id: "ipa-b", title: "浊爆破音 /b/", target: "bed", ipa: "/bed/"),
    DailyLesson(id: "ipa-t", title: "清爆破音 /t/", target: "tea", ipa: "/tiː/"),
    DailyLesson(id: "ipa-d", title: "浊爆破音 /d/", target: "day", ipa: "/deɪ/"),
    DailyLesson(id: "ipa-k", title: "清爆破音 /k/", target: "key", ipa: "/kiː/"),
    DailyLesson(id: "ipa-g", title: "浊爆破音 /ɡ/", target: "go", ipa: "/ɡoʊ/"),
    DailyLesson(id: "ipa-f", title: "清摩擦音 /f/", target: "fish", ipa: "/fɪʃ/"),
    DailyLesson(id: "ipa-v", title: "浊摩擦音 /v/", target: "very", ipa: "/ˈveri/"),
    DailyLesson(id: "ipa-th-voiceless", title: "清辅音 /θ/", target: "think", ipa: "/θɪŋk/"),
    DailyLesson(id: "ipa-th-voiced", title: "浊辅音 /ð/", target: "this", ipa: "/ðɪs/"),
    DailyLesson(id: "ipa-s", title: "清摩擦音 /s/", target: "see", ipa: "/siː/"),
    DailyLesson(id: "ipa-z", title: "浊摩擦音 /z/", target: "zoo", ipa: "/zuː/"),
    DailyLesson(id: "ipa-sh", title: "清摩擦音 /ʃ/", target: "she", ipa: "/ʃiː/"),
    DailyLesson(id: "ipa-zh", title: "浊摩擦音 /ʒ/", target: "measure", ipa: "/ˈmeʒər/"),
    DailyLesson(id: "ipa-h", title: "清擦音 /h/", target: "he", ipa: "/hiː/"),
    DailyLesson(id: "ipa-ch", title: "清塞擦音 /tʃ/", target: "cheese", ipa: "/tʃiːz/"),
    DailyLesson(id: "ipa-j", title: "浊塞擦音 /dʒ/", target: "juice", ipa: "/dʒuːs/"),
    DailyLesson(id: "ipa-tr", title: "辅音连缀 /tr/", target: "tree", ipa: "/triː/"),
    DailyLesson(id: "ipa-dr", title: "辅音连缀 /dr/", target: "dream", ipa: "/driːm/"),
    DailyLesson(id: "ipa-ts", title: "辅音连缀 /ts/", target: "cats", ipa: "/kæts/"),
    DailyLesson(id: "ipa-dz", title: "辅音连缀 /dz/", target: "cards", ipa: "/kɑːrdz/"),
    DailyLesson(id: "ipa-m", title: "鼻音 /m/", target: "man", ipa: "/mæn/"),
    DailyLesson(id: "ipa-n", title: "鼻音 /n/", target: "no", ipa: "/noʊ/"),
    DailyLesson(id: "ipa-ng", title: "鼻音 /ŋ/", target: "sing", ipa: "/sɪŋ/"),
    DailyLesson(id: "ipa-r", title: "卷舌近音 /r/", target: "red", ipa: "/red/"),
    DailyLesson(id: "ipa-l", title: "清晰 /l/", target: "light", ipa: "/laɪt/"),
    DailyLesson(id: "ipa-y", title: "半元音 /j/", target: "yes", ipa: "/jes/"),
    DailyLesson(id: "ipa-w", title: "半元音 /w/", target: "we", ipa: "/wiː/")
]

private struct OrangeSpeakingEntry: TimelineEntry {
    let date: Date
    let lesson: DailyLesson
}

private struct OrangeSpeakingTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> OrangeSpeakingEntry {
        OrangeSpeakingEntry(date: .now, lesson: dailyLessons[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (OrangeSpeakingEntry) -> Void) {
        completion(entry(for: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OrangeSpeakingEntry>) -> Void) {
        let now = Date()
        let calendar = Calendar.current
        let entries = (0..<7).compactMap { offset -> OrangeSpeakingEntry? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: now) else {
                return nil
            }
            return entry(for: date)
        }

        let nextRefresh = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 6),
            matchingPolicy: .nextTime
        ) ?? now.addingTimeInterval(86_400)
        completion(Timeline(entries: entries, policy: .after(nextRefresh)))
    }

    private func entry(for date: Date) -> OrangeSpeakingEntry {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: date) ?? 0
        return OrangeSpeakingEntry(date: date, lesson: dailyLessons[day % dailyLessons.count])
    }
}

private struct OrangeSpeakingWidgetView: View {
    let entry: OrangeSpeakingEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        ZStack {
            Color(red: 1.00, green: 0.96, blue: 0.88)

            if family == .systemSmall {
                smallLayout
            } else {
                mediumLayout
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 1.00, green: 0.96, blue: 0.88)
        }
        .widgetURL(deepLinkURL)
    }

    private var smallLayout: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                OrangeWidgetMark()
                    .frame(width: 24, height: 24)
                Text("斯内克口语")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.13))
                Spacer(minLength: 0)
            }

            Text(entry.lesson.target)
                .font(.system(size: 32, weight: .black, design: .rounded))
                .minimumScaleFactor(0.7)
                .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.13))

            Text(entry.lesson.ipa)
                .font(.caption.weight(.heavy))
                .foregroundStyle(Color(red: 0.06, green: 0.44, blue: 0.36))

            Spacer(minLength: 0)

            HStack {
                Image("LobeHub")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 36)
                Spacer()
                Label("练习", systemImage: "speaker.wave.2.fill")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(Color(red: 0.06, green: 0.44, blue: 0.36))
            }
        }
        .padding(12)
    }

    private var mediumLayout: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    OrangeWidgetMark()
                        .frame(width: 28, height: 28)
                    Text("斯内克口语")
                        .font(.subheadline.weight(.black))
                        .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.13))
                }

                Text("今日基础发音")
                    .font(.caption2.weight(.black))
                    .foregroundStyle(Color(red: 0.42, green: 0.43, blue: 0.40))

                Text(entry.lesson.target)
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.13))

                Text(entry.lesson.ipa)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(Color(red: 0.06, green: 0.44, blue: 0.36))

                Text(entry.lesson.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color(red: 0.42, green: 0.43, blue: 0.40))

                Spacer(minLength: 0)

                Label("打开练习", systemImage: "speaker.wave.2.fill")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color(red: 0.06, green: 0.44, blue: 0.36))
            }

            Spacer(minLength: 0)

            Image("LobeHub")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .opacity(0.9)
        }
        .padding(14)
    }

    private var deepLinkURL: URL? {
        let lessonID = entry.lesson.id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? entry.lesson.id
        return URL(string: "orangespeaking://lesson/\(lessonID)")
    }
}

private struct OrangeWidgetMark: View {
    var body: some View {
        Image("CatFace")
            .resizable()
            .scaledToFill()
            .frame(width: 32, height: 32)
            .clipShape(Circle())
    }
}

struct OrangeSpeakingWidget: Widget {
    let kind = "OrangeSpeakingDailyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OrangeSpeakingTimelineProvider()) { entry in
            OrangeSpeakingWidgetView(entry: entry)
        }
        .configurationDisplayName("斯内克口语每日练习")
        .description("每天提醒你练一个基础口语发音。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct StudyReminderLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StudyReminderAttributes.self) { context in
            StudyReminderLockScreenView(context: context)
                .activityBackgroundTint(Color(red: 1.00, green: 0.96, blue: 0.88))
                .activitySystemActionForegroundColor(Color(red: 0.06, green: 0.44, blue: 0.36))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    LobeHubExpandedView()
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("快来学习")
                            .font(.headline.weight(.black))
                        Text(context.state.lessonTarget)
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(Color(red: 1.00, green: 0.48, blue: 0.10))
                    }
                    .lineLimit(1)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text(context.state.lessonTitle)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                        Text("斯内克口语")
                    }
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color(red: 1.00, green: 0.96, blue: 0.88))
                }
            } compactLeading: {
                EmbeddedLobeHubView(size: 22)
            } compactTrailing: {
                Text(context.state.lessonTarget)
                    .font(.caption.weight(.black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)
            } minimal: {
                EmbeddedLobeHubView(size: 18)
            }
            .widgetURL(URL(string: "orangespeaking://today"))
            .keylineTint(Color(red: 1.00, green: 0.48, blue: 0.10))
        }
    }
}

private struct StudyReminderLockScreenView: View {
    let context: ActivityViewContext<StudyReminderAttributes>

    var body: some View {
        HStack(spacing: 14) {
            LobeHubLockScreenView()

            VStack(alignment: .leading, spacing: 5) {
                Text(context.state.prompt)
                    .font(.headline.weight(.black))
                    .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.13))
                Text(context.state.lessonTitle)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color(red: 0.42, green: 0.43, blue: 0.40))
                    .lineLimit(1)
                Text(context.state.lessonTarget)
                    .font(.title2.weight(.black))
                    .foregroundStyle(Color(red: 0.06, green: 0.44, blue: 0.36))
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .widgetURL(URL(string: "orangespeaking://today"))
    }
}

private let lobeHubEmbeddedB64 = "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"

private func lobeHubImage() -> UIImage? {
    guard let data = Data(base64Encoded: lobeHubEmbeddedB64) else { return nil }
    return UIImage(data: data)
}

private struct EmbeddedLobeHubView: View {
    let size: CGFloat
    var body: some View {
        if let img = lobeHubImage() {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color(red: 1.00, green: 0.48, blue: 0.10))
                .frame(width: size, height: size)
        }
    }
}

private struct LobeHubExpandedView: View {
    var body: some View {
        if let img = lobeHubImage() {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 118, height: 64)
        }
    }
}

private struct LobeHubLockScreenView: View {
    var body: some View {
        if let img = lobeHubImage() {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 104, height: 66)
        }
    }
}

@main
struct OrangeSpeakingWidgetBundle: WidgetBundle {
    var body: some Widget {
        OrangeSpeakingWidget()
        StudyReminderLiveActivityWidget()
    }
}
