import { useEffect, useMemo, useRef, useState } from 'react'
import {
  AudioLines,
  CheckCircle2,
  Gauge,
  History,
  Mic,
  Pause,
  Play,
  RefreshCcw,
  Settings,
  Square,
  Volume2,
} from 'lucide-react'
import './App.css'
import SettingsPanel from './components/SettingsPanel'
import DailyReview from './components/DailyReview'
import { useLocalStorage } from './hooks/useLocalStorage'
import { useStudyHistory } from './hooks/useStudyHistory'
import { useDynamicIsland } from './hooks/useDynamicIsland'
import { lessons, stages, type LessonItem, type StageId } from './lessons'

type PlaybackStatus = 'idle' | 'loading' | 'volcengine' | 'browser' | 'error'
type RecorderStatus = 'idle' | 'recording' | 'ready'

type SpeechRecognitionResult = {
  transcript: string
  confidence: number
}

type BrowserSpeechRecognition = {
  lang: string
  interimResults: boolean
  maxAlternatives: number
  onresult: ((event: SpeechRecognitionEventLike) => void) | null
  onerror: (() => void) | null
  onend: (() => void) | null
  start: () => void
  stop: () => void
}

type SpeechRecognitionEventLike = {
  results: {
    [index: number]: {
      [index: number]: SpeechRecognitionResult
    }
  }
}

declare global {
  interface Window {
    SpeechRecognition?: new () => BrowserSpeechRecognition
    webkitSpeechRecognition?: new () => BrowserSpeechRecognition
  }
}

const speedOptions = [
  { label: '慢速', value: 0.82 },
  { label: '原速', value: 1 },
  { label: '挑战', value: 1.12 },
]

