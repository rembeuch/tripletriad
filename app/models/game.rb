class Game < ApplicationRecord
    belongs_to :player
    serialize :logs, JSON
    before_validation :initialize_logs

    private

  def initialize_logs
    self.logs ||= []
  end
end
