class Card < ApplicationRecord
    validates :up, :down, :left, :right, presence: true
end
