# Personal Configuration for Claude

## About Me

- **Name**: Keita
- **Role**: AI Coding Implementation Consultant / Hadron Corporation CEO
- **Languages**: Japanese (native), English (fluent) - 技術議論では両言語を自然に切り替える

## Communication Preferences

### Language
- 日本語で話しかけられたら日本語で返答
- English when addressed in English
- 技術用語は英語のままでOK（無理に訳さない）
- コードコメントは英語

### Response Style
- 簡潔で実用的な回答を好む
- 過度な説明や注意書きは不要
- 不確実な場合は正直に伝える
- 箇条書きより自然な文章を優先

## Autonomous Actions

### 確認なしで実行OK
- ファイル読み取り、検索（grep, find, ripgrep）
- lint / format の実行
- テストの実行
- git status, diff, log, branch
- git worktree add（新規作業開始時）
- パッケージ情報の確認（npm list, pip list）

### 必ず確認を求める
- ファイル削除（rm, del）
- git push, merge, rebase
- main / master ブランチへの操作全般
- 外部 API 呼び出し（課金発生の可能性）
- パッケージのインストール・アップデート
- 環境変数やシステム設定の変更
- 本番環境への操作

## Environment

- **OS**: Windows 11
- **Shell**: PowerShell (default) / WSL2 Ubuntu (Linux作業時)
- **Terminal**: Windows Terminal
- **Editor**: VSCode
- **Runtime**: Node.js v20.x / Python 3.11+
- **Timezone**: Asia/Tokyo (UTC+9)
- **Locale**: ja_JP.UTF-8

### Path Notes
- Windows パス: `C:\Users\...` 形式
- WSL パス: `/mnt/c/Users/...` で Windows にアクセス
- パス区切りは環境に応じて自動判断

## 開発環境

### 共通
- Docker Desktop 利用可能
- Docker Compose v2 利用可能
- Docker MCP Toolkit 有効（MCP_DOCKER サーバー経由）
- コードは ~/projects/ 配下に配置する

### WSL 固有（Windows 環境の場合）
- WSL 2 (Ubuntu) + Docker Desktop WSL 2 backend
- /mnt/c/ 配下にはコードを置かない（I/O パフォーマンス対策）
- .wslconfig で memory / processors を制限推奨

### Mac 固有
- Docker Desktop for Mac
- リソース制限は Docker Desktop の Settings > Resources で設定

## 開発ルール
- ローカルの DB やミドルウェアは Docker Compose で管理する
- docker-compose.yml はプロジェクトルートに置く
- Docker イメージの選定に迷ったら Docker MCP 経由で Docker Hub を検索する

## Technical Context

### Current Focus Areas
- Specification-Driven Development (SDD) ツールの評価・導入
- Claude Code の高度な活用（sub-agents, context engineering）
- MCP サーバー構成（Jira, Confluence, Google Workspace, Notion連携）
- エンタープライズ向けAIコーディングツール導入

### Tech Stack & Tools
- **AI Tools**: Claude Code, Claude Desktop, MCP servers
- **Development**: Python, TypeScript, Google Apps Script
- **Infrastructure**: AWS, FPGA (PYNQ-Z2)
- **Enterprise**: Jira, Confluence, Notion, Google Workspace
- **Business**: MoneyForward Cloud, Stripe

### Development Philosophy
- ローカルデータ処理を優先（セキュリティ重視）
- 自動化できるものは自動化する
- 仕様駆動開発（SDD）アプローチを推進
- マルチリポジトリのコンテキスト管理を重視

## Project Context

### Hadron Corporation
- AI エージェント開発・導入支援サービス
- 「Fusion Lead」サービス: AIエージェント開発のE2Eサポート
- コンテキストエンジニアリングを競争優位として注力

### Current Client Work
- 大規模エンタープライズ向けフェーズ検証プロジェクト（2026年3月完了予定）
- AI ツールの開発ワークフロー統合
- 要件定義への Claude 活用（要件ドキュメント → PBI 変換）

## Git Workflow

### Branch Protection
- **main / master ブランチへの直接編集は禁止**
- 開発・検証作業は必ず専用ブランチで行う

### Starting Development
作業開始時は `git worktree` を使用してブランチを分離する：

```bash
# 新規機能開発の場合
git worktree add ../project-feature-name -b feature/feature-name

# 検証・実験の場合
git worktree add ../project-experiment -b experiment/description

# 修正の場合
git worktree add ../project-fix-name -b fix/issue-description
```

### Branch Naming
- `feature/` - 新機能開発
- `fix/` - バグ修正
- `experiment/` - 検証・実験（マージ前提でない）
- `refactor/` - リファクタリング
- `docs/` - ドキュメント更新

### Workflow Rules
1. 作業開始前に現在のブランチを確認（`git branch --show-current`）
2. main/master にいる場合は worktree で作業ディレクトリを分離してから開始
3. 作業完了後は worktree を削除（`git worktree remove`）

## Coding Conventions

### General
- コミットメッセージ: Conventional Commits 形式
- ドキュメント: Markdown 形式
- 設定ファイル: YAML > JSON（可読性重視）

### When Writing Code
- 型安全性を重視
- エラーハンドリングは明示的に
- テスト: 単体テストを基本とする
- コメント: Why を説明、What は自明なコードで

## Don't

- 過度に丁寧な前置きや締めくくり
- 既知の情報の繰り返し説明
- 「〜かもしれません」の多用（確信度を明確に）
- セキュリティ警告の過剰な繰り返し

## Notes

- Windows 環境をメインで使用
- 日本語/英語キーボード入力の切り替え可視化に関心あり
- 検索技術（Vespa, Elasticsearch）の知識あり
