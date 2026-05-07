import crypto from 'node:crypto'

export class MissingTtsConfigError extends Error {
  constructor() {
    super('Volcengine TTS credentials are not configured')
    this.name = 'MissingTtsConfigError'
  }
}

export class VolcengineTtsError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'VolcengineTtsError'
  }
}

type SynthesisInput = {
  text: string
  speedRatio?: number
}

type VolcengineResponse = {
  code: number
  message?: string
  data?: string
}

const DEFAULT_TTS_URL = 'https://openspeech.bytedance.com/api/v1/tts'
const DEFAULT_CLUSTER = 'volcano_tts'
const DEFAULT_VOICE = 'BV503_streaming'

const clamp = (value: number, min: number, max: number) => Math.min(Math.max(value, min), max)

const getConfig = () => {
  const appId = process.env.VOLCENGINE_TTS_APP_ID
  const token = process.env.VOLCENGINE_TTS_ACCESS_TOKEN

  if (!appId || !token) {
    throw new MissingTtsConfigError()
  }

  return {
    appId,
    token,
    cluster: process.env.VOLCENGINE_TTS_CLUSTER_ID ?? DEFAULT_CLUSTER,
    voiceType: process.env.VOLCENGINE_TTS_VOICE_TYPE ?? DEFAULT_VOICE,
    url: process.env.VOLCENGINE_TTS_URL ?? DEFAULT_TTS_URL,
  }
}

export const hasVolcengineConfig = () =>
  Boolean(process.env.VOLCENGINE_TTS_APP_ID && process.env.VOLCENGINE_TTS_ACCESS_TOKEN)

export const synthesizeSpeech = async ({ text, speedRatio = 1 }: SynthesisInput) => {
  const cleanText = text.trim()
  if (!cleanText) {
    throw new VolcengineTtsError('Text is required')
  }

  const config = getConfig()
  const payload = {
    app: {
      appid: config.appId,
      token: config.token,
      cluster: config.cluster,
    },
    user: {
      uid: 'orange-speaking-local',
    },
    audio: {
      voice_type: config.voiceType,
      encoding: 'mp3',
      speed_ratio: clamp(speedRatio, 0.7, 1.3),
      volume_ratio: 1,
      pitch_ratio: 1,
      rate: 24000,
    },
    request: {
      reqid: crypto.randomUUID(),
      text: cleanText,
      text_type: 'plain',
      operation: 'query',
      silence_duration: '125',
      pure_english_opt: '1',
    },
  }

  const response = await fetch(config.url, {
    method: 'POST',
    headers: {
      Authorization: `Bearer;${config.token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  })

  if (!response.ok) {
    throw new VolcengineTtsError(`Volcengine TTS request failed: ${response.status}`)
  }

  const data = (await response.json()) as VolcengineResponse
  if (data.code !== 3000 || !data.data) {
    throw new VolcengineTtsError(data.message ?? `Volcengine TTS returned code ${data.code}`)
  }

  return Buffer.from(data.data, 'base64')
}
