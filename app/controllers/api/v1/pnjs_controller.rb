class Api::V1::PnjsController < ApplicationController
    before_action :find_player

    def find_pnj
        @pnj = @player.pnjs.where(zone: nil).first
        render json: @pnj
    end

    def find_zone_pnj
        @zone_pnj = @player.pnjs.where(zone: @player.zone_position).first
        render json: @zone_pnj
    end

    def display_menu_dialogue
        @pnj = @player.pnjs.where(zone: nil).first 
        render json: @pnj.dialogue
    end

    def display_pnj_dialogue
        @zone_pnj = @player.pnjs.where(zone: @player.zone_position).first
        render json: @zone_pnj.dialogue
    end

    def self.case_dialogues(pnj, event)
        DialoguesManager.calcul_dialogues(pnj, event, @player)
    end

    private

    def find_player
        @player = Player.find(params[:player_id])
    end  
end
