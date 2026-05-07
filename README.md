# 橙子口语 (OrangeSpeaking)

一款基于 AI 语音技术的英语口语学习应用，帮你系统掌握标准的英语发音。

## 核心功能

### 📱 双端学习体验

- **iOS 原生 App**（主力）：基于 SwiftUI 构建，支持真机运行，提供流畅的移动端学习体验
- **Web 预览版**（备用）：React + Vite 构建，可在浏览器中访问全部课程内容

### 🗣️ 系统化音标课程

覆盖完整的 48 个英语国际音标体系：

- **元音（20 个）**：短元音与长元音对比训练，帮���掌握嘴型与舌位
- **辅音（28 个）**：清浊音、送气对比，区分易混淆辅音
- **单词训练**：重音与节奏练习，从单音过渡到完整词汇
- **句子训练**：连读、弱读、语调等语流技巧

每个音标课程包含：标准发音示范、口型提示、易混音对比、例词跟读训练。

### 🎙️ AI 语音识别

- 使用 Apple `Speech` 框架实现跟读识别与反馈
- 实时比对发音准确度，提供改进建议

### 🔊 火山引擎 TTS 集成

- 通过火山引擎（字节跳动）TTS 服务生成高质量英语发音
- Node.js 后端代理调用，Token 仅存储在服务端，确保安全
- 默认音色 `BV503_streaming`，支持语速调节

### 🧩 iPhone 桌面小组件

- 每天在主屏幕轮换展示一个基础音标课程
- 点击小组件直接跳转到当天练习内容

### 📝 学习进度追踪

- 每节课程支持「标记已学 / 取消已学」
- 学习状态保存在本机，课程卡片实时显示学习进度
- 清晰的「已学 / 未学」状态区分

## 技术栈

| 层级 | 技术 |
|------|------|
| iOS App | SwiftUI, AVFoundation, Apple Speech |
| iOS 小组件 | WidgetKit, AppGroup UserDefaults |
| Web 前端 | React 19, TypeScript, Vite, Lucide Icons |
| 后端 API | Node.js, Express 5, tsx |
| TTS 服务 | 火山引擎 OpenSpeech API |
| 代码质量 | ESLint, TypeScript 严格模式 |

## 快速开始

### 环境要求

- Node.js >= 18
- macOS + Xcode（iOS 开发）
- 火山引擎 TTS 账号

### 安装运行

```bash
npm install
cp .env.example .env
# 编辑 .env 填入火山引擎配置
npm run dev
```

Web 预览将在 `http://localhost:5173` 启动，TTS API 在 `http://localhost:5174`。

### iOS 真机运行

```bash
npm run ios:open
```

在 Xcode 中选择 iPhone 设备，设置签名和 Bundle Identifier，点击 Run。

> 真机连接 TTS 服务时，需在 App 设置中将 `http://localhost:5174` 改为 Mac 的局域网 IP 地址。

## 环境变量

在 `.env` 中配置火山引擎 TTS：

```bash
VOLCENGINE_TTS_APP_ID=your_app_id
VOLCENGINE_TTS_ACCESS_TOKEN=your_access_token
VOLCENGINE_TTS_CLUSTER_ID=volcano_tts
VOLCENGINE_TTS_VOICE_TYPE=BV503_streaming
VOLCENGINE_TTS_URL=https://openspeech.bytedance.com/api/v1/tts
```

## 项目结构

```text
ios/OrangeSpeaking/         原生 SwiftUI iOS App
ios/OrangeSpeakingWidget/   桌面小组件
server/                     火山引擎 TTS 代理服务
src/                        Web 预览版
public/                     静态资源
```

## 可用脚本

```bash
npm run dev         # 同时启动 Vite 前端 + TTS API
npm run dev:web     # 仅启动 Vite 前端
npm run dev:api     # 仅启动 TTS API
npm run build       # 构建 Web 生产版本
npm run preview     # 预览构建结果
npm run ios:open    # 打开 Xcode 工程
npm run ios:build   # 命令行构建 iOS Simulator
npm run lint        # ESLint 检查
```
