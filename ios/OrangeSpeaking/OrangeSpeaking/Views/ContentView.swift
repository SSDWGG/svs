import SwiftUI

private extension Color {
    static let orangePaper = Color(red: 1.00, green: 0.97, blue: 0.91)
    static let orangeSurface = Color(red: 1.00, green: 0.99, blue: 0.96)
    static let orangeInk = Color(red: 0.11, green: 0.11, blue: 0.13)
    static let orangeMuted = Color(red: 0.42, green: 0.43, blue: 0.40)
    static let orangeCitrus = Color(red: 1.00, green: 0.48, blue: 0.10)
    static let orangeLeaf = Color(red: 0.06, green: 0.44, blue: 0.36)
    static let orangeLine = Color(red: 0.90, green: 0.84, blue: 0.76)
}

struct ContentView: View {
    @EnvironmentObject private var viewModel: LessonViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    HeaderView(tts: viewModel.tts)
                    StagePickerView()
                    ProgressSummaryView()
                    LessonListView()
                    LessonBoardView()
                    PracticeView(practice: viewModel.practice)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 20)
            }
            .background(Color.orangePaper.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct HeaderView: View {
    @ObservedObject var tts: TTSService
    @EnvironmentObject private var viewModel: LessonViewModel
    @State private var showsSettings = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image("CatFace")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeCitrus.opacity(0.55), lineWidth: 2))

                VStack(alignment: .leading, spacing: 3) {
                    Text("斯内克口语")
                        .font(.system(size: 31, weight: .black, design: .rounded))
                        .foregroundStyle(Color.orangeInk)
                    Text("Snake Speaking")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.orangeMuted)
                }

                Spacer()

                Button {
                    showsSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.orangeLeaf)
                        .frame(width: 44, height: 44)
                        .background(Color.orangeSurface, in: Circle())
                }
                .accessibilityLabel("设置")
            }

            HStack(spacing: 8) {
                Image(systemName: "waveform")
                Text(tts.state.label)
                    .lineLimit(1)
                Spacer()
            }
            .font(.subheadline.weight(.heavy))
            .foregroundStyle(Color.orangeLeaf)
            .padding(.horizontal, 14)
            .frame(height: 42)
            .background(Color.orangeSurface, in: Capsule())
            .overlay(Capsule().stroke(Color.orangeLine))

            if showsSettings {
                VStack(alignment: .leading, spacing: 8) {
                    Text("TTS 服务地址")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.orangeMuted)
                    TextField("http://192.168.x.x:5174", text: $tts.baseURLText)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .font(.footnote.weight(.bold))
                        .padding(12)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
                    Text("真机调试时填 Mac 局域网地址；正式发布应改为 HTTPS 后端。")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.orangeMuted)
                }
                .padding(14)
                .background(Color.orangeSurface, in: RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orangeLine))

                StudyReminderView(service: viewModel.studyReminder, lesson: viewModel.selectedLesson)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeLine))
    }
}

private struct StagePickerView: View {
    @EnvironmentObject private var viewModel: LessonViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(LessonStage.allCases) { stage in
                let isActive = viewModel.selectedStage == stage

                Button {
                    viewModel.selectStage(stage)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: stage.symbol)
                            .frame(width: 26, height: 26)
                            .foregroundStyle(Color.orangeCitrus)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(stage.title)
                                .font(.headline.weight(.black))
                            Text(stage.subtitle)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.orangeMuted)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(14)
                    .frame(minHeight: 72)
                    .foregroundStyle(Color.orangeInk)
                    .background(isActive ? Color.orangeCitrus.opacity(0.20) : Color.orangeSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isActive ? Color.orangeCitrus : Color.orangeLine, lineWidth: isActive ? 2 : 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct ProgressSummaryView: View {
    @EnvironmentObject private var viewModel: LessonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("学习进度")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.orangeMuted)
                    Text("\(viewModel.selectedStage.title) \(viewModel.stageProgressText)")
                        .font(.title3.weight(.black))
                        .foregroundStyle(Color.orangeInk)
                }

                Spacer()

                Text("总计 \(viewModel.totalProgressText)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.orangeLeaf)
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background(Color.orangeLeaf.opacity(0.10), in: Capsule())
            }

            ProgressView(value: viewModel.stageProgress)
                .tint(Color.orangeCitrus)

            ProgressView(value: viewModel.totalProgress)
                .tint(Color.orangeLeaf)
        }
        .padding(16)
        .background(Color.white.opacity(0.70), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeLine))
    }
}

private struct StudyReminderView: View {
    @ObservedObject var service: StudyReminderActivityService
    let lesson: Lesson

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                CatBadge()
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 4) {
                    Text("灵动岛学习提醒")
                        .font(.headline.weight(.black))
                        .foregroundStyle(Color.orangeInk)
                    Text(service.statusText)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.orangeMuted)
                }

                Spacer()
            }

            HStack(spacing: 10) {
                Button {
                    Task {
                        await service.start(
                            lessonTitle: lesson.title,
                            lessonTarget: lesson.target
                        )
                    }
                } label: {
                    Label(service.isRunning ? "更新提醒" : "开启提醒", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.orangeCitrus)

                if service.isRunning {
                    Button {
                        Task {
                            await service.stop()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.black))
                            .frame(width: 44, height: 36)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.orangeLeaf)
                    .accessibilityLabel("关闭灵动岛提醒")
                }
            }
            .font(.headline.weight(.black))
        }
        .padding(16)
        .background(Color.white.opacity(0.70), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeLine))
    }
}

