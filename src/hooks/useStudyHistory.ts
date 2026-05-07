import { useCallback } from 'react'
import { useLocalStorage } from './useLocalStorage'

export type StudyRecord = {
  lessonId: string
  lessonTitle: string
  timestamp: number
  score: number | null
}

const STORAGE_KEY = 'svs-study-history'

export function useStudyHistory() {
  const [records, setRecords] = useLocalStorage<StudyRecord[]>(STORAGE_KEY, [])

  const addRecord = useCallback(
    (record: StudyRecord) => {
      setRecords((prev) => [record, ...prev])
    },
    [setRecords],
  )

  const clearRecords = useCallback(() => {
    setRecords([])
  }, [setRecords])

  return { records, addRecord, clearRecords }
}
