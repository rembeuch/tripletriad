class Api::V1::CardsController < ApplicationController
    def index
      find_player      
      @cards = @player.cards.where(max: false).sort_by { |card| card.up.to_i + card.down.to_i + card.right.to_i + card.left.to_i }.reverse
      render json: @cards
    end

    def show
      find_player      
      @monster = Card.find(params[:id])
      if @monster.player == @player
        render json: {monster: @monster}
      end
    end

    def rank_cards
      find_player
      if params[:sort] == "somme"
        @cards = @player.cards.where(max: false).sort_by { |card| card.up.to_i + card.down.to_i + card.right.to_i + card.left.to_i }.reverse
      elsif params[:sort] == "max"
        @cards = @player.cards.where(max: true).sort_by { |card| card.rank}.reverse
      else
        @cards = @player.cards.sort_by { |card| card.send(params[:sort]).to_i }.reverse
      end    
      render json: @cards
    end

    def increment_card
      find_player
      @message = nil
      @card = Card.find(params[:id])
      attributes = [:up_points, :right_points, :down_points, :left_points]
      if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait' 
        @message = "You can't, you are in game!"
      elsif @player.zone_position != "A1" && @player.s_zone == false
        @message = "Only in A1 level!"
      elsif @card.player == @player && @card.copy > 0 && @player.energy >= (@card.send(attributes[params[:stat].to_i]) * 10 * @card.rank.to_i) && @card.max == false
        @card.update(copy: @card.copy - 1)
        @player.update(energy: @player.energy - (@card.send(attributes[params[:stat].to_i]) * 10 * @card.rank.to_i))
        @card.update(attributes[params[:stat].to_i] => (@card.send(attributes[params[:stat].to_i]).to_i + 1))
        if @card.send(attributes[params[:stat].to_i]) == ( 30/ @card.rank.to_i ) 
            modified_attributes = attributes.map { |attribute| attribute.to_s.chomp('_points').to_sym }
            @card.update(modified_attributes[params[:stat].to_i] => (@card.send(modified_attributes[params[:stat].to_i]).to_i + 1).to_s)
            if @card.up_points == ( 30/ @card.rank.to_i ) && @card.right_points == ( 30/ @card.rank.to_i ) && @card.down_points == ( 30/ @card.rank.to_i ) && @card.left_points == ( 30/ @card.rank.to_i )
              Card.create(up: @card.up, down: @card.down, right: @card.right, left: @card.left, player: @player, name: @card.name + 'max', rank: @card.rank, up_points: 0, right_points: 0, down_points: 0, left_points: 0, copy: 1, max: true )
              find_pnj
              @pnj.update(awake: @pnj.awake + 1)
              Monster.find_by(name: @card.name).zones.each do |zone|
                @zone_pnj = Pnj.find_by(zone: zone)
                if @zone_pnj
                  @zone_pnj.update(awake: @zone_pnj + 1)
                end
              end
            end
        end
      else 
        @message = "Not enough energy!"
      end
      render json: {monster: @card, message: @message}
    end

    def sell_card
      find_player
      @card = Card.find(params[:id])
      if @card.player == @player && @card.copy > 0 && @card.max == false
        @card.update(copy: @card.copy - 1)
        @player.update(energy: (@player.energy + 50 * @card.rank.to_i))
      end
      render json: {monster: @card}
    end

    def awake_card
      find_player
      @message = nil
      @card = Card.find(params[:id])
      if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait' 
        @message = "You can't, you are in game!"
      elsif @player.zone_position != "A1" && @player.s_zone == false
        @message = "Only in A1 level!"
      elsif @card.player == @player && @card.copy >= ((30 / @card.rank.to_i) * 4) && @player.energy >= (4650 * @card.rank.to_i) && @card.max == false
        @card.update(copy: @card.copy - ((30 / @card.rank.to_i) * 4))
        @player.update(energy: @player.energy - (4650 * @card.rank.to_i))
          if @card.up_points == ( 30/ @card.rank.to_i ) && @card.right_points == ( 30/ @card.rank.to_i ) && @card.down_points == ( 30/ @card.rank.to_i ) && @card.left_points == ( 30/ @card.rank.to_i )
            @awake_card = Card.where(player: @player).select{|c| c.name == @card.name + 'max'}.first
            if @awake_card
              @awake_card.update(copy: @awake_card.copy + 1)
            else
              Card.create(up: @card.up, down: @card.down, right: @card.right, left: @card.left, player: @player, name: @card.name + 'max', rank: @card.rank, up_points: 0, right_points: 0, down_points: 0, left_points: 0, copy: 1, max: true )
            end
          end
        find_pnj
        @pnj.update(awake: @pnj.awake + 1)
        Monster.find_by(name: @card.name).zones.each do |zone|
          @zone_pnj = Pnj.find_by(zone: zone)
          if @zone_pnj
            @zone_pnj.update(awake: @zone_pnj + 1)
          end
        end
      else 
        @message = "Not enough energy!"
      end
      render json: {monster: @card, message: @message}
    end

    def find_monsters
      find_player
      @monsters = @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.zones.include?(@player.zone_position)}
      @zone_monsters = Monster.select{|m| m.zones.include?(@player.zone_position)}
      if @player.s_zone
        @s_monsters = @player.s_monsters.map{|m| Monster.find_by(name: m)}
        @copy = []
        @player.s_monsters.each do |name|
          if @player.cards.find_by(name: name)
            @copy.push(@player.cards.find_by(name: name).copy)
          else
            @copy.push(0)
          end
        end
      end
      render json: {monsters: @monsters.size, zone_monsters: @zone_monsters.size, s_monsters: @s_monsters, copy: @copy}
    end

    def buy_market
      find_player
      @monster = Monster.find_by(name: @player.s_monsters[params[:index].to_i])
      if !@player.monsters.include?(@monster.name) && @player.energy > ((@monster.rank * 100) + 200)
        @player.monsters.push(@monster.name)
        @player.monsters.sort_by { |monster| monster.delete("#").to_i }
        @player.elite_points += 1
        @message = "New Monster: #{@monster.name} + 1 Elite Point!"
        @player.save
        @player.update(energy: @player.energy - ((@monster.rank * 100) + 200))
        Card.create(up: @monster.up, down: @monster.down, right: @monster.right, left: @monster.left, player: @player, name: @monster.name, rank: @monster.rank, image: @monster.image, up_points: 0, right_points: 0, down_points: 0, left_points: 0 )
      elsif @player.monsters.include?(@monster.name) && @player.energy > ((@monster.rank * 100) + 100)
        @card = @player.cards.find_by(name: @monster.name)
        if @card
          @card.update(copy: @card.copy + 1)
        end
        @player.update(energy: @player.energy - ((@monster.rank * 100) + 100))
        @message = "Monster copy +1"
      else 
        @message = "Not enough energy"
      end
      render json: {message: @message}
    end

    def sell_market
      find_player
      @monster = Monster.find_by(name: @player.s_monsters[params[:index].to_i])
      @card = @player.cards.find_by(name: @monster.name)
      if @card.copy > 0
        @card.update(copy: @card.copy - 1)
        @player.update(energy: @player.energy + (@monster.rank * 100))
        @message = "+ #{@monster.rank * 100} energy!"
      else
        @message = "no more copy to sell!"
      end
      render json: {message: @message}
    end

    private

    def find_player
      @player = Player.find(params[:player_id])
    end

    def find_pnj
      @pnj = @player.pnjs.where(zone: nil).first
    end
end
