# 🧹 ChoresTier

## 📌 アプリケーション概要

ChoresTierは、夫婦や家族など複数人で「家事」をティアリスト形式で視覚的に管理・共有できるWebアプリケーションです。
D&D（ドラッグ＆ドロップ）での家事の優先順位付けや、担当・頻度・履歴などの管理を通じて、家事の「見える化」と「分担の最適化」を実現します。

## 🌐 URL

`http://54.64.230.66/`

## 🧪 テスト用アカウント

- ログインメールアドレス：`test@coo`
- パスワード：`kf@asdlo`
- Basic認証
   ID:admin
   パスワード:j854@2G

## 🚀 利用方法

1. ユーザー登録・ログイン
2. ティアリストを作成し、家事を追加、招待リンクによりティアリスト共有
3. ティア内で家事カードをD&Dで移動して優先度調整
4. 家事ごとに担当者・頻度・完了履歴を管理
5. ダッシュボードで家事状況を可視化（進捗バー／予定カレンダー／履歴一覧）

## 🎯 アプリケーションを作成した背景

「家事の可視化と共有」をテーマに、パートナー間・家族間で「誰が・何を・どの頻度で行っているか」を明確にし、タスクの偏りを防ぐことを目的としました。
 特に、視覚的にわかりやすいティアリストUIにより、家事の重要度や優先度を直感的に把握できます。

## 📷 実装機能と画面

