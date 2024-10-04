class Pnj < ApplicationRecord
    belongs_to :player
    serialize :dialogue, JSON
    before_validation :initialize_dialogue

    def initialize_dialogue
        self.dialogue ||= []
      end
end
