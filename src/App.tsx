import { Ear, Languages, BookOpen, MessageSquareText, Mic, Sparkles, LayoutTemplate, TrendingUp, ExternalLink } from 'lucide-react'
import './App.css'

const features = [
  {
    icon: Ear,
    title: '48 音标体系',
    desc: '覆盖 20 个元音 + 28 个辅音，按常见英语音标体系编排，每个音标配有标准发音、口型提示和易混对比。',
  },
  {
    icon: Mic,
    title: 'AI 语音识别',
    desc: '基于 Apple Speech 框架实时识别跟读内容，精准比对发音准确度，给出即时反馈和改进建议。',
  },
  {
    icon: Sparkles,
    title: '火山引擎 TTS',
    desc: '字节跳动火山引擎提供标准音色 BV503_streaming，发音自然流畅，支持慢速/原速/挑战三档语速。',
  },
  {
    icon: LayoutTemplate,
    title: '桌面小组件',
    desc: 'iPhone 主屏幕小组件每日轮换一个基础音标课程，点击直接进入当天练习，让学习融入日常。',
  },
  {
    icon: TrendingUp,
    title: '学习进度追踪',
    desc: '每节课支持「标记已学/取消已学」，课程卡片清晰展示学习状态，一目了然地追踪进步轨迹。',
  },
  {
    icon: Languages,
    title: '词句进阶训练',
    desc: '从单个音标过渡到单词重音节奏训练，再到句子连读、弱读、语调练习，逐步提升口语流利度。',
  },
]

const learningStages = [
  { step: '01', icon: Ear, name: '元音', accent: '短长对比', desc: '区分短元音与长元音，掌握嘴型与舌位要领' },
  { step: '02', icon: Languages, name: '辅音', accent: '清浊送气', desc: '清浊辅音对比、送气控制，攻克易混淆音' },
  { step: '03', icon: BookOpen, name: '单词', accent: '重音节奏', desc: '单词重音与音节节奏，从单音过渡到完整词汇' },
  { step: '04', icon: MessageSquareText, name: '句子', accent: '连读语调', desc: '连读、弱读、语调等语流技巧，说出地道英语' },
]

