class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  # ユーザにつなぐ中間テーブル
  has_many :messages, dependent: :destroy
end
