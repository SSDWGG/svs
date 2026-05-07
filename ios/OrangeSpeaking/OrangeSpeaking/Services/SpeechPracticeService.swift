import AVFoundation
import Foundation
import Speech

enum PracticeState: Equatable {
    case idle
    case requestingPermission
    case recording
    case processing
    case ready
    case blocked(String)

    var label: String {
        switch self {
        case .idle: "等待录音"
        case .requestingPermission: "请求权限"
        case .recording: "录音中"
        case .processing: "识别中"
        case .ready: "已完成"
        case .blocked(let message): message
        }
    }
}

enum Similarity {
    static func score(expected: String, actual: String) -> Int {
        let expectedTokens = tokens(expected)
        let actualTokens = tokens(actual)

        guard !expectedTokens.isEmpty, !actualTokens.isEmpty else {
            return 0
        }

        let hits = expectedTokens.filter { actualTokens.contains($0) }.count
        let tokenScore = Double(hits) / Double(expectedTokens.count)
        let expectedLetters = Array(expectedTokens.joined())
        let actualLetters = Array(actualTokens.joined())
        let sharedLetters = zip(expectedLetters, actualLetters).filter { $0 == $1 }.count
        let letterScore = Double(sharedLetters) / Double(max(expectedLetters.count, actualLetters.count))

        return Int((tokenScore * 0.65 + letterScore * 0.35) * 100)
    }

    private static func tokens(_ value: String) -> [String] {
        value
            .lowercased()
            .split { !$0.isLetter }
            .map(String.init)
    }
}

@MainActor
final class SpeechPracticeService: NSObject, ObservableObject {
    @Published var state: PracticeState = .idle
    @Published var transcript = ""
    @Published var score: Int?
    @Published var recordingURL: URL?

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var recorder: AVAudioRecorder?
    private var recognitionTask: SFSpeechRecognitionTask?

    func reset() {
        recorder?.stop()
        recognitionTask?.cancel()
        recorder = nil
        recognitionTask = nil
        transcript = ""
        score = nil
        recordingURL = nil
        state = .idle
    }

    func startRecording() async {
        reset()
        state = .requestingPermission

        guard await requestPermissions() else {
            state = .blocked("请开启麦克风和语音识别权限")
            return
        }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("orange-speaking-\(UUID().uuidString).m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            recordingURL = url
            state = .recording
        } catch {
            state = .blocked("录音启动失败")
        }
    }

    func stopRecording(expectedText: String) {
        guard state == .recording, let url = recordingURL else { return }
        recorder?.stop()
        recorder = nil
        state = .processing
        recognize(url: url, expectedText: expectedText)
    }

    private func requestPermissions() async -> Bool {
        let speechAllowed = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }

        let microphoneAllowed = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { allowed in
                continuation.resume(returning: allowed)
            }
        }

        return speechAllowed && microphoneAllowed
    }

    private func recognize(url: URL, expectedText: String) {
        guard let recognizer, recognizer.isAvailable else {
            state = .blocked("语音识别当前不可用")
            return
        }

        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        recognitionTask?.cancel()
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let service = self else { return }

                if let result {
                    service.transcript = result.bestTranscription.formattedString
                    service.score = Similarity.score(
                        expected: expectedText,
                        actual: result.bestTranscription.formattedString
                    )
                    if result.isFinal {
                        service.state = .ready
                    }
                }

                if error != nil, service.transcript.isEmpty {
                    service.state = .blocked("没有识别到清晰语音")
                } else if error != nil {
                    service.state = .ready
                }
            }
        }
    }
}
