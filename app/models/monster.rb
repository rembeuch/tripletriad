class Monster < ApplicationRecord
    serialize :zones, JSON
    before_validation :initialize_zones

    private

  def initialize_zones
    self.zones ||= []
  end
end
