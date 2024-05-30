class Api::V1::PnjsController < ApplicationController
    def find_pnj
        find_player
        @pnj = @player.pnjs.where(zone: nil).first
        render json: @pnj
    end

    private

    def find_player
        @player = Player.find(params[:player_id])
    end  
end
