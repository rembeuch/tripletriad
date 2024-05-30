class Player < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable    
    validates :wallet_address, uniqueness: true
    validates :email, presence: true , uniqueness: true
    validates :name, presence: true , length: { maximum: 20 }, uniqueness: true
    has_one :game
    has_one :pvp
    has_many :player_cards
    has_many :cards
    has_many :elites
    serialize :decks, JSON
    before_validation :initialize_decks
    serialize :zones, JSON
    before_validation :initialize_zones
    serialize :monsters, JSON
    before_validation :initialize_monsters
    serialize :s_monsters, JSON
    before_validation :initialize_s_monsters

    private

  def initialize_decks
    self.decks ||= []
  end

  def initialize_zones
    self.zones ||= []
  end

  def initialize_monsters
    self.monsters ||= []
  end

  def initialize_s_monsters
    self.s_monsters ||= []
  end
end
