# MobileAct17-Sample

Mobile Act #17 登壇資料のサンプルアプリケーションです。
このプロジェクトは、`@Query`マクロを利用しないSwiftDataの使い方の実装例を示します。

## 目次

- [背景と課題](#背景と課題)
- [このサンプルで学べること](#このサンプルで学べること)
- [技術スタック](#技術スタック)
- [レイヤーの責務](#レイヤーの責務)
- [プロジェクト構成](#プロジェクト構成)
- [ライセンス](#ライセンス)

## 背景と課題

SwiftDataの`@Query`マクロは便利ですが、以下の課題があります:

1. **テスタビリティの問題**
   - `@Query`マクロはSwiftUIのView内でしか使用できない
   - Viewのユニットテストが書きづらい
   - ビジネスロジックとUIが密結合してしまう

2. **パフォーマンスの懸念**
   - `@Query`はMainActorで動作する
   - データ量が増えるとUIのパフォーマンスに影響を与える可能性がある
   - UIスレッドでのデータ処理がボトルネックになりうる

## このサンプルで学べること

このサンプルアプリでは、2つの異なる実装方法を比較できます:

- **タブ1**: `@Query`マクロを使った従来の実装
- **タブ2**: `@Query`マクロを使わないテスタブルなアーキテクチャ

具体的に学べる内容:
- ModelActorを活用したSwiftDataのバックグラウンド処理
- fetch APIを使ったSwiftDataの手動fetch
- 各レイヤーの責務分離とテスト戦略

## 技術スタック

### 言語・フレームワーク

- **Swift**: 最新のSwift言語機能を活用
- **SwiftUI**: 宣言的UIフレームワーク
- **SwiftData**: Apple公式のデータ永続化フレームワーク

### 並行処理・状態管理

- **Swift Concurrency**: async/await、Actorによる安全な並行処理
- **Observation**: `@Observable`マクロによる状態管理

### テスト

- **Swift Testing**: Appleの新しいテストフレームワーク

### 動作環境

- iOS 26.0 以上
- Xcode 26.1.0 以上

## レイヤーの責務

### View
- **責務**: UIの構築のみ
- **特徴**: ViewModelから状態を受け取り、表示に専念
- **依存**: ViewModel

### ViewModel
- **責務**: Storeのプロパティを購読し、Viewに表示すべき状態を提供
- **特徴**: ビジネスロジックとUIを分離
- **依存**: Store (Protocol経由)

### Store
- **責務**: 永続化データの公開、状態の管理
- **特徴**:
  - `@Observable`で状態変更を通知
  - `@MainActor`で動作
  - Repositoryを使用してデータ取得
- **依存**: Repository (Protocol経由)

### Repository
- **責務**: SwiftDataの永続化処理、Entity ↔ Model の変換
- **特徴**:
  - SwiftDataClientを使用してバックグラウンドで処理
  - `Sendable`なEntityを返す
- **依存**: SwiftDataClient (Protocol経由)

### SwiftDataClient
- **責務**: バックグラウンドでのSwiftData CRUD操作
- **特徴**:
  - `ModelActor`に準拠
  - SwiftDataの永続化データのCRUD処理
- **依存**: SwiftData ModelContext

### Entity
- **責務**: Actor境界を超えられるデータ表現
- **特徴**:
  - `Sendable`に準拠したstruct
  - ModelとEntityの相互変換が可能
- **依存**: なし

## プロジェクト構成

```
MobileAct17-Sample/
├── App/
│   ├── MobileAct17-Sample.xcodeproj/ # Xcodeプロジェクトファイル
│   ├── MobileAct17-Sample/           # メインアプリケーション
│   │   ├── MobileAct17_SampleApp.swift  # エントリーポイント
│   │   ├── TodoModel.swift              # SwiftDataモデル定義
│   │   ├── Assets.xcassets/             # アセット
│   │   ├── WithMacro/                   # @Queryマクロ版の実装
│   │   │   └── ListWithQueryView.swift
│   │   └── WithoutMacro/                # @Queryマクロなし版の実装
│   │       ├── SwiftDataClient.swift           # ModelActor実装
│   │       ├── TodoRepository.swift            # Repository層
│   │       ├── TodoStore.swift                 # Store層(Observable)
│   │       ├── TodoEntity.swift                # Sendableエンティティ
│   │       ├── ListWithoutMacroViewModel.swift # ViewModel
│   │       ├── ListWithoutMacroView.swift      # View
│   │       └── Protocols/                      # プロトコル定義
│   │           ├── EntityProtocol.swift
│   │           ├── EntityConvertible.swift
│   │           ├── TodoRepositoryProtocol.swift
│   │           └── TodoStoreProtocol.swift
│   └── MobileAct17-SampleTests/       # ユニットテスト
│       ├── TodoRepositoryTests.swift
│       ├── TodoStoreTests.swift
│       └── ListWithoutMacroViewModelTests.swift
└── presentations/                     # 発表資料
```

## ライセンス

このリポジトリは、コンテンツの種類に応じて2つのライセンスを使用しています:

- **ソースコード** (`App/`ディレクトリ): [MIT License](LICENSE)
- **プレゼン資料** (`docs/`ディレクトリ): [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE)
- **ドキュメント** (README.md, CLAUDE.mdなど): [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE)

詳細は[LICENSE](LICENSE)ファイルをご覧ください。
