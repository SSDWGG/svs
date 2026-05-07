import AVFoundation
import Foundation

enum PlaybackState: Equatable {
    case idle
    case loading
    case volcengine
    case nativeVoice
    case failed(String)

    var label: String {
        switch self {
        case .idle: "待播放"
        case .loading: "合成中"
        case .volcengine: "火山 BV503_streaming"
        case .nativeVoice: "iOS 英文语音"
        case .failed(let message): message
        }
    }
}

private struct TTSRequest: Encodable {
    let text: String
    let speedRatio: Double
}

private enum PlaybackError: Error {
    case failedToStart
}

@MainActor
final class TTSService: NSObject, ObservableObject {
    @Published var state: PlaybackState = .idle
    @Published var baseURLText: String {
        didSet {
            UserDefaults.standard.set(baseURLText, forKey: Self.baseURLKey)
        }
    }

    private static let baseURLKey = "orange-speaking-tts-base-url"
    private let synthesizer = AVSpeechSynthesizer()
    private var player: AVAudioPlayer?

    override init() {
        baseURLText = UserDefaults.standard.string(forKey: Self.baseURLKey) ?? "http://localhost:5174"
        super.init()
    }

    func play(text: String, speed: Double) async {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        state = .loading
        synthesizer.stopSpeaking(at: .immediate)
        player?.stop()

        do {
            try preparePlaybackSession()
            let data = try await requestVolcengineAudio(text: trimmedText, speed: speed)
            player = try AVAudioPlayer(data: data)
            player?.prepareToPlay()
            guard player?.play() == true else {
                throw PlaybackError.failedToStart
            }
            state = .volcengine
        } catch {
            playNativeVoice(text: trimmedText, speed: speed)
        }
    }

    private func requestVolcengineAudio(text: String, speed: Double) async throws -> Data {
        guard let baseURL = URL(string: baseURLText) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: baseURL.appendingPathComponent("api/tts"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
            TTSRequest(text: text, speedRatio: min(max(speed, 0.7), 1.3))
        )

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    private func preparePlaybackSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try session.setActive(true)
    }

    private func playNativeVoice(text: String, speed: Double) {
        do {
            try preparePlaybackSession()
        } catch {
            state = .failed("音频启动失败")
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = min(max(AVSpeechUtteranceDefaultSpeechRate * Float(speed), 0.32), 0.62)
        utterance.pitchMultiplier = 1
        utterance.volume = 1
        synthesizer.speak(utterance)
        state = .nativeVoice
    }
}
