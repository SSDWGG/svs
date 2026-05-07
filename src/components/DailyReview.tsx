import { ArrowLeft } from 'lucide-react'
import type { StudyRecord } from '../hooks/useStudyHistory'

const groupedByDate = (records: StudyRecord[]): [string, StudyRecord[]][] => {
  const map = new Map<string, StudyRecord[]>()
  for (const record of records) {
    const dateKey = new Date(record.timestamp).toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      weekday: 'long',
    })
    const group = map.get(dateKey) ?? []
    group.push(record)
    map.set(dateKey, group)
  }
  return [...map.entries()]
}

type DailyReviewProps = {
  records: StudyRecord[]
  onSelectLesson: (lessonId: string) => void
  onBack: () => void
}

const DailyReview = ({ records, onSelectLesson, onBack }: DailyReviewProps) => (
  <section className="daily-review">
    <header className="review-header">
      <button className="review-back" onClick={onBack}>
        <ArrowLeft size={18} aria-hidden="true" />
        <span>返回练习</span>
      </button>
      <h2>学习记录</h2>
    </header>

    {records.length === 0 ? (
      <div className="review-empty">
        <p>还没有学习记录</p>
        <p>开始跟读练习，记录会自动保存</p>
      </div>
    ) : (
      <div className="review-list">
        {groupedByDate(records).map(([dateLabel, dateRecords]) => (
          <div className="review-date-group" key={dateLabel}>
            <h3>{dateLabel}</h3>
            <div className="review-date-records">
              {dateRecords.map((record) => (
                <button
                  className="review-record-tile"
                  key={`${record.lessonId}-${record.timestamp}`}
                  onClick={() => onSelectLesson(record.lessonId)}
                >
                  <div className="record-info">
                    <span className="record-title">{record.lessonTitle}</span>
                    <time className="record-time">
                      {new Date(record.timestamp).toLocaleTimeString('zh-CN', {
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </time>
                  </div>
                  <span
                    className="record-score"
                    data-high={record.score !== null && record.score >= 78}
                  >
                    {record.score !== null ? `${record.score}%` : '--'}
                  </span>
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>
    )}
  </section>
)

export default DailyReview
