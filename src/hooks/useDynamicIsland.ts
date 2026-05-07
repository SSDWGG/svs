import { useState, useEffect, useRef, useCallback } from 'react'

const REMINDER_INTERVAL_MS = 30 * 60 * 1000
const PILL_AUTO_DISMISS_MS = 6000

export function useDynamicIsland(enabled: boolean) {
  const [showPill, setShowPill] = useState(false)
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const dismissTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  const dismissPill = useCallback(() => {
    setShowPill(false)
    if (dismissTimerRef.current) {
      clearTimeout(dismissTimerRef.current)
      dismissTimerRef.current = null
    }
  }, [])

  useEffect(() => {
    if (enabled) {
      if ('Notification' in window && Notification.permission === 'default') {
        Notification.requestPermission()
      }

      intervalRef.current = setInterval(() => {
        setShowPill(true)

        if ('Notification' in window && Notification.permission === 'granted') {
          new Notification('斯内克口语', {
            body: '该开始练习口语了！',
            icon: '/lobehub-color.svg',
          })
        }

        dismissTimerRef.current = setTimeout(() => {
          setShowPill(false)
        }, PILL_AUTO_DISMISS_MS)
      }, REMINDER_INTERVAL_MS)
    }

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current)
      if (dismissTimerRef.current) clearTimeout(dismissTimerRef.current)
      setShowPill(false)
    }
  }, [enabled])

  return { showPill, dismissPill }
}
