import 'dotenv/config'
import express from 'express'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import {
  hasVolcengineConfig,
  MissingTtsConfigError,
  synthesizeSpeech,
  VolcengineTtsError,
} from './volcengine.ts'

const app = express()
const port = Number(process.env.PORT ?? 5174)
const dirname = path.dirname(fileURLToPath(import.meta.url))
const distPath = path.resolve(dirname, '../dist')
const indexPath = path.join(distPath, 'index.html')

app.use(express.json({ limit: '64kb' }))

app.get('/api/health', (_request, response) => {
  response.json({
    ok: true,
    ttsConfigured: hasVolcengineConfig(),
    voiceType: process.env.VOLCENGINE_TTS_VOICE_TYPE ?? 'BV503_streaming',
  })
})

app.post('/api/tts', async (request, response) => {
  try {
    const text = typeof request.body?.text === 'string' ? request.body.text : ''
    const speedRatio =
      typeof request.body?.speedRatio === 'number' ? request.body.speedRatio : undefined
    const audio = await synthesizeSpeech({ text, speedRatio })

    response.setHeader('Content-Type', 'audio/mpeg')
    response.setHeader('Cache-Control', 'no-store')
    response.send(audio)
  } catch (error) {
    if (error instanceof MissingTtsConfigError) {
      response.status(503).json({
        error: 'VOLCENGINE_TTS_APP_ID and VOLCENGINE_TTS_ACCESS_TOKEN are required',
      })
      return
    }

    if (error instanceof VolcengineTtsError) {
      response.status(502).json({ error: error.message })
      return
    }

    response.status(500).json({ error: 'Unexpected TTS error' })
  }
})

if (fs.existsSync(distPath)) {
  app.use(express.static(distPath))
}

app.get(/.*/, (_request, response) => {
  if (fs.existsSync(indexPath)) {
    response.sendFile(indexPath)
    return
  }

  response.status(404).json({
    error: 'Run npm run build before using the production server.',
  })
})

app.listen(port, () => {
  console.log(`Snake Speaking API listening on http://localhost:${port}`)
})
