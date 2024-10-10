class Api::V1::PnjsController < ApplicationController
    before_action :find_player

    def find_pnj
        @pnj = @player.pnjs.where(zone: nil).first
        render json: @pnj
    end

    def find_zone_pnj
        @zone_pnj = @player.pnjs.where(zone: @player.zone_position).first
        @zone = ZoneNamesManager::CASE_NAMES[@zone_pnj.zone.to_sym]
        render json: {zone_pnj: @zone_pnj, zone: @zone}
    end

    def find_all_pnjs
        filtered_pnjs = @player.pnjs.map do |pnj|
          pnj.attributes.reject { |key, value| value == 0 }
        end
        zones = []
        filtered_pnjs.each_with_index do |_, index|
            zones.push(ZoneNamesManager::CASE_NAMES.to_a[index][1])
        end
        render json: {pnjs: filtered_pnjs, zones: zones}
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
