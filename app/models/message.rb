class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  validates :content, presence: true, length: { maximum:140 }
  # DMで送信できるメッセージは140字以内
end
