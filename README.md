# 📘 ChoreTiers アプリ - データベース設計

## 👤 users テーブル

| カラム名              | 型       | 制約                             |
|-----------------------|----------|----------------------------------|
| id                    | bigint   | 主キー                          |
| name                  | string   | null: false                     |
| email                 | string   | null: false, unique: true       |
| encrypted_password    | string   | Deviseで自動生成                |
| avatar_url            | string   | 任意                             |
| created_at / updated_at | datetime | 自動生成                         |

### 🔗 アソシエーション
- has_many :assigned_chores, class_name: "Chore", foreign_key: "assigned_to_id", dependent: :nullify
- has_many :completion_logs, dependent: :destroy
- has_many :created_tier_lists, class_name: 'TierList', foreign_key: 'creator_id'
- has_many :tier_list_memberships, dependent: :destroy
- has_many :shared_tier_lists, through: :tier_list_memberships, source: :tier_list

### ✅ バリデーション
- presence: name, email
- uniqueness: email

---

## 🏷️ tiers テーブル

| カラム名  | 型       | 制約                        |
|-----------|----------|-----------------------------|
| id        | bigint   | 主キー                      |
| name      | string   | null: false, unique: true   |
| label     | string   | 表示ラベル                   |
| priority  | integer  | null: false                 |
| created_at / updated_at | datetime | 自動生成         |

### 🔗 アソシエーション
- has_many :tier_list_items, dependent: :destroy

### ✅ バリデーション
- presence: name, priority
- uniqueness: name

---

## 🧹 chores テーブル

| カラム名       | 型       | 制約                                |
|----------------|----------|-------------------------------------|
| id             | bigint   | 主キー                              |
| title          | string   | null: false                         |
| description    | text     | 任意                                |
| tier_id        | bigint   | 外部キー, null: false               |
| assigned_to_id | bigint   | 外部キー(users), null: true         |
| completed      | boolean  | default: false                      |
| created_at / updated_at | datetime | 自動生成                  |

### 🔗 アソシエーション
- belongs_to :tier
- belongs_to :assigned_to, class_name: "User", optional: true
- has_many :completion_logs, dependent: :destroy
- has_many :tier_list_items
- has_many :tier_lists, through: :tier_list_items

### ✅ バリデーション
- presence: title, tier

---

## 📝 completion_logs テーブル

| カラム名     | 型       | 制約                             |
|--------------|----------|----------------------------------|
| id           | bigint   | 主キー                           |
| chore_id     | bigint   | 外部キー, null: false            |
| user_id      | bigint   | 外部キー, null: false            |
| completed_at | datetime | null: false                      |
| note         | string   | 任意                             |
| created_at / updated_at | datetime | 自動生成            |

### 🔗 アソシエーション
- belongs_to :chore
- belongs_to :user

### ✅ バリデーション
- presence: completed_at

---

## 🗂️ tier_lists テーブル

| カラム名    | 型       | 制約                                |
|-------------|----------|-------------------------------------|
| id          | bigint   | 主キー                              |
| name        | string   | null: false                         |
| creator_id  | bigint   | 外部キー(users), null: false        |
| created_at / updated_at | datetime | 自動生成              |

### 🔗 アソシエーション
- belongs_to :creator, class_name: 'User'
- has_many :tier_list_items, dependent: :destroy
- has_many :chores, through: :tier_list_items
- has_many :tier_list_memberships, dependent: :destroy
- has_many :members, through: :tier_list_memberships, source: :user

### ✅ バリデーション
- presence: name, creator_id

---

## 🧩 tier_list_items テーブル

| カラム名      | 型       | 制約                              |
|---------------|----------|-----------------------------------|
| id            | bigint   | 主キー                            |
| tier_list_id  | bigint   | 外部キー(tier_lists), null: false |
| chore_id      | bigint   | 外部キー(chores), null: false     |
| tier_id       | bigint   | 外部キー(tiers), null: false      |
| position      | integer  | 並び順, null: true                |
| created_at / updated_at | datetime | 自動生成            |

### 🔗 アソシエーション
- belongs_to :tier_list
- belongs_to :chore
- belongs_to :tier

### ✅ バリデーション
- presence: tier_list_id, chore_id, tier_id

---

## 👥 tier_list_memberships テーブル

| カラム名      | 型       | 制約                                  |
|---------------|----------|---------------------------------------|
| id            | bigint   | 主キー                                |
| tier_list_id  | bigint   | 外部キー(tier_lists), null: false     |
| user_id       | bigint   | 外部キー(users), null: false          |
| created_at / updated_at | datetime | 自動生成              |

### 🔗 アソシエーション
- belongs_to :tier_list
- belongs_to :user

### ✅ バリデーション
- presence: tier_list_id, user_id
- 一意性: [tier_list_id, user_id] の組み合わせをユニークに制限
