class Note < ApplicationRecord
  belongs_to :user
  validates :title , :content, :tag , presence: true
end
