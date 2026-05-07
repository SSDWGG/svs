import { X } from 'lucide-react'

type SettingsPanelProps = {
  isOpen: boolean
  onClose: () => void
  dynamicIslandEnabled: boolean
  onDynamicIslandChange: (enabled: boolean) => void
}

const SettingsPanel = ({
  isOpen,
  onClose,
  dynamicIslandEnabled,
  onDynamicIslandChange,
}: SettingsPanelProps) => (
  <>
    {isOpen && <div className="settings-backdrop" onClick={onClose} />}
    <aside className="settings-panel" data-open={isOpen}>
      <header className="settings-header">
        <h2>设置</h2>
        <button className="settings-close" onClick={onClose} aria-label="关闭设置">
          <X size={20} aria-hidden="true" />
        </button>
      </header>

      <section className="settings-body">
        <div className="setting-row">
          <div className="setting-info">
            <strong>灵动岛学习提醒</strong>
            <p>开启后每 30 分钟提醒您练习口语</p>
          </div>
          <label className="toggle-switch">
            <input
              type="checkbox"
              checked={dynamicIslandEnabled}
              onChange={(e) => onDynamicIslandChange(e.currentTarget.checked)}
            />
            <span className="toggle-slider" />
          </label>
        </div>
      </section>
    </aside>
  </>
)

export default SettingsPanel
