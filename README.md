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
- has_many :chores, dependent: :destroy

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