private struct CatBadge: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.orangeLeaf.opacity(0.12))
            Image("LobeHub")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.orangeCitrus.opacity(0.55), lineWidth: 2))
        }
    }
}

private struct LessonListView: View {
    @EnvironmentObject private var viewModel: LessonViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.selectedStage.title)
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.orangeMuted)
                Spacer()
                Text(viewModel.selectedIndexText)
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.orangeLeaf)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.stageLessons) { lesson in
                        LessonChip(
                            lesson: lesson,
                            isActive: lesson.id == viewModel.selectedLessonID,
                            isCompleted: viewModel.isCompleted(lesson)
                        ) {
                            viewModel.selectLesson(lesson)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.68), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeLine))
    }
}

private struct LessonChip: View {
    let lesson: Lesson
    let isActive: Bool
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 6) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isCompleted ? Color.orangeLeaf : Color.orangeMuted)
                    Text(isCompleted ? "已学" : "未学")
                        .font(.caption2.weight(.black))
                        .foregroundStyle(isCompleted ? Color.orangeLeaf : Color.orangeMuted)
                    Spacer(minLength: 0)
                }
                Text(lesson.title)
                    .font(.subheadline.weight(.black))
                    .lineLimit(1)
                Text(lesson.ipa)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(Color.orangeLeaf)
                    .lineLimit(1)
            }
            .frame(width: 168, alignment: .leading)
            .padding(14)
            .background(isCompleted ? Color.orangeLeaf.opacity(0.10) : (isActive ? Color.orangeCitrus.opacity(0.18) : Color.orangeSurface))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isActive ? Color.orangeCitrus : (isCompleted ? Color.orangeLeaf.opacity(0.45) : Color.orangeLine), lineWidth: isActive ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.orangeInk)
    }
}

private struct LessonBoardView: View {
    @EnvironmentObject private var viewModel: LessonViewModel

    private var lesson: Lesson { viewModel.selectedLesson }
    private var isCompleted: Bool { viewModel.isCompleted(lesson) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(lesson.category)
                            .font(.caption.weight(.black))
                            .foregroundStyle(Color.orangeMuted)
                        Text(isCompleted ? "已学" : "未学")
                            .font(.caption2.weight(.black))
                            .foregroundStyle(isCompleted ? Color.orangeLeaf : Color.orangeMuted)
                            .padding(.horizontal, 8)
                            .frame(height: 24)
                            .background(isCompleted ? Color.orangeLeaf.opacity(0.12) : Color.orangeLine.opacity(0.45), in: Capsule())
                    }
                    Text(lesson.target)
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .minimumScaleFactor(0.52)
                        .lineLimit(2)
                        .foregroundStyle(Color.orangeInk)
                    Text(lesson.ipa)
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color.orangeLeaf)
                }

                Spacer(minLength: 6)

                Button {
                    Task { await viewModel.playSelected() }
                } label: {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.title2.weight(.black))
                        .foregroundStyle(Color.orangePaper)
                        .frame(width: 62, height: 62)
                        .background(Color.orangeInk, in: Circle())
                }
                .accessibilityLabel("播放标准发音")
            }

            Button {
                viewModel.toggleSelectedCompletion()
            } label: {
                Label(isCompleted ? "取消已学" : "标记已学", systemImage: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.headline.weight(.black))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(isCompleted ? Color.orangeLeaf : Color.orangeCitrus)

            VStack(spacing: 12) {
                InfoPanel(title: "发音重点", text: lesson.focus)
                InfoPanel(title: "口型提示", text: lesson.mouthCue)
                InfoPanel(title: "易混对比", text: lesson.contrast)
            }

            ExampleRow(examples: lesson.examples)

            VStack(spacing: 12) {
                Slider(value: $viewModel.speed, in: 0.8...1.15, step: 0.01) {
                    Text("语速")
                }
                .tint(Color.orangeLeaf)

                HStack {
                    Button("上一个") {
                        viewModel.move(-1)
                    }
                    Spacer()
                    Text(speedLabel)
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.orangeMuted)
                    Spacer()
                    Button("下一个") {
                        viewModel.move(1)
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
        }
        .padding(20)
        .background(Color.orangeSurface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeInk, lineWidth: 2))
    }

    private var speedLabel: String {
        if viewModel.speed < 0.9 { return "慢速" }
        if viewModel.speed > 1.08 { return "挑战" }
        return "原速"
    }
}

private struct InfoPanel: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.black))
                .foregroundStyle(Color.orangeMuted)
            Text(text)
                .font(.body.weight(.bold))
                .foregroundStyle(Color.orangeInk)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orangeLine))
    }
}

