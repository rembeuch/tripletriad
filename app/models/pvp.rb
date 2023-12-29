class Pvp < ApplicationRecord
    belongs_to :player1, class_name: 'Player'
    belongs_to :player2, class_name: 'Player'

    serialize :logs, JSON
    before_validation :initialize_logs
    serialize :monsters, JSON
    before_validation :initialize_monsters

    private

  def initialize_logs
    self.logs ||= []
  end
  
  def initialize_monsters
    self.monsters ||= []
  end
end