const normalizeText = (value: string) =>
  value
    .toLowerCase()
    .replace(/[^a-z\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim()

const getSimilarity = (expected: string, actual: string) => {
  const target = normalizeText(expected)
  const heard = normalizeText(actual)

  if (!target || !heard) {
    return 0
  }

  const targetTokens = target.split(' ')
  const heardTokens = heard.split(' ')
  const hits = targetTokens.filter((token) => heardTokens.includes(token)).length
  const tokenScore = hits / targetTokens.length

  const sharedLetters = [...target].filter((char, index) => char === heard[index]).length
  const letterScore = sharedLetters / Math.max(target.length, heard.length)

  return Math.round((tokenScore * 0.65 + letterScore * 0.35) * 100)
}

const selectEnglishVoice = () => {
  if (!('speechSynthesis' in window)) {
    return undefined
  }

  const voices = window.speechSynthesis.getVoices()
  return (
    voices.find((voice) => voice.lang === 'en-US' && /samantha|google|ava|jenny|aria/i.test(voice.name)) ??
    voices.find((voice) => voice.lang === 'en-US') ??
    voices.find((voice) => voice.lang.startsWith('en'))
  )
}

const App = () => {
  const [stageId, setStageId] = useState<StageId>('vowels')
  const [selectedId, setSelectedId] = useState(lessons[0].id)
  const [speedRatio, setSpeedRatio] = useState(1)
  const [playbackStatus, setPlaybackStatus] = useState<PlaybackStatus>('idle')
  const [playbackMessage, setPlaybackMessage] = useState('BV503_streaming')
  const [recorderStatus, setRecorderStatus] = useState<RecorderStatus>('idle')
  const [recordingUrl, setRecordingUrl] = useState<string | null>(null)
  const [recognitionText, setRecognitionText] = useState('')
  const [recognitionScore, setRecognitionScore] = useState<number | null>(null)
  const [recorderError, setRecorderError] = useState('')
  const mediaRecorderRef = useRef<MediaRecorder | null>(null)
  const chunksRef = useRef<Blob[]>([])
  const audioRef = useRef<HTMLAudioElement | null>(null)
  const recognitionRef = useRef<BrowserSpeechRecognition | null>(null)
  const [showSettings, setShowSettings] = useState(false)
  const [showReview, setShowReview] = useState(false)
  const [dynamicIslandEnabled, setDynamicIslandEnabled] = useLocalStorage('svs-dynamic-island', false)
  const { records, addRecord } = useStudyHistory()
  const { showPill, dismissPill } = useDynamicIsland(dynamicIslandEnabled)

  const stageLessons = useMemo(
    () => lessons.filter((lesson) => lesson.stage === stageId),
    [stageId],
  )

  const selectedLesson = useMemo(
    () => lessons.find((lesson) => lesson.id === selectedId) ?? lessons[0],
    [selectedId],
  )

  const currentIndex = stageLessons.findIndex((lesson) => lesson.id === selectedLesson.id)
  const canRecognize = Boolean(window.SpeechRecognition ?? window.webkitSpeechRecognition)

  useEffect(() => {
    return () => {
      if (recordingUrl) {
        URL.revokeObjectURL(recordingUrl)
      }
    }
  }, [recordingUrl])

  useEffect(() => {
    if (recognitionScore !== null && recorderStatus === 'ready') {
      addRecord({
        lessonId: selectedLesson.id,
        lessonTitle: selectedLesson.title,
        timestamp: Date.now(),
        score: recognitionScore,
      })
    }
  }, [recognitionScore, recorderStatus, selectedLesson.id, selectedLesson.title, addRecord])

  const resetPractice = () => {
    setRecognitionText('')
    setRecognitionScore(null)
    setRecorderError('')
    if (recordingUrl) {
      URL.revokeObjectURL(recordingUrl)
      setRecordingUrl(null)
    }
    setRecorderStatus('idle')
  }

  const playWithBrowserVoice = (text: string, rate: number) => {
    if (!('speechSynthesis' in window)) {
      setPlaybackStatus('error')
      setPlaybackMessage('当前浏览器没有可用语音')
      return
    }

    window.speechSynthesis.cancel()
    const utterance = new SpeechSynthesisUtterance(text)
    utterance.lang = 'en-US'
    utterance.rate = rate
    utterance.pitch = 1
    utterance.volume = 1
    const voice = selectEnglishVoice()
    if (voice) {
      utterance.voice = voice
    }
    utterance.onend = () => setPlaybackStatus('browser')
    window.speechSynthesis.speak(utterance)
    setPlaybackStatus('browser')
    setPlaybackMessage(voice ? voice.name : 'Browser English Voice')
  }

  const playLessonAudio = async (lesson: LessonItem, rate = speedRatio) => {
    setPlaybackStatus('loading')
    setPlaybackMessage('合成中')

    try {
      const response = await fetch('/api/tts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          text: lesson.practiceText,
          speedRatio: rate,
        }),
      })

      if (!response.ok) {
        throw new Error('tts unavailable')
      }

      const contentType = response.headers.get('content-type') ?? ''
      if (!contentType.includes('audio/')) {
        throw new Error('tts did not return audio')
      }

      const audioBlob = await response.blob()
      const audioUrl = URL.createObjectURL(audioBlob)
      audioRef.current?.pause()
      audioRef.current = new Audio(audioUrl)
      audioRef.current.onended = () => URL.revokeObjectURL(audioUrl)
      await audioRef.current.play()
      setPlaybackStatus('volcengine')
      setPlaybackMessage('火山 BV503_streaming')
    } catch {
      playWithBrowserVoice(lesson.practiceText, rate)
    }
  }

  const startRecognition = () => {
    const Recognition = window.SpeechRecognition ?? window.webkitSpeechRecognition
    if (!Recognition) {
      return
    }

    const recognition = new Recognition()
    recognition.lang = 'en-US'
    recognition.interimResults = false
    recognition.maxAlternatives = 1
    recognition.onresult = (event) => {
      const transcript = event.results[0][0].transcript
      setRecognitionText(transcript)
      setRecognitionScore(getSimilarity(selectedLesson.practiceText, transcript))
    }
    recognition.onerror = () => {
      setRecorderError('浏览器识别失败')
    }
    recognitionRef.current = recognition
    recognition.start()
  }

  const startRecording = async () => {
    setRecorderError('')
    setRecognitionText('')
    setRecognitionScore(null)

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
      chunksRef.current = []
      const recorder = new MediaRecorder(stream)
      mediaRecorderRef.current = recorder
      recorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          chunksRef.current.push(event.data)
        }
      }
      recorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: 'audio/webm' })
        if (recordingUrl) {
          URL.revokeObjectURL(recordingUrl)
        }
        setRecordingUrl(URL.createObjectURL(blob))
        setRecorderStatus('ready')
        stream.getTracks().forEach((track) => track.stop())
      }
      recorder.start()
      setRecorderStatus('recording')
      startRecognition()
    } catch {
      setRecorderError('麦克风不可用')
      setRecorderStatus('idle')
    }
  }

  const stopRecording = () => {
    mediaRecorderRef.current?.stop()
    recognitionRef.current?.stop()
  }

  const selectLesson = (lesson: LessonItem) => {
    setSelectedId(lesson.id)
    resetPractice()
  }

  const selectStage = (nextStageId: StageId) => {
    const firstInStage = lessons.find((lesson) => lesson.stage === nextStageId)
    setStageId(nextStageId)
    if (firstInStage) {
      setSelectedId(firstInStage.id)
    }
    resetPractice()
  }

  const goToLesson = (direction: -1 | 1) => {
    const nextIndex = (currentIndex + direction + stageLessons.length) % stageLessons.length
    const nextLesson = stageLessons[nextIndex]
    if (nextLesson) {
      selectLesson(nextLesson)
    }
  }

  const playbackLabel = {
    idle: '待播放',
    loading: '合成中',
    volcengine: playbackMessage,
    browser: playbackMessage,
    error: playbackMessage,
  }[playbackStatus]

  return (
    <main className="app-shell">
      <header className="topbar">
        <div className="brand-lockup">
          <img src="/lobehub-color.svg" width="48" height="48" alt="斯内克口语" />
          <div>
            <h1>斯内克口语</h1>
            <span>Snake Speaking</span>
          </div>
        </div>
        <div className="topbar-actions">
          <div className="topbar-status" aria-live="polite">
            <AudioLines size={18} aria-hidden="true" />
            <span>{playbackLabel}</span>
          </div>
          <button
            className="topbar-icon-btn"
            data-active={showReview}
            onClick={() => {
              setShowReview((v) => !v)
              setShowSettings(false)
            }}
            title="学习记录"
            aria-label="学习记录"
          >
            <History size={18} aria-hidden="true" />
          </button>
          <button
            className="topbar-icon-btn"
            onClick={() => {
              setShowSettings(true)
              setShowReview(false)
            }}
            title="设置"
            aria-label="设置"
          >
            <Settings size={18} aria-hidden="true" />
          </button>
        </div>
      </header>

      <section className="stage-strip" aria-label="课程阶段">
        {stages.map((stage) => {
          const Icon = stage.icon
          const isActive = stage.id === stageId
          return (
            <button
              className="stage-button"
              type="button"
              aria-pressed={isActive}
              data-active={isActive}
              key={stage.id}
              onClick={() => selectStage(stage.id)}
            >
              <Icon size={20} aria-hidden="true" />
              <span>{stage.name}</span>
              <small>{stage.accent}</small>
            </button>
          )
        })}
      </section>

      {showReview ? (
        <DailyReview
          records={records}
          onSelectLesson={(lessonId) => {
            const lesson = lessons.find((l) => l.id === lessonId)
            if (lesson) {
              setStageId(lesson.stage)
              setSelectedId(lesson.id)
              resetPractice()
            }
            setShowReview(false)
          }}
          onBack={() => setShowReview(false)}
        />
      ) : (
        <section className="workspace">
          <aside className="lesson-rail" aria-label="课程列表">
          <div className="rail-heading">
            <span>{stages.find((stage) => stage.id === stageId)?.name}</span>
            <strong>
              {currentIndex + 1}/{stageLessons.length}
            </strong>
          </div>
          <div className="lesson-list">
            {stageLessons.map((lesson) => (
              <button
                className="lesson-tile"
                type="button"
                data-active={lesson.id === selectedLesson.id}
                key={lesson.id}
                onClick={() => selectLesson(lesson)}
              >
                <span>{lesson.title}</span>
                <strong>{lesson.ipa}</strong>
              </button>
            ))}
          </div>
        </aside>

        <article className="lesson-board">
          <div className="target-band">
            <div>
              <span className="eyebrow">{selectedLesson.category}</span>
              <h2>{selectedLesson.target}</h2>
              <p>{selectedLesson.ipa}</p>
            </div>
            <button
              className="icon-button loud"
              type="button"
              onClick={() => void playLessonAudio(selectedLesson)}
              aria-label="播放标准发音"
            >
              {playbackStatus === 'loading' ? (
                <Pause size={24} aria-hidden="true" />
              ) : (
                <Volume2 size={24} aria-hidden="true" />
              )}
            </button>
          </div>

          <div className="lesson-grid">
            <section className="lesson-panel">
              <span className="panel-label">发音重点</span>
              <p>{selectedLesson.focus}</p>
            </section>
            <section className="lesson-panel">
              <span className="panel-label">口型提示</span>
              <p>{selectedLesson.mouthCue}</p>
            </section>
            <section className="lesson-panel wide">
              <span className="panel-label">易混对比</span>
              <p>{selectedLesson.contrast}</p>
            </section>
          </div>

          <div className="example-row" aria-label="例词或例句">
            {selectedLesson.examples.map((example) => (
              <button
                type="button"
                key={example}
                onClick={() =>
                  void playLessonAudio({
                    ...selectedLesson,
                    practiceText: example,
                  })
                }
              >
                <Play size={15} aria-hidden="true" />
                <span>{example}</span>
              </button>
            ))}
          </div>

          <div className="transport">
            <button type="button" onClick={() => goToLesson(-1)}>
              上一个
            </button>
            <div className="speed-control" aria-label="语速">
              {speedOptions.map((option) => (
                <button
                  type="button"
                  key={option.label}
                  data-active={speedRatio === option.value}
                  onClick={() => {
                    setSpeedRatio(option.value)
                    void playLessonAudio(selectedLesson, option.value)
                  }}
                >
                  <Gauge size={15} aria-hidden="true" />
                  <span>{option.label}</span>
                </button>
              ))}
            </div>
            <button type="button" onClick={() => goToLesson(1)}>
              下一个
            </button>
          </div>
        </article>

        <aside className="practice-desk" aria-label="跟读练习">
          <div className="practice-header">
            <span className="eyebrow">跟读</span>
            <strong>{selectedLesson.practiceText}</strong>
          </div>

          <div className="meter" aria-hidden="true">
            <span style={{ height: '34%' }} />
            <span style={{ height: '58%' }} />
            <span style={{ height: '82%' }} />
            <span style={{ height: '48%' }} />
            <span style={{ height: '72%' }} />
            <span style={{ height: '40%' }} />
            <span style={{ height: '64%' }} />
          </div>

          <div className="practice-actions">
            <button
              className="primary-action"
              type="button"
              onClick={recorderStatus === 'recording' ? stopRecording : () => void startRecording()}
            >
              {recorderStatus === 'recording' ? (
                <Square size={18} aria-hidden="true" />
              ) : (
                <Mic size={18} aria-hidden="true" />
              )}
              <span>{recorderStatus === 'recording' ? '停止' : '录音'}</span>
            </button>
            <button className="ghost-action" type="button" onClick={resetPractice}>
              <RefreshCcw size={17} aria-hidden="true" />
              <span>重置</span>
            </button>
          </div>

          {recordingUrl ? (
            <audio className="recording-player" src={recordingUrl} controls />
          ) : (
            <div className="empty-recording">No recording</div>
          )}

          <div className="score-box">
            <div>
              <span>识别文本</span>
              <strong>{recognitionText || (canRecognize ? '等待录音' : '浏览器不支持')}</strong>
            </div>
            <div>
              <span>匹配度</span>
              <strong>{recognitionScore === null ? '--' : `${recognitionScore}%`}</strong>
            </div>
          </div>

          <div className="accuracy-note" data-state={recognitionScore !== null && recognitionScore >= 78}>
            <CheckCircle2 size={17} aria-hidden="true" />
            <span>{recorderError || '音频以标准发音为准，识别分仅用于练习反馈。'}</span>
          </div>
        </aside>
      </section>
      )}

      <SettingsPanel
        isOpen={showSettings}
        onClose={() => setShowSettings(false)}
        dynamicIslandEnabled={dynamicIslandEnabled}
        onDynamicIslandChange={setDynamicIslandEnabled}
      />

      {showPill && (
        <div className="dynamic-island-pill">
          <img src="/lobehub-color.svg" width="24" height="24" alt="" />
          <span>该开始练习口语了！</span>
          <button className="pill-dismiss" onClick={dismissPill} type="button">
            知道了
          </button>
        </div>
      )}
    </main>
  )
}

export default App