private struct ExampleRow: View {
    @EnvironmentObject private var viewModel: LessonViewModel
    let examples: [String]

    var body: some View {
        FlowLayout(spacing: 9) {
            ForEach(examples, id: \.self) { example in
                Button {
                    Task { await viewModel.playText(example) }
                } label: {
                    Label(example, systemImage: "play.fill")
                        .font(.caption.weight(.black))
                        .padding(.horizontal, 12)
                        .frame(height: 38)
                        .background(Color.white, in: Capsule())
                        .overlay(Capsule().stroke(Color.orangeLine))
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.orangeInk)
            }
        }
    }
}

private struct PracticeView: View {
    @EnvironmentObject private var viewModel: LessonViewModel
    @ObservedObject var practice: SpeechPracticeService

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("跟读")
                        .font(.caption.weight(.black))
                        .foregroundStyle(Color.orangeMuted)
                    Text(viewModel.selectedLesson.practiceText)
                        .font(.title3.weight(.black))
                        .foregroundStyle(Color.orangeInk)
                }
                Spacer()
                Text(practice.state.label)
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.orangeLeaf)
                    .padding(.horizontal, 10)
                    .frame(height: 30)
                    .background(Color.orangeLeaf.opacity(0.10), in: Capsule())
            }

            WaveMeter(isRecording: practice.state == .recording)

            HStack(spacing: 10) {
                Button {
                    Task { await viewModel.toggleRecording() }
                } label: {
                    Label(practice.state == .recording ? "停止" : "录音", systemImage: practice.state == .recording ? "stop.fill" : "mic.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.orangeCitrus)

                Button {
                    practice.reset()
                } label: {
                    Label("重置", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(Color.orangeLeaf)
            }
            .font(.headline.weight(.black))

            if practice.recordingURL != nil {
                Label("录音已保存，可再次录音覆盖。", systemImage: "checkmark.circle.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.orangeLeaf)
            } else {
                Text("No recording")
                    .font(.caption.weight(.black))
                    .foregroundStyle(Color.orangeMuted)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orangeLine, style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    )
            }

            HStack(spacing: 10) {
                ScoreTile(title: "识别文本", value: practice.transcript.isEmpty ? "等待录音" : practice.transcript)
                ScoreTile(title: "匹配度", value: practice.score.map { "\($0)%" } ?? "--")
                    .frame(width: 104)
            }

            Label("标准音频以火山 TTS 为准，匹配度只作为练习反馈。", systemImage: "checkmark.seal")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.orangeLeaf)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orangeLeaf.opacity(0.10), in: RoundedRectangle(cornerRadius: 10))
        }
        .padding(18)
        .background(Color.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orangeLine))
    }
}

private struct ScoreTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption.weight(.black))
                .foregroundStyle(Color.orangeMuted)
            Text(value)
                .font(.headline.weight(.black))
                .foregroundStyle(Color.orangeInk)
                .lineLimit(3)
                .minimumScaleFactor(0.74)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 92)
        .padding(12)
        .background(Color.orangeSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orangeLine))
    }
}

private struct WaveMeter: View {
    let isRecording: Bool
    private let values: [Double] = [0.34, 0.58, 0.82, 0.48, 0.72, 0.40, 0.64]

    var body: some View {
        HStack(alignment: .bottom, spacing: 9) {
            ForEach(values.indices, id: \.self) { index in
                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.orangeCitrus, Color.orangeLeaf],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: CGFloat(values[index]) * (isRecording ? 116 : 92))
                    .animation(.easeInOut(duration: 0.28).repeatCount(isRecording ? 18 : 1, autoreverses: true), value: isRecording)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 132)
        .padding(.horizontal, 16)
        .background(Color.orangeCitrus.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orangeLine))
    }
}

private struct OrangeMark: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.orangeSurface)
            Circle()
                .fill(Color.orangeCitrus)
                .padding(9)
            Circle()
                .fill(Color.orangeCitrus.opacity(0.28))
                .padding(18)
            VStack(spacing: 9) {
                Capsule()
                    .frame(width: 24, height: 4)
                Capsule()
                    .frame(width: 30, height: 4)
            }
            .foregroundStyle(Color.orangeInk)
            LeafShape()
                .fill(Color.orangeLeaf)
                .frame(width: 18, height: 12)
                .offset(x: 14, y: -22)
        }
    }
}

private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.9)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.35)
        )
        return path
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 320
        var point = CGPoint.zero
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if point.x > 0, point.x + size.width > width {
                point.x = 0
                point.y += rowHeight + spacing
                rowHeight = 0
            }
            rowHeight = max(rowHeight, size.height)
            point.x += size.width + spacing
        }

        return CGSize(width: width, height: point.y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var point = CGPoint(x: bounds.minX, y: bounds.minY)
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if point.x > bounds.minX, point.x + size.width > bounds.maxX {
                point.x = bounds.minX
                point.y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: point, proposal: ProposedViewSize(size))
            rowHeight = max(rowHeight, size.height)
            point.x += size.width + spacing
        }
    }
}
