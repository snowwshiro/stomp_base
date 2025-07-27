# 🎛️ Stomp Base

[en README](./README.md)

[![CI](https://github.com/snowwshiro/stomp_base/workflows/CI/badge.svg)](https://github.com/snowwshiro/stomp_base/actions/workflows/ci.yml)
[![Code Quality](https://github.com/snowwshiro/stomp_base/workflows/Code%20Quality/badge.svg)](https://github.com/snowwshiro/stomp_base/actions/workflows/code-quality.yml)
[![Coverage](https://github.com/snowwshiro/stomp_base/workflows/Coverage/badge.svg)](https://github.com/snowwshiro/stomp_base/actions/workflows/coverage.yml)
[![Gem Version](https://badge.fury.io/rb/stomp_base.svg)](https://badge.fury.io/rb/stomp_base)
[![Documentation](https://img.shields.io/badge/docs-yard-blue.svg)](https://snowwshiro.github.io/stomp_base/docs)

Railsアプリケーション向けの美しいコンポーネントベース管理インターフェースとRailsコンソールを提供するモダンなRailsエンジンです。

## 名前の由来

「stomp_base」という名前は、スノーボード用語の「stomp」に由来しています。stompは完璧な着地を意味し、ジャンプやトリックの後の完璧で安定したタッチダウンを表します。スノーボードでの完璧なstompが完全なコントロールと成功した実行を表すように、このgemはRailsプロジェクトの完全な実行のための堅実な基盤と完璧なサポートを提供することを目指しています。

## 機能

- 📊 **ダッシュボード**: リアルタイムRailsアプリケーション統計とシステム情報
- 💻 **ブラウザコンソール**: セキュリティが強化されたRails環境で直接Rubyコードを実行
- 🎨 **モダンUI**: レスポンシブで美しいインターフェースのためのView Componentsを使用
- 🔧 **コンポーネントベース**: 簡単なカスタマイズと拡張のためのモジュラーView Components
- 📖 **Lookbook統合**: Lookbookによるコンポーネント開発とドキュメント化
- 🌐 **多言語サポート**: 英語と日本語のインターフェース
- 🔧 **簡単統合**: シンプルなgem インストールとマウントプロセス
- 🔐 **組み込み認証**: シンプルな認証オプション（Basic Auth、APIキー、カスタム）
- ⚡ **Stimulusコントローラ**: Stimulusによるモダンなjavascriptインタラクション

## 技術スタック

- **View Components**: 再利用可能でテスト可能なviewコンポーネント
- **Stimulus**: JavaScriptインタラクション
- **Lookbook**: コンポーネント開発とドキュメント化
- **Turbo**: 高速でモダンなWebナビゲーション

## インストール

Gemfileに以下の行を追加してください：

```ruby
gem 'stomp_base'
```

そして実行してください：

```
bundle install
```

## セットアップ

gemをインストール後、以下を行ってください：

1. **エンジンをマウント** `routes.rb`ファイルに：
```ruby
Rails.application.routes.draw do
  mount StompBase::Engine => "/stomp_base"
end
```

2. **View Componentのインストール**（依存関係として自動的に含まれます）:
gemには依存関係としてView Componentが含まれているため、追加のセットアップは必要ありません。

## 使用方法

### ダッシュボードへのアクセス

ブラウザで`/stomp_base`にアクセスして管理ダッシュボードを利用してください。

### Lookbookでのコンポーネント開発

開発モードでは、コンポーネント開発とドキュメント化のためのLookbookにアクセスできます：

```bash
rails server
# http://localhost:3000/lookbook にアクセス
```

### 言語設定

初期化ファイル（`config/initializers/stomp_base.rb`）で言語を設定できます：

```ruby
# 日本語に設定
StompBase.configure do |config|
  config.locale = :ja
end

# または直接設定
StompBase.locale = :ja

# デフォルトは英語（:en）
StompBase.configure do |config|
  config.locale = :en
end
```

### 認証設定

Stomp Baseには簡単に設定できる組み込み認証機能が含まれています：

#### Basic認証

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  config.enable_authentication(
    method: :basic_auth,
    username: 'admin',
    password: 'your_secure_password'
  )
end
```

#### APIキー認証

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.enable_authentication(
    method: :api_key,
    keys: ['your-api-key-1', 'your-api-key-2']
  )
end
```

#### カスタム認証

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.enable_authentication(
    method: :custom,
    authenticator: ->(request, params) {
      # カスタム認証ロジック
      request.headers['Authorization'] == 'Bearer your-token'
    }
  )
end
```

#### 認証の無効化

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.disable_authentication
end
```

詳細な認証設定例については、以下の**認証詳細**セクションを参照してください。

```

利用可能なロケール：
- `:en` - English（デフォルト）
- `:ja` - Japanese（日本語）

### インターフェースへのアクセス

- ダッシュボード: `/stomp_base/` または `/stomp_base/dashboard`
- コンソール: `/stomp_base/console`
- 設定: `/stomp_base/settings`

設定ページにアクセスしてWebインターフェースから言語を変更することもできます。

## 開発

Stomp Baseに貢献するには、リポジトリをクローンして以下のコマンドを実行してください：

```bash
bundle install
```

### テストアーキテクチャ

このプロジェクトは最適なパフォーマンスと明確性のために、テストを2つのカテゴリに分けています：

#### Pure Ruby Logic Tests（`spec/lib/`と`spec/unit/`）

RailsやUIコンポーネントを必要としないコアStompBaseロジックのテスト：
- 設定テスト（`spec/unit/configuration_spec.rb`）
- コアモジュールテスト（`spec/lib/`）
- ヘルパーメソッド
- ビジネスロジック

これらのテストは`spec_helper.rb`のみを使用し、重いRails依存関係を必要としません。

**ロジックテストの実行：**
```bash
bundle exec rspec spec/lib/ spec/unit/
```

#### Rails/UI Tests（`spec/rails_demo/`）

Rails特有の機能のテスト：
- ViewComponents
- コントローラ
- 統合テスト

これらのテストはrails_demoアプリケーション環境内で実行され、すべてのRails機能にアクセスできます。

**Rails/UIテストの実行：**
```bash
cd spec/rails_demo
bundle install
bundle exec rspec spec/
```

#### テストヘルパーファイルの更新

**重要：** メインの`spec/rails_helper.rb`は非推奨になりました。テストの種類に応じて適切なヘルパーを使用してください：

- **純粋なRubyロジックテストの場合**: `spec_helper.rb`を使用
- **Railsベースのテストの場合**: `spec/rails_demo/spec/rails_helper.rb`を使用

非推奨の`spec/rails_helper.rb`は警告を表示し、適切なヘルパーファイルに自動的にリダイレクトします。

#### テストの利点

この分離により以下が可能になります：
1. **より高速な純粋ロジックテスト** - Railsの起動や重い依存関係の読み込みが不要
2. **分離された依存関係** - メインgemにRails開発依存関係を含める必要がない
3. **関心の明確な分離** - ビジネスロジック vs UI/Railsロジック

#### テスト移行ノート

- ComponentTestsは`spec/components/`から`spec/rails_demo/spec/components/`に移動
- コントローラテストは`spec/controllers/`から`spec/rails_demo/spec/controllers/`に移動
- 純粋なRubyテストは`spec/lib/`にそのまま残存

**すべてのテストの実行：**
```bash
rspec
```

## API リファレンス

### 設定オプション

```ruby
StompBase.configure do |config|
  config.locale = :ja                    # インターフェース言語の設定
  config.available_locales = [:en, :ja]  # 利用可能な言語オプション（読み取り専用）
  
  # コンソール設定
  config.allow_console_in_production = false # 本番環境でコンソール機能を許可（デフォルト: false）
  
  # 認証オプション
  config.enable_authentication(          # 認証の有効化
    method: :basic_auth,                 # :basic_auth、:api_key、または:custom
    username: 'admin',                   # basic_auth用
    password: 'password',                # basic_auth用
    keys: ['api-key'],                   # api_key用（有効なキーの配列）
    authenticator: -> { }                # custom用（呼び出し可能オブジェクト）
  )
  config.disable_authentication          # 認証の無効化
end
```

### 認証ヘルパーメソッド

```ruby
# 認証が有効かどうかチェック
StompBase.authentication_enabled?    # => true または false

# 認証の有効化
StompBase.enable_authentication(method: :basic_auth, username: 'admin', password: 'pass')

# 認証の無効化
StompBase.disable_authentication
```

### コンソール設定

セキュリティ上の理由により、Railsコンソール機能は本番環境ではデフォルトで無効になっています。必要に応じて有効にできます：

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  # 本番環境でコンソール機能を有効化（セキュリティのためデフォルトで無効）
  config.allow_console_in_production = true
end
```

**⚠️ セキュリティ警告**: 本番環境でコンソール機能を有効にすることは、重大なセキュリティリスクをもたらします。この機能は、影響を十分に理解し、適切なセキュリティ対策を講じている場合にのみ有効にしてください。

### 直接設定

```ruby
# 現在のロケールを取得
StompBase.locale         # => :en

# ロケールを直接設定
StompBase.locale = :ja   # 日本語に設定
StompBase.locale = :en   # 英語に設定（デフォルト）
```

### I18n ヘルパーメソッド

コントローラやビューで包含する場合：

```ruby
include StompBase::I18nHelper

# 自動的に"stomp_base."プレフィックスでキーを翻訳
t('dashboard.title')        # => "Stomp Base Dashboard" または "Stomp Base ダッシュボード"
t('console.placeholder')    # => "Enter Ruby code..." または "Ruby コードを入力してください..."

# 利用可能なロケールを取得
available_locales          # => [:en, :ja]

# 現在のロケールを取得
current_locale            # => :en または :ja

# ロケール表示名を取得
locale_name(:en)          # => "English"
locale_name(:ja)          # => "日本語"
```

### セッション管理

エンジンは自動的に選択された言語をユーザーのセッションに保存します：

```ruby
# 言語設定はsession[:stomp_base_locale]に保存され、
# ページの再読み込みやブラウザセッション間で持続します
```

## 翻訳ファイル

翻訳ファイルは`config/locales/`にあります：

- `en.yml` - 英語翻訳
- `ja.yml` - 日本語翻訳

追加のYAMLファイルを作成し設定を更新することで、より多くの言語を追加できます。

## 認証詳細

Stomp Baseには、データベースやセッション機能を使用せずに設定ファイルから簡単に有効化できる組み込み認証機能があります。

### 認証方法

#### 1. Basic認証

最も基本的な認証方法です。ユーザー名とパスワードを設定します。

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # Basic認証を有効化
  config.enable_authentication(
    method: :basic_auth,
    username: 'admin',
    password: 'secret123'
  )
end
```

#### 2. APIキー認証

APIキーベースの認証です。複数のキーを設定できます。

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # APIキー認証を有効化
  config.enable_authentication(
    method: :api_key,
    keys: ['your-api-key-1', 'your-api-key-2']
  )
end
```

APIキーは以下の方法で送信できます：
- HTTPヘッダー: `X-API-Key: your-api-key`
- URLパラメータ: `?api_key=your-api-key`

#### 3. カスタム認証

独自のカスタム認証ロジックを実装できます。

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  # カスタム認証を有効化
  config.enable_authentication(
    method: :custom,
    authenticator: ->(request, params) {
      # カスタム認証ロジックを実装
      # 認証成功時はtrue、失敗時はfalseを返す
      token = request.headers['Authorization']
      token == 'Bearer your-custom-token'
    }
  )
end
```

### 認証の無効化

認証を無効にするには：

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.disable_authentication
end

# または単純に
StompBase.disable_authentication
```

### 特定のアクションの認証をスキップ

特定のコントローラやアクションで認証をスキップするには：

```ruby
class MyController < StompBase::ApplicationController
  skip_before_action :authenticate_stomp_base, only: [:public_action]
  
  def public_action
    # 認証なしでアクセス可能
  end
  
  def private_action
    # 認証が必要
  end
end
```

### 環境固有の設定

本番環境と開発環境で異なる設定を使用する例：

```ruby
# config/initializers/stomp_base.rb
StompBase.configure do |config|
  config.locale = :ja
  
  if Rails.env.production?
    # 本番環境では強力な認証
    config.enable_authentication(
      method: :api_key,
      keys: [ENV['STOMP_BASE_API_KEY']]
    )
    # セキュリティのため本番環境ではコンソールはデフォルトで無効
    # config.allow_console_in_production = true  # 絶対に必要な場合のみコメントアウトを外す
  elsif Rails.env.development?
    # 開発環境ではシンプルな認証
    config.enable_authentication(
      method: :basic_auth,
      username: 'dev',
      password: 'dev'
    )
    # 開発環境ではコンソールはデフォルトで有効
  else
    # テスト環境では認証を無効化
    config.disable_authentication
  end
end
```

### セキュリティノート

- Basic認証のパスワードやAPIキーは環境変数を使って管理することを推奨します
- HTTPS を使用してください（特にBasic認証を使用する場合）
- APIキーは定期的に更新してください
- 認証情報がログファイルに出力されないよう注意してください
- **コンソール機能は本番環境では無効のままにしておくべきです** デバッグで絶対に必要な場合を除く
- 本番環境でコンソールアクセスが必要な場合は、強力な認証を有効にし、アクセスを適切にログに記録してください

## 実装概要

### 認証機能実装詳細

認証機能は以下のアプローチで実装されています：

#### ✅ 実装された機能

1. **シンプル認証**
   - Basic認証（ユーザー名/パスワード）
   - APIキー認証（ヘッダーまたはパラメータ）
   - カスタム認証（カスタムロジック）

2. **初期化ファイル経由の設定**
   ```ruby
   # config/initializers/stomp_base.rb
   StompBase.configure do |config|
     config.enable_authentication(
       method: :basic_auth,
       username: 'admin',
       password: 'password'
     )
   end
   ```

3. **データベースやセッション機能なし**
   - メモリベースの設定管理
   - HTTPヘッダーやパラメータ経由の認証情報
   - 永続化なしのシンプルな実装

#### 📁 追加されたファイル

- `lib/stomp_base/authentication.rb` - 認証機能の実装
- `lib/stomp_base/configuration.rb` - 認証設定機能を追加
- `spec/unit/configuration_spec.rb` - 設定クラスのユニットテスト

#### 🔧 変更されたファイル

- `lib/stomp_base.rb` - 認証機能の読み込みとヘルパーメソッドの追加
- `app/controllers/stomp_base/application_controller.rb` - 認証モジュールの統合
- `stomp_base.gemspec` - 認証機能の説明を追加
- `Gemfile` - bigdecimal依存関係を追加

#### ✅ 検証された機能

1. **認証なしのアクセス**: 401 Unauthorized で正しく拒否
2. **正しい認証情報**: 200 OK で正常にアクセス
3. **間違った認証情報**: 401 Unauthorized で正しく拒否
4. **デモアプリケーション**: localhost:3001で正常に動作

#### 🚀 将来の拡張可能性

認証機能の実装は完了しています。必要に応じて以下の拡張が可能です：
- 認証ログの追加
- レート制限機能
- 動的な認証設定変更
- より多くの認証方法の追加

## コントリビューション

Stomp Baseへのコントリビューションを歓迎します！以下の方法でご協力いただけます：

### はじめに

1. GitHubで**リポジトリをフォーク**
2. **ローカルにフォークをクローン**：
   ```bash
   git clone https://github.com/YOUR_USERNAME/stomp_base.git
   cd stomp_base
   ```
3. **依存関係をインストール**：
   ```bash
   bundle install
   ```
4. **フィーチャーブランチを作成**：
   ```bash
   git checkout -b feature/your-feature-name
   ```

### 開発セットアップ

1. **テストスイートを実行**して全てが動作することを確認：
   ```bash
   rspec
   ```

2. **テスト用デモアプリケーションを起動**：
   ```bash
   cd spec/rails_demo
   bundle install
   rails server -p 3001
   ```
   `http://localhost:3001/stomp_base`にアクセスして変更を確認できます。

3. **コンポーネント開発用Lookbookを実行**：
   ```bash
   rails server
   # http://localhost:3001/rails/lookbook にアクセス
   ```

### 変更の作成

1. `spec/`ディレクトリで**変更のテストを書く**
2. **Rubyスタイルガイドラインに従い**、コードが適切にフォーマットされていることを確認
3. 必要に応じて**ドキュメントを追加または更新**
4. **変更を徹底的にテスト**：
   ```bash
   rspec
   ```

### コントリビューションの種類

- 🐛 **バグ修正**: 問題や予期しない動作を修正
- ✨ **新機能**: エンジンに新しい機能を追加
- 📚 **ドキュメント**: ドキュメントの改善や追加
- 🎨 **UI/UX改善**: ユーザーインターフェースの強化
- 🌐 **翻訳**: 新しい言語のサポート追加
- 🧪 **テスト**: テストカバレッジの改善
- 🔧 **リファクタリング**: 機能を変更せずにコード品質を改善

### 変更の提出

1. 明確で説明的なメッセージで**変更をコミット**：
   ```bash
   git add .
   git commit -m "Add: 変更の簡潔な説明"
   ```

2. **フォークにプッシュ**：
   ```bash
   git push origin feature/your-feature-name
   ```

3. 以下を含む**GitHubでプルリクエストを作成**：
   - 明確なタイトルと説明
   - 関連する問題への参照
   - UI変更のスクリーンショット
   - テスト結果の確認

### プルリクエストガイドライン

- **PRは焦点を絞る**: 1つのPRにつき1つの機能または修正
- **明確な説明を書く**: 何を変更したか、なぜ変更したかを説明
- **テストを含める**: すべての新しいコードに適切なテストを含める
- **ドキュメントを更新**: 必要に応じてREADMEやその他のドキュメントを更新
- **既存のパターンに従う**: 既存のコードスタイルとアーキテクチャに合わせる

### コードスタイル

- Rubyコミュニティ標準に従う
- 意味のある変数名とメソッド名を使用
- 複雑なロジックにはコメントを追加
- メソッドは小さく焦点を絞る
- 新しいUIコンポーネントにはViewComponentパターンを使用

### テスト

- 新機能のRSpecテストを書く
- 提出前にすべてのテストが通ることを確認
- 適切な場所でユニットテストと統合テストの両方を含める
- エッジケースとエラー条件をテスト

### 問題の報告

バグを見つけたり提案がある場合は：

1. 重複を避けるため**既存の問題をチェック**
2. 以下を含む**新しい問題を作成**：
   - 明確で説明的なタイトル
   - 再現手順（バグの場合）
   - 期待される動作と実際の動作
   - Ruby/Railsバージョン情報
   - 関連するエラーメッセージ

### 質問とサポート

- **GitHub Issues**: バグ報告と機能リクエスト
- **GitHub Discussions**: 質問と一般的な議論
- **プルリクエスト**: コードのコントリビューション

### 表彰

コントリビューターは以下で認められます：
- GitHubコントリビューターリスト
- 重要なコントリビューションのリリースノート
- このREADME（重要なコントリビューションをした場合）

Stomp Baseをより良くするためのご協力をありがとうございます！🙏

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細はLICENSEファイルを参照してください。