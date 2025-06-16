# 🟡 重要：MySQL で index 長すぎエラーを防ぐ（文字列カラムの長さに制限）
Rails.application.config.active_storage.variant_record_max_key_length = 191 if Rails.version >= "7.1"