class Api::V1::ElitesController < ApplicationController
    def index
        find_player
        @elites = @player.elites
        render json: @elites
    end

    def create
        find_player
        @elite = Elite.new(up: 1, right: 1, down: 1, left: 1, rank: 'E', fight: rand(20), diplomacy: rand(20), espionage: rand(20), leadership: rand(20))
        @elite.in_deck = true if @player.elites.empty?
        @elite.player_id = @player.id
        @elite.name = "#{Faker::Creature::Animal.name} #{Faker::FunnyName.unique.name.split.first}"
        if rand(100) < 2
          @elite.potential = true
        end
        if @elite.fight == 20
          @elite.update(up: 2)
        end
        if @elite.diplomacy == 20
          @elite.update(right: 2)
        end
        if @elite.espionage == 20
          @elite.update(down: 2)
        end
        if @elite.leadership == 20
          @elite.update(left: 2)
        end
        if @elite.fight < 10 && @elite.diplomacy < 10 && @elite.espionage < 10 && @elite.leadership < 10
          @rand = rand(4)
          attributes = [:fight, :diplomacy, :espionage, :leadership]
          @elite.update(attributes[@rand] => 10)
        end
        if @elite.save
            render json: @player.elites
        else
            render json: @elite.errors, status: :unprocessable_entity
        end
    end

    def show
      find_player
      @elite = Elite.find(params[:id])
      if @elite.player == @player
        elite_power
        render json: {elite: @elite, power: @power}
      end
    end

    def elite_power
      @power = []
      if @elite.fight >= 10 && @elite.fight < 100
        (1..@elite.fight.to_s[0].to_i).each do |i|
          @power.push("fight#{i}")
        end
      elsif @elite.fight == 100
        (1..9).each do |i|
          @power.push("fight#{i}")
        end
        @power.push("fight10")
      end
      if @elite.diplomacy >= 10 && @elite.diplomacy < 100
        (1..@elite.diplomacy.to_s[0].to_i).each do |i|
          @power.push("diplomacy#{i}")
        end
      elsif @elite.diplomacy == 100
        (1..9).each do |i|
          @power.push("diplomacy#{i}")
        end
        @power.push("diplomacy10")
      end
      if @elite.espionage >= 10 && @elite.espionage < 100
        (1..@elite.espionage.to_s[0].to_i).each do |i|
          @power.push("espionage#{i}")
        end
      elsif @elite.espionage == 100
        (1..9).each do |i|
          @power.push("espionage#{i}")
        end
        @power.push("espionage10")
      end
      if @elite.leadership >= 10 && @elite.leadership < 100
        (1..@elite.leadership.to_s[0].to_i).each do |i|
          @power.push("leadership#{i}")
        end
      elsif @elite.leadership == 100
        (1..9).each do |i|
          @power.push("leadership#{i}")
        end
        @power.push("leadership10")
      end
    end

    def ability
      @message = nil
      find_player
      if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait' || @player.zone_position != "A1"
        @message = "You can't change your ability now!"
      else 
        @player.update(ability: params[:power])
      end
      render json: {message: @message}
    end

    def increment_elite
      find_player
      return if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait' || @player.zone_position != "A1"
      @elite = Elite.find(params[:id])
      attributes = [:fight, :diplomacy, :espionage, :leadership]
      @cost = 10
      if @elite.nft == true
        @cost = 5
      end

      if @elite.player == @player && @player.elite_points > 0 && @player.energy >= (@elite.send(attributes[params[:stat].to_i]) * @cost)
          @player.update(elite_points: @player.elite_points - 1)
          @player.update(energy: @player.energy - (@elite.send(attributes[params[:stat].to_i]) * @cost))
          @elite.update(attributes[params[:stat].to_i] => (@elite.send(attributes[params[:stat].to_i]).to_i + 1).to_s)
          elite_power
          if params[:stat].to_i == 0
            @elite.update(up: @elite.fight / 10)
          elsif params[:stat].to_i == 1
            @elite.update(right: @elite.diplomacy / 10)
          elsif params[:stat].to_i == 2
            @elite.update(down: @elite.espionage / 10)
          elsif params[:stat].to_i == 3
            @elite.update(left: @elite.leadership / 10)
          end
          render json: {elite: @elite, power: @power, energy: @player.energy, player: @player}
      else 
        render json: {elite: @elite, power: @power}
      end
  end

  def nft_elite
    find_player
    @elite = Elite.find(params[:id])
    if @elite.nft == false && @elite.player == @player
      @elite.update(nft: true)
    end
    render json: {elite: @elite}
  end

    private

    def find_player
      if Player.where(authentication_token: params[:token]).count == 1
        @player = Player.find_by(authentication_token: params[:token])
      end
    end
      
end
