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

    def find_pnj_objectives
        pnj = Pnj.find(params[:pnj_id])
        objectives = PnjObjective.where(pnj: pnj, reveal: true)
        current_stat = objectives.map do |objective|
            if pnj.respond_to?(objective.name)
              pnj_value = pnj.send(objective.name)
              pnj_value.nil? ? 0 : pnj_value
            elsif objective.name == 'monsters'
                @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.zones.include?(@player.zone_position)}.size
            end
          end

        render json: {objectives: objectives, current_stat: current_stat}
    end

    def check_objective
        @current = params[:current]
        @objective = PnjObjective.find(params[:objective_id])
        if @objective.name == 'ability'
            @pnj = @objective.pnj
            @pnj.zone.nil? ? zone = 'A0' : zone = @pnj.zone
            @elite = @player.elites.where(in_deck: true).first
            if @objective.condition.first == 'f' && @elite.fight >= (@objective.condition.last(2).to_i * 10)
                @player.elite_points += 1
                @player.save
                @dialogue = DialoguesManager::CASE_DIALOGUES[zone.to_sym][:fight]
                @objective.update(completed: true)
            elsif @objective.condition.first == 'd' && @elite.diplomacy >= (@objective.condition.last(2).to_i * 10)
            elsif @objective.condition.first == 'e' && @elite.espionage >= (@objective.condition.last(2).to_i * 10)
            elsif @objective.condition.first == 'l' && @elite.leadership >= (@objective.condition.last(2).to_i * 10)
            end
        elsif @objective.name == 'pnj'
            @dialogue = 'pnj'
        else
            if @current.to_i >= @objective.condition.to_i
                @objective.update(completed: true)
                @dialogue = "Yep Bravo!"
            else 
                @dialogue = 'Nope!'
            end
        end

        render json: {dialogue: @dialogue}
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
