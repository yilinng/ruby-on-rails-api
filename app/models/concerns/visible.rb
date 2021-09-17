module Visible
    extend ActiveSupport::Concern

    VALID_ROLES = ['admin', 'basic']

    included do 
        validates :role, inclusion: { in: VALID_ROLES }
    end

    def basic?
        role == 'basic'
    end    
end