- 🔒 ユーザー認証（Devise）
  [ユーザー登録画面](https://gyazo.com/b9e06ae97060ec0f2c6ff15b9cb2c14b)
  [ログイン画面](https://gyazo.com/1f8a7bcab63b72fdca960450aaba4ac5)
- 📋 家事登録・リスト・編集・詳細画面
  [家事登録画面](https://gyazo.com/d15f30c6918943820d89a87678b8cfcf)
  [家事リスト](https://gyazo.com/bc8a0abf61033327e5582cc8bd7f61c9)
  [家事編集画面](https://gyazo.com/c87b0128c37faf1ae8a8858960944daf)
  [家事詳細画面](https://gyazo.com/87c7285b982f8113dbae4f6f82eb0629)
- 🧩 ティアリスト編集（D&D機能）
  [ティアリスト編集](https://gyazo.com/be86f52cb758de0703bdda4890695370)
  [ティアリスト情報編集](https://gyazo.com/65b114b1cc95ac7dfcd5156f521e33b9)
- 📊 ダッシュボード（統計・予定・進捗）
  [ダッシュボード](https://gyazo.com/beb10eb2743a3d7f871c55f660f3389d)

## 🔮 今後の実装予定機能

- スマートフォン対応（レスポンシブUI）
- 家事提案AI機能（家族構成や頻度に応じて家事候補を自動生成）
- 通知機能（Slack/LINEなどと連携）

## 🧭 データベース設計

ER図は以下の通りです：

[ER図](https://gyazo.com/141517f4b1746113313346f54dbce8d5)

## 🔁 画面遷移図

[画面遷移図](https://gyazo.com/d5a6f0db44211aa1a689e81d34d8b55f)

## 🛠 開発環境

- フレームワーク：Ruby on Rails 7
- データベース：MySQL
- フロントエンド：SCSS + JavaScript（ES6）
- 認証：Devise
- デプロイ：AWS
- テキストエディタ：Visual Studio Code
- バージョン管理：Git / GitHub

## 🧪 ローカルでの動作方法

```bash
git clone https://github.com/takehiro-yamamoto/chore_tiers_app.git
cd chore_tiers_app
bundle install
rails db:create
rails db:migrate
rails s
```

## 🌟 工夫したポイント
- ティアリストをD&Dで直感的に編集できるよう設計
- 家事の完了ログをAjaxで登録・即時反映
- データベースを6テーブル以上に正規化し、拡張性と共有性を担保
- プロトタイプUIはGoogle I/O 2025で発表されたGoogle Stich AI プロトタイプを参考に制作

🧩 改善点
- 画面遷移先の変更
- スマホ対応（レスポンシブ対応）未実装 → TailwindやReact導入予定
- 通知バナー／リアルタイム更新機能の未実装

⏰ 制作時間
約80時間（設計・開発・UIデザイン含む）

# 📘 ChoresTier アプリ - データベース設計

## 👤 users テーブル

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| name                   | string   | null: false                            |
| email                  | string   | null: false, unique: true              |
| encrypted_password     | string   | Deviseで自動生成                       |
| avatar_url             | string   | 任意                                   |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- has_many :assigned_chores（担当している家事）
- has_many :created_chores（作成した家事）
- has_many :completion_logs
- has_many :created_tier_lists（作成したティアリスト）
- has_many :tier_list_memberships
- has_many :shared_tier_lists（共有されているティアリスト）

---

## 🧹 chores テーブル

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| title                  | string   | null: false                            |
| description            | text     | 任意                                   |
| tier_id                | bigint   | 外部キー(tiers), optional              |
| assigned_to_id         | bigint   | 外部キー(users), optional              |
| created_by_id          | bigint   | 外部キー(users), null: false           |
| completed              | boolean  | default: false                         |
| frequency_type         | string   | enum（daily/weekly/once/nil）          |
| frequency_days         | text     | JSON形式の曜日配列                    |
| frequency_times        | string   | 任意                                   |
| scheduled_date         | date     | 任意                                   |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- belongs_to :tier（optional）
- belongs_to :assigned_to（User、optional）
- belongs_to :creator（User）
- has_many :completion_logs
- has_many :tier_list_items, dependent: :destroy
- has_many :tier_lists, through: :tier_list_items

---

## 📝 completion_logs テーブル

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| chore_id               | bigint   | 外部キー(chores), null: false          |
| user_id                | bigint   | 外部キー(users), null: false           |
| completed_at           | datetime | null: false                            |
| note                   | string   | 最大100文字                            |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- belongs_to :chore
- belongs_to :user

---

## 🗂️ tier_lists テーブル

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| name                   | string   | null: false                            |
| creator_id             | bigint   | 外部キー(users), null: false           |
| invite_token           | string   | 一意, 招待リンク用                     |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- belongs_to :creator（User）
- has_many :tier_list_items, dependent: :destroy
- has_many :chores, through: :tier_list_items
- has_many :tier_list_memberships, dependent: :destroy
- has_many :members, through: :tier_list_memberships, source: :user

### 🔄 コールバック
- `before_create`：invite_token を自動生成
- `after_create`：作成者を自動でメンバーに追加
- `before_destroy`：紐づく chore を削除

---

## 🏷️ tiers テーブル

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| name                   | string   | null: false, unique: true              |
| label                  | string   | 表示ラベル                             |
| priority               | integer  | null: false                            |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- has_many :tier_list_items

---

## 🧩 tier_list_items テーブル（中間・D&D管理）

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| tier_list_id           | bigint   | 外部キー(tier_lists), null: false      |
| chore_id               | bigint   | 外部キー(chores), null: false          |
| tier_id                | bigint   | 外部キー(tiers), optional              |
| position               | integer  | 並び順（D&D用）                        |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- belongs_to :tier_list
- belongs_to :chore
- belongs_to :tier（optional）

---

## 👥 tier_list_memberships テーブル（共有管理）

| カラム名               | 型       | 制約                                   |
|------------------------|----------|----------------------------------------|
| id                     | bigint   | 主キー                                 |
| tier_list_id           | bigint   | 外部キー(tier_lists), null: false      |
| user_id                | bigint   | 外部キー(users), null: false           |
| created_at / updated_at| datetime | 自動生成                               |

### 🔗 アソシエーション
- belongs_to :tier_list
- belongs_to :user

### ✅ バリデーション
- 一意性：`[tier_list_id, user_id]` の組み合わせをユニークに制限
