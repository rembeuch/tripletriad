class Card < ApplicationRecord
    validates :up, :down, :left, :right, presence: true
    belongs_to :player
end