export default function App() {
  return (
    <div className="landing">
      {/* Nav */}
      <nav className="nav">
        <div className="nav-inner">
          <a href={import.meta.env.BASE_URL} className="logo">
            <img src={`${import.meta.env.BASE_URL}cat_1.png`} alt="" className="logo-img" />
            <span>斯内克口语</span>
          </a>
          <div className="nav-links">
            <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer" className="nav-link">
              <ExternalLink size={20} />
              <span>GitHub</span>
            </a>
          </div>
        </div>
      </nav>

      {/* Hero */}
      <section className="hero">
        <div className="hero-content">
          <div className="hero-badge">AI 驱动的英语口语学习 App</div>
          <h1 className="hero-title">
            开口说英语，
            <br />
            从<span className="hero-highlight">标准发音</span>开始
          </h1>
          <p className="hero-desc">
            覆盖完整 48 个国际音标体系，融合 Apple 语音识别与火山引擎 TTS，
            <br />
            从元音辅音到单词语句，系统练就纯正口语。
          </p>
          <div className="hero-actions">
            <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer" className="btn-primary">
              <ExternalLink size={20} />
              在 GitHub 上查看
            </a>
            <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer" className="btn-outline">
              查看 iOS 工程
            </a>
          </div>
          <div className="hero-meta">
            <span>iOS 14+</span>
            <span className="meta-divider" />
            <span>SwiftUI 原生</span>
            <span className="meta-divider" />
            <span>完全开源</span>
          </div>
        </div>
        <div className="hero-visual">
          <div className="hero-cat-ring">
            <img src={`${import.meta.env.BASE_URL}cat_1.png`} alt="斯内克口语吉祥物" className="hero-cat" />
          </div>
          <div className="hero-float-card hero-float-1">
            <div className="float-icon float-icon-green">
              <Ear size={18} />
            </div>
            <div>
              <div className="float-label">元音 /iː/</div>
              <div className="float-sub">长元音 · 舌位高前</div>
            </div>
          </div>
          <div className="hero-float-card hero-float-2">
            <div className="float-icon float-icon-orange">
              <Mic size={18} />
            </div>
            <div>
              <div className="float-label">跟读得分</div>
              <div className="float-sub">准确度 95%</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="section" id="features">
        <div className="section-header">
          <h2 className="section-title">核心功能</h2>
          <p className="section-desc">为英语口语学习者打造的一站式发音训练工具</p>
        </div>
        <div className="features-grid">
          {features.map((f) => (
            <div className="feature-card" key={f.title}>
              <div className="feature-icon">
                <f.icon size={24} />
              </div>
              <h3 className="feature-title">{f.title}</h3>
              <p className="feature-desc">{f.desc}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Learning Path */}
      <section className="section section-alt" id="path">
        <div className="section-header">
          <h2 className="section-title">四阶段学习路径</h2>
          <p className="section-desc">从发音基础到语流表达，循序渐进</p>
        </div>
        <div className="path-grid">
          {learningStages.map((s) => (
            <div className="path-card" key={s.step}>
              <div className="path-step">{s.step}</div>
              <div className="path-icon">
                <s.icon size={28} />
              </div>
              <h3 className="path-name">{s.name}</h3>
              <span className="path-accent">{s.accent}</span>
              <p className="path-desc">{s.desc}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Tech */}
      <section className="section" id="tech">
        <div className="section-header">
          <h2 className="section-title">技术栈</h2>
          <p className="section-desc">iOS 原生 + AI 能力 + Web 生态</p>
        </div>
        <div className="tech-grid">
          <div className="tech-col">
            <h3 className="tech-label">iOS</h3>
            <ul className="tech-list">
              <li>SwiftUI 构建原生界面</li>
              <li>AVFoundation 音频播放与录音</li>
              <li>Apple Speech 跟读识别</li>
              <li>WidgetKit 桌面小组件</li>
            </ul>
          </div>
          <div className="tech-col">
            <h3 className="tech-label">AI & 后端</h3>
            <ul className="tech-list">
              <li>火山引擎 TTS 语音合成</li>
              <li>Node.js Express API 代理</li>
              <li>安全凭证服务端存储</li>
              <li>三档语速自适应调节</li>
            </ul>
          </div>
          <div className="tech-col">
            <h3 className="tech-label">Web</h3>
            <ul className="tech-list">
              <li>React 19 + TypeScript</li>
              <li>Vite 构建工具链</li>
              <li>Lucide 图标系统</li>
              <li>ESLint 代码质量控制</li>
            </ul>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="cta">
        <h2 className="cta-title">准备好练就纯正口语了吗？</h2>
        <p className="cta-desc">在 Xcode 中打开工程，部署到 iPhone，立即开始你的英语发音之旅。</p>
        <div className="cta-actions">
          <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer" className="btn-primary btn-lg">
            <ExternalLink size={22} />
            前往 GitHub 获取源码
          </a>
        </div>
      </section>

      {/* Footer */}
      <footer className="footer">
        <div className="footer-inner">
          <div className="footer-brand">
            <img src={`${import.meta.env.BASE_URL}cat_1.png`} alt="" className="footer-logo" />
            <span className="footer-name">斯内克口语</span>
          </div>
          <div className="footer-links">
            <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer">GitHub</a>
            <a href="https://github.com/SSDWGG/svs/blob/main/README.md" target="_blank" rel="noopener noreferrer">文档</a>
            <a href="https://github.com/SSDWGG/svs" target="_blank" rel="noopener noreferrer">开源协议</a>
          </div>
        </div>
        <div className="footer-bottom">
          <p>斯内克口语 — 用 AI 学纯正英语发音</p>
        </div>
      </footer>
    </div>
  )
}
