class User < ApplicationRecord
    include Visible
    has_secure_password

    validates :email , presence: true, uniqueness: true
    validates :username, :password, presence: true
end
