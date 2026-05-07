import Foundation

enum LessonStage: String, CaseIterable, Identifiable {
    case vowels
    case ipa
    case words
    case sentences

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vowels: "元音"
        case .ipa: "辅音"
        case .words: "单词"
        case .sentences: "句子"
        }
    }

    var subtitle: String {
        switch self {
        case .vowels: "短长对比"
        case .ipa: "清浊送气"
        case .words: "重音节奏"
        case .sentences: "连读语调"
        }
    }

    var symbol: String {
        switch self {
        case .vowels: "ear"
        case .ipa: "textformat.abc"
        case .words: "book"
        case .sentences: "quote.bubble"
        }
    }
}

struct Lesson: Identifiable, Hashable {
    let id: String
    let stage: LessonStage
    let title: String
    let target: String
    let ipa: String
    let category: String
    let focus: String
    let mouthCue: String
    let contrast: String
    let examples: [String]
    let practiceText: String
}

extension Lesson {
    static let curriculum: [Lesson] = [
        Lesson(
            id: "vowel-i",
            stage: .vowels,
            title: "长元音 /iː/",
            target: "sheep",
            ipa: "/ʃiːp/",
            category: "前高不圆唇元音",
            focus: "舌位靠前靠高，嘴角轻微向两侧拉开，声音拉长。",
            mouthCue: "想像微笑时发“衣”，下巴不要大幅下沉。",
            contrast: "ship /ʃɪp/，长短会改变词义。",
            examples: ["green", "teacher", "please"],
            practiceText: "sheep"
        ),
        Lesson(
            id: "vowel-ih",
            stage: .vowels,
            title: "短元音 /ɪ/",
            target: "ship",
            ipa: "/ʃɪp/",
            category: "前高偏央元音",
            focus: "发音更短、更松，嘴角不需要明显拉开。",
            mouthCue: "舌尖轻触下齿后方，声音收住，不拖长。",
            contrast: "sheep /ʃiːp/，不要把 /ɪ/ 发成中文“衣”。",
            examples: ["sit", "city", "minute"],
            practiceText: "ship"
        ),
        Lesson(
            id: "vowel-e",
            stage: .vowels,
            title: "短元音 /e/",
            target: "bed",
            ipa: "/bed/",
            category: "前中元音",
            focus: "舌位在 /ɪ/ 和 /æ/ 中间，声音短促清楚。",
            mouthCue: "嘴唇自然打开，像轻轻说“诶”，不要拖成长音。",
            contrast: "bad /bæd/ 嘴巴更大；bid /bɪd/ 舌位更高。",
            examples: ["red", "head", "many"],
            practiceText: "bed"
        ),
        Lesson(
            id: "vowel-ae",
            stage: .vowels,
            title: "梅花音 /æ/",
            target: "cat",
            ipa: "/kæt/",
            category: "前低元音",
            focus: "嘴巴打开，舌前部放低，声音明亮而扁。",
            mouthCue: "先张口发“啊”，再把嘴角向两侧打开。",
            contrast: "cut /kʌt/，/æ/ 更前、更亮。",
            examples: ["apple", "family", "happy"],
            practiceText: "cat"
        ),
        Lesson(
            id: "vowel-er",
            stage: .vowels,
            title: "卷舌元音 /ɜː(ɝ)/",
            target: "bird",
            ipa: "/bɝːd/",
            category: "中元音带 r 色彩",
            focus: "英式常标 /ɜː/，美式常带 r 色彩 /ɝ/。",
            mouthCue: "舌头向后收并微卷，嘴唇放松，不要加中文“儿”的完整音节。",
            contrast: "bed /bed/ 不卷舌；bird /bɝːd/ 中间持续带 r 色彩。",
            examples: ["word", "nurse", "learn"],
            practiceText: "bird"
        ),
        Lesson(
            id: "vowel-schwa",
            stage: .vowels,
            title: "弱读 /ə/",
            target: "about",
            ipa: "/əˈbaʊt/",
            category: "中央元音",
            focus: "最放松、最短促的元音，常出现在非重读音节。",
            mouthCue: "下巴自然放松，轻轻带过，不抢重音。",
            contrast: "a- in about 弱读，bout 才是主要重音。",
            examples: ["again", "banana", "teacher"],
            practiceText: "about"
        ),
        Lesson(
            id: "vowel-uh",
            stage: .vowels,
            title: "短元音 /ʌ/",
            target: "cup",
            ipa: "/kʌp/",
            category: "中低央元音",
            focus: "声音短、口腔放松，比中文“啊”更靠中间。",
            mouthCue: "下巴稍微打开，舌头放中间，不要读成 /æ/。",
            contrast: "cap /kæp/ 更亮更前；cup /kʌp/ 更短更松。",
            examples: ["sun", "love", "money"],
            practiceText: "cup"
        ),
        Lesson(
            id: "vowel-aa",
            stage: .vowels,
            title: "长元音 /ɑː/",
            target: "father",
            ipa: "/ˈfɑːðər/",
            category: "后低元音",
            focus: "口腔打开，舌位靠后，声音饱满拉长。",
            mouthCue: "像张口发“啊”，但舌头更靠后，喉咙保持打开。",
            contrast: "fan /fæn/ 更前更扁；father /ˈfɑːðər/ 更后更开。",
            examples: ["car", "start", "calm"],
            practiceText: "father"
        ),
        Lesson(
            id: "vowel-ɒ",
            stage: .vowels,
            title: "短元音 /ɒ/",
            target: "hot",
            ipa: "/hɒt/",
            category: "英式后低圆唇元音",
            focus: "英式 /ɒ/ 嘴唇略圆；美式常并入 /ɑː/。",
            mouthCue: "嘴巴打开并略圆，不要读成 /ʌ/。",
            contrast: "hut /hʌt/ 更央更短；hot 在英式里更圆。",
            examples: ["lot", "clock", "orange"],
            practiceText: "hot"
        ),
        Lesson(
            id: "vowel-aw",
            stage: .vowels,
            title: "长元音 /ɔː/",
            target: "law",
            ipa: "/lɔː/",
            category: "后中圆唇元音",
            focus: "嘴唇收圆，舌位靠后，声音拉长。",
            mouthCue: "保持圆唇，不要把下巴放得过低。",
            contrast: "low /loʊ/ 有滑动；law /lɔː/ 更稳定。",
            examples: ["saw", "talk", "thought"],
            practiceText: "law"
        ),
        Lesson(
            id: "vowel-u-short",
            stage: .vowels,
            title: "短元音 /ʊ/",
            target: "book",
            ipa: "/bʊk/",
            category: "后高偏央圆唇元音",
            focus: "嘴唇轻圆，声音短，不要拉成长 /uː/。",
            mouthCue: "舌头后缩但保持放松，嘴唇不要过度撅起。",
            contrast: "Luke /luːk/ 更长更紧；look /lʊk/ 更短更松。",
            examples: ["good", "put", "could"],
            practiceText: "book"
        ),
        Lesson(
            id: "vowel-u-long",
            stage: .vowels,
            title: "长元音 /uː/",
            target: "food",
            ipa: "/fuːd/",
            category: "后高圆唇元音",
            focus: "嘴唇收圆，舌位靠后靠高，声音拉长。",
            mouthCue: "像发“呜”，但保持英语口腔空间，不要太紧。",
            contrast: "foot /fʊt/ 短而松；food /fuːd/ 长而稳。",
            examples: ["blue", "school", "move"],
            practiceText: "food"
        ),
        Lesson(
            id: "vowel-ei",
            stage: .vowels,
            title: "双元音 /eɪ/",
            target: "day",
            ipa: "/deɪ/",
            category: "合口双元音",
            focus: "从 /e/ 滑向 /ɪ/，不是单一中文“诶”。",
            mouthCue: "开头稍开，结尾嘴角轻微收紧，滑动要自然。",
            contrast: "bed /bed/ 不滑动；day /deɪ/ 有明显收尾。",
            examples: ["name", "great", "say"],
            practiceText: "day"
        ),
        Lesson(
            id: "vowel-ai",
            stage: .vowels,
            title: "双元音 /aɪ/",
            target: "my",
            ipa: "/maɪ/",
            category: "开合双元音",
            focus: "从开口 /a/ 滑向 /ɪ/，重心在开头。",
            mouthCue: "先把下巴打开，再向前上方收住。",
            contrast: "me /miː/ 是长单元音；my /maɪ/ 有滑动。",
            examples: ["time", "light", "price"],
            practiceText: "my"
        ),
        Lesson(
            id: "vowel-oi",
            stage: .vowels,
            title: "双元音 /ɔɪ/",
            target: "boy",
            ipa: "/bɔɪ/",
            category: "圆唇到前高滑动",
            focus: "从圆唇 /ɔ/ 滑向 /ɪ/，结尾轻收。",
            mouthCue: "先圆唇，再把嘴角向两侧轻收。",
            contrast: "bore /bɔr/ 带 r；boy /bɔɪ/ 结尾是 /ɪ/。",
            examples: ["toy", "voice", "choice"],
            practiceText: "boy"
        ),
        Lesson(
            id: "vowel-ou",
            stage: .vowels,
            title: "双元音 /əʊ(oʊ)/",
            target: "go",
            ipa: "/ɡoʊ/",
            category: "英美差异双元音",
            focus: "英式常标 /əʊ/，美式常标 /oʊ/，都需要滑动收尾。",
            mouthCue: "从较开放的后元音滑向圆唇 /ʊ/，不要读成单一“欧”。",
            contrast: "law /lɔː/ 不滑动；low /loʊ/ 有收圆滑动。",
            examples: ["home", "phone", "orange"],
            practiceText: "go"
        ),
        Lesson(
            id: "vowel-au",
            stage: .vowels,
            title: "双元音 /aʊ/",
            target: "now",
            ipa: "/naʊ/",
            category: "开口到圆唇滑动",
            focus: "从大开口 /a/ 滑向 /ʊ/，结尾嘴唇收圆。",
            mouthCue: "先打开下巴，再向圆唇收住。",
            contrast: "no /noʊ/ 开口较小；now /naʊ/ 开头更开。",
            examples: ["house", "mouth", "around"],
            practiceText: "now"
        ),
        Lesson(
            id: "vowel-ear",
            stage: .vowels,
            title: "集中双元音 /ɪə/",
            target: "near",
            ipa: "/nɪə/",
            category: "向中央滑动元音",
            focus: "从 /ɪ/ 向 /ə/ 滑动；美式常受 r 影响变为 /nɪr/。",
            mouthCue: "开头短促清楚，结尾放松变轻。",
            contrast: "knee /niː/ 不回到中央；near 有轻微回收。",
            examples: ["ear", "clear", "idea"],
            practiceText: "near"
        ),
        Lesson(
            id: "vowel-air",
            stage: .vowels,
            title: "集中双元音 /eə/",
            target: "hair",
            ipa: "/heə/",
            category: "向中央滑动元音",
            focus: "从 /e/ 向 /ə/ 滑动；美式常读作 /her/。",
            mouthCue: "嘴巴中等打开，结尾放松，不要加中文“呀”。",
            contrast: "head /hed/ 不滑动；hair 有回收或 r 色彩。",
            examples: ["there", "care", "parent"],
            practiceText: "hair"
        ),
        Lesson(
            id: "vowel-ure",
            stage: .vowels,
            title: "集中双元音 /ʊə/",
            target: "pure",
            ipa: "/pjʊə/",
            category: "向中央滑动元音",
            focus: "从 /ʊ/ 向 /ə/ 滑动；现代口音中常与 /ɔː/ 或 r 色彩合流。",
            mouthCue: "先轻圆唇，再放松回到中央。",
            contrast: "poor 在不同口音中可能是 /pʊə/ 或 /pɔːr/。",
            examples: ["tour", "cure", "sure"],
            practiceText: "pure"
        ),
        Lesson(
            id: "ipa-p",
            stage: .ipa,
            title: "清爆破音 /p/",
            target: "pen",
            ipa: "/pen/",
            category: "双唇清爆破音",
            focus: "双唇闭合后突然放气，开头通常有送气。",
            mouthCue: "手放嘴前能感觉气流，声带不震动。",
            contrast: "ben /ben/ 是浊音，声带震动。",
            examples: ["paper", "happy", "stop"],
            practiceText: "pen"
        ),
        Lesson(
            id: "ipa-b",
            stage: .ipa,
            title: "浊爆破音 /b/",
            target: "bed",
            ipa: "/bed/",
            category: "双唇浊爆破音",
            focus: "双唇闭合后打开，声带震动。",
            mouthCue: "手摸喉咙能感到震动，气流比 /p/ 弱。",
            contrast: "pet /pet/ 是清音，bed /bed/ 是浊音。",
            examples: ["baby", "about", "job"],
            practiceText: "bed"
        ),
        Lesson(
            id: "ipa-t",
            stage: .ipa,
            title: "清爆破音 /t/",
            target: "tea",
            ipa: "/tiː/",
            category: "齿龈清爆破音",
            focus: "舌尖抵住上齿龈后放开，词首通常送气。",
            mouthCue: "不要读成中文 d，开头要有清晰气流。",
            contrast: "day /deɪ/ 声带震动；tea /tiː/ 不震动。",
            examples: ["time", "water", "cat"],
            practiceText: "tea"
        ),
        Lesson(
            id: "ipa-d",
            stage: .ipa,
            title: "浊爆破音 /d/",
            target: "day",
            ipa: "/deɪ/",
            category: "齿龈浊爆破音",
            focus: "舌尖抵住上齿龈后放开，声带震动。",
            mouthCue: "气流较弱，声音从喉部带出。",
            contrast: "tie /taɪ/ 是清音；die /daɪ/ 是浊音。",
            examples: ["door", "ready", "good"],
            practiceText: "day"
        ),
        Lesson(
            id: "ipa-k",
            stage: .ipa,
            title: "清爆破音 /k/",
            target: "key",
            ipa: "/kiː/",
            category: "软腭清爆破音",
            focus: "舌后部抵住软腭后放开，词首送气明显。",
            mouthCue: "声音从口腔后部弹出，不要加元音。",
            contrast: "go /ɡoʊ/ 声带震动；key /kiː/ 不震动。",
            examples: ["cat", "school", "back"],
            practiceText: "key"
        ),
        Lesson(
            id: "ipa-g",
            stage: .ipa,
            title: "浊爆破音 /ɡ/",
            target: "go",
            ipa: "/ɡoʊ/",
            category: "软腭浊爆破音",
            focus: "舌后部抵住软腭后放开，声带震动。",
            mouthCue: "口腔后部发力，气流不要像 /k/ 那么强。",
            contrast: "coat /koʊt/ 清；goat /ɡoʊt/ 浊。",
            examples: ["good", "again", "bag"],
            practiceText: "go"
        ),
        Lesson(
            id: "ipa-f",
            stage: .ipa,
            title: "清摩擦音 /f/",
            target: "fish",
            ipa: "/fɪʃ/",
            category: "唇齿清摩擦音",
            focus: "上齿轻碰下唇，气流摩擦通过。",
            mouthCue: "不要咬紧下唇，声带不震动。",
            contrast: "very /ˈveri/ 是 /v/，声带震动。",
            examples: ["five", "coffee", "laugh"],
            practiceText: "fish"
        ),
        Lesson(
            id: "ipa-v",
            stage: .ipa,
            title: "浊摩擦音 /v/",
            target: "very",
            ipa: "/ˈveri/",
            category: "唇齿浊摩擦音",
            focus: "上齿轻碰下唇，同时声带震动。",
            mouthCue: "保持持续摩擦，不要发成 /w/。",
            contrast: "fan /fæn/ 不震动；van /væn/ 震动。",
            examples: ["voice", "never", "love"],
            practiceText: "very"
        ),
        Lesson(
            id: "ipa-th-voiceless",
            stage: .ipa,
            title: "清辅音 /θ/",
            target: "think",
            ipa: "/θɪŋk/",
            category: "齿间摩擦音",
            focus: "舌尖轻放在上下齿之间，气流从舌齿缝隙通过。",
            mouthCue: "不要咬紧舌头，也不要发成 /s/ 或 /f/。",
            contrast: "sink /sɪŋk/，舌头位置不同。",
            examples: ["three", "thank", "healthy"],
            practiceText: "think"
        ),
        Lesson(
            id: "ipa-th-voiced",
            stage: .ipa,
            title: "浊辅音 /ð/",
            target: "this",
            ipa: "/ðɪs/",
            category: "齿间浊摩擦音",
            focus: "舌位和 /θ/ 相同，但声带震动。",
            mouthCue: "手指触摸喉咙，能感觉到轻微震动。",
            contrast: "this /ðɪs/ 与 thin /θɪn/，一个震动，一个不震动。",
            examples: ["that", "mother", "breathe"],
            practiceText: "this"
        ),
        Lesson(
            id: "ipa-s",
            stage: .ipa,
            title: "清摩擦音 /s/",
            target: "see",
            ipa: "/siː/",
            category: "齿龈清摩擦音",
            focus: "舌尖靠近齿龈，气流从窄缝持续通过。",
            mouthCue: "声带不震动，气流细而稳定。",
            contrast: "zoo /zuː/ 是浊音；see /siː/ 是清音。",
            examples: ["sun", "city", "bus"],
            practiceText: "see"
        ),
        Lesson(
            id: "ipa-z",
            stage: .ipa,
            title: "浊摩擦音 /z/",
            target: "zoo",
            ipa: "/zuː/",
            category: "齿龈浊摩擦音",
            focus: "舌位和 /s/ 接近，但声带震动。",
            mouthCue: "保持嗡嗡的震动，不要发成清音 /s/。",
            contrast: "sip /sɪp/ 清；zip /zɪp/ 浊。",
            examples: ["zero", "busy", "dogs"],
            practiceText: "zoo"
        ),
        Lesson(
            id: "ipa-sh",
            stage: .ipa,
            title: "清摩擦音 /ʃ/",
            target: "she",
            ipa: "/ʃiː/",
            category: "后齿龈清摩擦音",
            focus: "舌面靠近硬腭前部，嘴唇略圆，气流持续。",
            mouthCue: "像提醒别人安静的 sh，声带不震动。",
            contrast: "see /siː/ 舌位更前；she /ʃiː/ 舌位更后。",
            examples: ["shoe", "English", "wash"],
            practiceText: "she"
        ),
        Lesson(
            id: "ipa-zh",
            stage: .ipa,
            title: "浊摩擦音 /ʒ/",
            target: "measure",
            ipa: "/ˈmeʒər/",
            category: "后齿龈浊摩擦音",
            focus: "舌位接近 /ʃ/，但声带震动。",
            mouthCue: "声音持续，不要发成 /dʒ/ 的爆破。",
            contrast: "mesh /meʃ/ 清；measure /ˈmeʒər/ 浊。",
            examples: ["vision", "usually", "garage"],
            practiceText: "measure"
        ),
        Lesson(
            id: "ipa-h",
            stage: .ipa,
            title: "清擦音 /h/",
            target: "he",
            ipa: "/hiː/",
            category: "声门清擦音",
            focus: "从喉部送出轻气流，口型由后面元音决定。",
            mouthCue: "不要太用力，也不要漏掉词首 h。",
            contrast: "eat /iːt/ 无 h；heat /hiːt/ 有轻气流。",
            examples: ["hello", "behind", "house"],
            practiceText: "he"
        ),
        Lesson(
            id: "ipa-ch",
            stage: .ipa,
            title: "清塞擦音 /tʃ/",
            target: "cheese",
            ipa: "/tʃiːz/",
            category: "后齿龈清塞擦音",
            focus: "先短暂阻塞，再释放成 /ʃ/ 式摩擦。",
            mouthCue: "不要拖成单纯 /ʃ/，开头要有轻爆破。",
            contrast: "she /ʃiː/ 无爆破；cheese /tʃiːz/ 有爆破。",
            examples: ["chair", "teacher", "watch"],
            practiceText: "cheese"
        ),
        Lesson(
            id: "ipa-j",
            stage: .ipa,
            title: "浊塞擦音 /dʒ/",
            target: "juice",
            ipa: "/dʒuːs/",
            category: "后齿龈浊塞擦音",
            focus: "先阻塞再摩擦，同时声带震动。",
            mouthCue: "不要读成 /ʒ/，开头要有轻微爆破。",
            contrast: "yam /jæm/ 是半元音；jam /dʒæm/ 是塞擦音。",
            examples: ["job", "orange", "large"],
            practiceText: "juice"
        ),
        Lesson(
            id: "ipa-tr",
            stage: .ipa,
            title: "辅音连缀 /tr/",
            target: "tree",
            ipa: "/triː/",
            category: "清辅音连缀",
            focus: "/t/ 后接 /r/，常带一点 /tʃ/ 色彩但不能丢掉 r。",
            mouthCue: "舌尖先触齿龈，再快速转入卷舌 /r/。",
            contrast: "tea /tiː/ 没有 r；tree /triː/ 有 r 色彩。",
            examples: ["train", "try", "street"],
            practiceText: "tree"
        ),
        Lesson(
            id: "ipa-dr",
            stage: .ipa,
            title: "辅音连缀 /dr/",
            target: "dream",
            ipa: "/driːm/",
            category: "浊辅音连缀",
            focus: "/d/ 后接 /r/，常带一点 /dʒ/ 色彩但保持 r。",
            mouthCue: "声带震动，舌尖释放后马上卷向 /r/。",
            contrast: "deem /diːm/ 没有 r；dream /driːm/ 有 r。",
            examples: ["drive", "dry", "address"],
            practiceText: "dream"
        ),
        Lesson(
            id: "ipa-ts",
            stage: .ipa,
            title: "辅音连缀 /ts/",
            target: "cats",
            ipa: "/kæts/",
            category: "词尾清辅音连缀",
            focus: "/t/ 释放后接 /s/，常见于复数或第三人称词尾。",
            mouthCue: "结尾要收干净，不要加额外元音。",
            contrast: "cat /kæt/ 少了 /s/；cats /kæts/ 有清晰 /ts/。",
            examples: ["gets", "what's", "students"],
            practiceText: "cats"
        ),
        Lesson(
            id: "ipa-dz",
            stage: .ipa,
            title: "辅音连缀 /dz/",
            target: "cards",
            ipa: "/kɑːrdz/",
            category: "词尾浊辅音连缀",
            focus: "/d/ 后接 /z/，声带保持震动。",
            mouthCue: "结尾短促收住，不要读成 /dəs/。",
            contrast: "card /kɑːrd/ 少了 /z/；cards /kɑːrdz/ 有 /dz/。",
            examples: ["needs", "friends", "words"],
            practiceText: "cards"
        ),
        Lesson(
            id: "ipa-m",
            stage: .ipa,
            title: "鼻音 /m/",
            target: "man",
            ipa: "/mæn/",
            category: "双唇鼻音",
            focus: "双唇闭合，气流从鼻腔通过，声带震动。",
            mouthCue: "闭嘴也能持续发声，鼻腔有震动。",
            contrast: "ban /bæn/ 是爆破；man /mæn/ 是鼻音。",
            examples: ["mother", "summer", "room"],
            practiceText: "man"
        ),
        Lesson(
            id: "ipa-n",
            stage: .ipa,
            title: "鼻音 /n/",
            target: "no",
            ipa: "/noʊ/",
            category: "齿龈鼻音",
            focus: "舌尖抵住上齿龈，气流从鼻腔通过。",
            mouthCue: "舌尖位置像 /t/，但保持鼻腔发声。",
            contrast: "do /duː/ 是爆破；no /noʊ/ 是鼻音。",
            examples: ["name", "dinner", "green"],
            practiceText: "no"
        ),
        Lesson(
            id: "ipa-ng",
            stage: .ipa,
            title: "鼻音 /ŋ/",
            target: "sing",
            ipa: "/sɪŋ/",
            category: "软腭鼻音",
            focus: "舌后部抬起贴近软腭，气流从鼻腔通过。",
            mouthCue: "不要在词尾额外加 /ɡ/，sing 不是 sing-guh。",
            contrast: "sin /sɪn/ 舌尖鼻音；sing /sɪŋ/ 舌后鼻音。",
            examples: ["English", "long", "thinking"],
            practiceText: "sing"
        ),
        Lesson(
            id: "ipa-r",
            stage: .ipa,
            title: "卷舌近音 /r/",
            target: "red",
            ipa: "/red/",
            category: "英语 r 音",
            focus: "舌尖向上卷但不接触上颚，嘴唇可轻微收圆。",
            mouthCue: "保持口腔中间有空间，不要发成中文“日”。",
            contrast: "red /red/ 与 led /led/，舌尖不要贴住齿龈。",
            examples: ["right", "around", "story"],
            practiceText: "red"
        ),
        Lesson(
            id: "ipa-l",
            stage: .ipa,
            title: "清晰 /l/",
            target: "light",
            ipa: "/laɪt/",
            category: "舌侧音",
            focus: "舌尖贴住上齿龈，气流从舌头两侧通过。",
            mouthCue: "开头的 /l/ 要清晰弹出，结尾 dark l 更沉。",
            contrast: "light /laɪt/ 与 right /raɪt/，舌尖是否接触是关键。",
            examples: ["love", "clear", "little"],
            practiceText: "light"
        ),
        Lesson(
            id: "ipa-y",
            stage: .ipa,
            title: "半元音 /j/",
            target: "yes",
            ipa: "/jes/",
            category: "硬腭近音",
            focus: "舌面靠近硬腭，快速滑入后面的元音。",
            mouthCue: "像 very short 的“衣”开头，不要发成 /dʒ/。",
            contrast: "jam /dʒæm/ 有爆破；yam /jæm/ 是滑音。",
            examples: ["you", "young", "use"],
            practiceText: "yes"
        ),
        Lesson(
            id: "ipa-w",
            stage: .ipa,
            title: "半元音 /w/",
            target: "we",
            ipa: "/wiː/",
            category: "双唇软腭近音",
            focus: "双唇收圆，同时舌后部抬起，再滑入元音。",
            mouthCue: "先圆唇再打开，不要发成 /v/。",
            contrast: "vine /vaɪn/ 是唇齿音；wine /waɪn/ 是圆唇滑音。",
            examples: ["water", "away", "quick"],
            practiceText: "we"
        ),
        Lesson(
            id: "word-orange",
            stage: .words,
            title: "orange",
            target: "orange",
            ipa: "/ˈɔːrɪndʒ/",
            category: "双音节名词",
            focus: "第一音节重读，第二音节轻收。",
            mouthCue: "or 保持圆唇开口，-ange 轻而短。",
            contrast: "不要读成三个等长音节。",
            examples: ["orange juice", "an orange", "orange peel"],
            practiceText: "orange"
        ),
        Lesson(
            id: "word-pronunciation",
            stage: .words,
            title: "pronunciation",
            target: "pronunciation",
            ipa: "/prəˌnʌnsiˈeɪʃən/",
            category: "多音节重音",
            focus: "主重音在 -a- /eɪ/，前面音节有弱读。",
            mouthCue: "把 pro- 和 -nun- 放轻，最后 -ation 打开。",
            contrast: "名词 pronunciation 没有 pronounce 里的 /aʊ/。",
            examples: ["clear pronunciation", "English pronunciation", "check pronunciation"],
            practiceText: "pronunciation"
        ),
        Lesson(
            id: "word-comfortable",
            stage: .words,
            title: "comfortable",
            target: "comfortable",
            ipa: "/ˈkʌmftəbəl/",
            category: "弱读与省音",
            focus: "常见自然读法是三音节，fort 部分轻收。",
            mouthCue: "重音放在 com-，中间不要逐字母读。",
            contrast: "不要读成 com-for-ta-ble 四个等长音节。",
            examples: ["comfortable chair", "feel comfortable", "comfortable shoes"],
            practiceText: "comfortable"
        ),
        Lesson(
            id: "word-world",
            stage: .words,
            title: "world",
            target: "world",
            ipa: "/wɝːld/",
            category: "r-colored vowel",
            focus: "先圆唇 /w/，中间保持 r 色彩，再收 /ld/。",
            mouthCue: "不要在 r 和 l 中间加中文式元音。",
            contrast: "word /wɝːd/ 少了结尾 /l/。",
            examples: ["world map", "around the world", "real world"],
            practiceText: "world"
        ),
        Lesson(
            id: "sentence-coffee",
            stage: .sentences,
            title: "I would like a cup of coffee.",
            target: "I would like a cup of coffee.",
            ipa: "/aɪ wəd laɪk ə kʌp əv ˈkɔːfi/",
            category: "点单句",
            focus: "would 弱读为 /wəd/，a 和 of 都要轻。",
            mouthCue: "重音落在 like、cup、coffee，句尾自然下降。",
            contrast: "不要把每个词都读成同样重。",
            examples: ["I would like a glass of water.", "I would like a ticket.", "I would like a receipt."],
            practiceText: "I would like a cup of coffee."
        ),
        Lesson(
            id: "sentence-meet",
            stage: .sentences,
            title: "Nice to meet you.",
            target: "Nice to meet you.",
            ipa: "/naɪs tə miːtʃuː/",
            category: "连读",
            focus: "meet you 自然连成 /miːtʃuː/。",
            mouthCue: "to 弱读，meet 的 /t/ 和 you 的 /j/ 合成 /tʃ/。",
            contrast: "不要逐词停顿成 nice | to | meet | you。",
            examples: ["Great to meet you.", "Pleased to meet you.", "Good to see you."],
            practiceText: "Nice to meet you."
        ),
        Lesson(
            id: "sentence-think",
            stage: .sentences,
            title: "I think this is useful.",
            target: "I think this is useful.",
            ipa: "/aɪ θɪŋk ðɪs ɪz ˈjuːsfəl/",
            category: "齿间音组合",
            focus: "think 用 /θ/，this 用 /ð/，清浊对比明确。",
            mouthCue: "两个 th 都把舌尖轻放齿间，第二个要震动。",
            contrast: "不要读成 I sink zis is useful。",
            examples: ["I think this is clear.", "I think this is right.", "I think this is enough."],
            practiceText: "I think this is useful."
        ),
        Lesson(
            id: "sentence-work",
            stage: .sentences,
            title: "Could you send it later?",
            target: "Could you send it later?",
            ipa: "/kədʒuː send ɪt ˈleɪtər/",
            category: "弱读与连读",
            focus: "Could you 常连成 /kədʒuː/，later 保持重音清楚。",
            mouthCue: "Could 弱读，you 不要拖长，later 的 /eɪ/ 打开。",
            contrast: "不要把 could 读得过重。",
            examples: ["Could you check it later?", "Could you call me later?", "Could you send the file?"],
            practiceText: "Could you send it later?"
        )
    ]
}
