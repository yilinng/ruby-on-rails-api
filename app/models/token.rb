class Token < ApplicationRecord
  belongs_to :user
  validates :accesstoken, presence: true
end
