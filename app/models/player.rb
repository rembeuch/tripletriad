class Player < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable    
    validates :wallet_address, uniqueness: true
    validates :name, presence: true , length: { maximum: 20 }, uniqueness: true
    validates :power_point, numericality: { less_than_or_equal_to: 10 }
    validates :computer_power_point, numericality: { less_than_or_equal_to: 10 }
    has_one :game
    has_many :player_cards
    has_many :elites
    serialize :decks, JSON
    before_validation :initialize_decks

    private

  def initialize_decks
    self.decks ||= []
  end
end
