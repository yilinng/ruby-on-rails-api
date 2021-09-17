class Note < ApplicationRecord
  belongs_to :user
  validates :title , :content, :tags , presence: true
end
