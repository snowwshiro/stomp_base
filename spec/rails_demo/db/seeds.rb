# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample categories
categories = [
  { name: "Ruby", description: "Rubyプログラミング言語に関する記事" },
  { name: "Rails", description: "Ruby on Railsフレームワークに関する記事" },
  { name: "JavaScript", description: "JavaScriptに関する記事" },
  { name: "Web開発", description: "Web開発全般に関する記事" },
  { name: "データベース", description: "データベース設計・運用に関する記事" },
  { name: "DevOps", description: "開発・運用に関する記事" }
]

categories.each do |cat_attrs|
  Category.find_or_create_by(name: cat_attrs[:name]) do |category|
    category.description = cat_attrs[:description]
  end
end

# Create sample posts
posts_data = [
  {
    title: "StompBaseエンジンの紹介",
    content: <<~CONTENT,
      StompBaseは、Railsアプリケーションの開発を支援する強力なエンジンです。

      ## 主な機能

      ### 1. ダッシュボード
      アプリケーションの状態を一目で確認できるダッシュボード機能を提供します。

      ### 2. コンソール機能
      ブラウザ上でRailsコンソールを実行できる便利な機能です。開発中のデバッグや、本番環境での緊急対応に役立ちます。

      ### 3. モデル管理
      アプリケーション内のActiveRecordモデルを可視化し、関連性やスキーマ情報を確認できます。

      ### 4. 設定管理
      アプリケーションの各種設定を一元管理できます。

      ## 使用方法

      StompBaseをGemfileに追加し、エンジンをマウントするだけで利用できます。

      ```ruby
      gem 'stomp_base'
      ```

      ```ruby
      # config/routes.rb
      mount StompBase::Engine, at: "/stomp_base"
      ```

      これで、`/stomp_base`パスでStompBaseの機能にアクセスできるようになります。
    CONTENT
    author: "開発チーム",
    published_at: 2.days.ago,
    status: "published",
    categories: ["Ruby", "Rails"]
  },
  {
    title: "View Componentを使ったコンポーネント設計",
    content: <<~CONTENT,
      View Componentは、Railsアプリケーションでコンポーネント指向の開発を可能にするライブラリです。

      ## View Componentとは

      View Componentを使用することで、ビューロジックをテスト可能なRubyクラスとして実装できます。

      ## メリット

      ### 1. テスタビリティ
      従来のPartialとは異なり、View Componentは純粋なRubyクラスとして実装されるため、
      単体テストが書きやすくなります。

      ### 2. 再利用性
      コンポーネントとして独立しているため、アプリケーション全体で再利用しやすくなります。

      ### 3. パフォーマンス
      Partialよりも高速に動作します。

      ## 実装例

      ```ruby
      class ButtonComponent < ViewComponent::Base
        def initialize(text:, variant: :primary, **options)
          @text = text
          @variant = variant
          @options = options
        end

        private

        attr_reader :text, :variant, :options
      end
      ```

      StompBaseでもView Componentを活用して、モジュラーで保守性の高いUIコンポーネントを構築しています。
    CONTENT
    author: "UI/UXチーム",
    published_at: 1.day.ago,
    status: "published",
    categories: ["Rails", "Web開発"]
  },
  {
    title: "Railsアプリケーションのパフォーマンス最適化",
    content: <<~CONTENT,
      Railsアプリケーションのパフォーマンスを向上させるためのベストプラクティスをご紹介します。

      ## データベースクエリの最適化

      ### N+1問題の解決
      `includes`、`preload`、`eager_load`を適切に使用してN+1問題を解決しましょう。

      ```ruby
      # 悪い例
      posts = Post.all
      posts.each { |post| puts post.author.name }

      # 良い例
      posts = Post.includes(:author)
      posts.each { |post| puts post.author.name }
      ```

      ### インデックスの適切な設定
      頻繁に検索されるカラムには適切なインデックスを設定しましょう。

      ## キャッシュの活用

      ### フラグメントキャッシュ
      部分的なビューをキャッシュして、レンダリング時間を短縮できます。

      ### メモ化
      同じ計算を何度も実行することを避けるため、メモ化を活用しましょう。

      ## その他の最適化テクニック

      1. 適切なHTTPキャッシュヘッダーの設定
      2. CDNの活用
      3. 静的アセットの最適化
      4. バックグラウンドジョブの活用

      これらの技術を組み合わせることで、大幅なパフォーマンス向上が期待できます。
    CONTENT
    author: "パフォーマンスチーム",
    published_at: 3.hours.ago,
    status: "published",
    categories: ["Rails", "データベース", "Web開発"]
  }
]

posts_data.each do |post_data|
  post = Post.find_or_create_by(title: post_data[:title]) do |p|
    p.content = post_data[:content]
    p.author = post_data[:author]
    p.published_at = post_data[:published_at]
    p.status = post_data[:status]
  end

  # Associate categories
  category_names = post_data[:categories]
  categories_to_associate = Category.where(name: category_names)
  post.categories = categories_to_associate
end

puts "シードデータの作成が完了しました！"
puts "作成されたカテゴリ: #{Category.count}個"
puts "作成された記事: #{Post.count}個"
