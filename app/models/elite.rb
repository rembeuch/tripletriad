class Elite < ApplicationRecord
    belongs_to :player
    validates :name, uniqueness: true
end
