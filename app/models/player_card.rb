class PlayerCard < ApplicationRecord
  belongs_to :player
  validates :up, :down, :left, :right, presence: true

  private
  
  def player_card_params
    params.require(:player_card).permit(:up, :down, :right, :left, :position, :computer, :player)
  end
end
