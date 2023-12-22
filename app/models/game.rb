class Game < ApplicationRecord
    belongs_to :player
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
