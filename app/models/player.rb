class Player < ApplicationRecord
    validates :wallet_address, uniqueness: true, presence: true
    validates :name, presence: true , length: { maximum: 20 }, uniqueness: true
    has_one :game
    has_many :player_cards
    serialize :decks, JSON
    before_validation :initialize_decks

    private

  def initialize_decks
    self.decks ||= []
  end
end
