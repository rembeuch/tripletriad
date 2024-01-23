class Api::V1::PvpsController < ApplicationController

    def create
      if Player.where(authentication_token: params[:token]).count == 1
        @player = Player.find_by(authentication_token: params[:token])
      end
        return if @player.in_pvp == 'true'
        return if @player.in_pvp == 'wait'
        if Player.where(in_pvp: 'wait') == []
            @player.update(in_pvp: 'wait')
            @id = nil
        else 
            @player2 = Player.select {|player| player.in_pvp == 'wait'}.first
            @pvp = Pvp.new(player1: @player, player2: @player2, rounds: 5)
            @pvp.turn = rand(1..2)
            if @pvp.save && (@player.decks.size + @player.elites.where(in_deck: true).size) == 5 && (@player2.decks.size + @player2.elites.where(in_deck: true).size) == 5
              @player.update(in_pvp: 'true')
                @player2.update(in_pvp: 'true')
                broadcast_pvp
                @id = @pvp.id
                @elite = @player.elites.where(in_deck: true).first
                PlayerCard.create(up: @elite.up, down: @elite.down, right: @elite.right, left: @elite.left, position: "9", computer: false, player: @player, name: @elite.name, pvp: true )
                @player.decks.each do |id|
                  @deck_card = Card.find(id.to_i)
                  PlayerCard.create(up: @deck_card.up, down: @deck_card.down, right: @deck_card.right, left: @deck_card.left, position: "9", computer: false, player: @player, name: @deck_card.id, pvp: true )
                end
                @elite2 = @player2.elites.where(in_deck: true).first
                PlayerCard.create(up: @elite2.up, down: @elite2.down, right: @elite2.right, left: @elite2.left, position: "9", computer: false, player: @player2, name: @elite2.name, pvp: true )
                @player2.decks.each do |id|
                  @deck_card = Card.find(id.to_i)
                  PlayerCard.create(up: @deck_card.up, down: @deck_card.down, right: @deck_card.right, left: @deck_card.left, position: "9", computer: false, player: @player2, name: @deck_card.id, pvp: true )
                end
            end
        end
        render json: {id: @id, player: @player}
    end

    def next_pvp_game
        find_pvp_player
        
        return if @pvp.nil?
        @elite = @player.elites.where(in_deck: true).first
        @elite2 = @player2.elites.where(in_deck: true).first
        if @pvp.rounds <= @pvp.player1_points || @pvp.rounds <= @pvp.player2_points
            if @pvp.player1 == @player
                @player.update(energy: (@player.energy + (@pvp.player1_points * 10)))
            elsif @pvp.player2 == @player
                @player.update(energy: (@player.energy + (@pvp.player2_points * 10)))
            end
            if @pvp.rounds <= @pvp.player1_points
              if @pvp.player1 == @player
                @player.update(elite_points: @player.elite_points + 1)
              else
                @player2.update(elite_points: @player.elite_points + 1)
              end
            end
            if @pvp.rounds <= @pvp.player2_points
              if @pvp.player2 == @player
                @player.update(elite_points: @player.elite_points + 1)
              else
                @player2.update(elite_points: @player.elite_points + 1)
              end
            end
          @pvp.destroy
          @player.player_cards.where(pvp: true).destroy_all
          @player.update(in_pvp: "false", pvp_power: false, pvp_power_point: 0)
          @player2.player_cards.where(pvp: true).destroy_all
          @player2.update(in_pvp: "false", pvp_power: false, pvp_power_point: 0)
          render json: {id: "0"}
        else
          if @pvp.finish2
            if @pvp.logs != []
              @pvp.logs.each do |attributes|
                @card_modified = PlayerCard.where(pvp: true, id: attributes['id'])
                @card_modified.update(attributes)
              end
              @pvp.update(logs: [])
            end
            @player.decks.each do |name|
              @player.player_cards.where(pvp: true).find_by(name: name).update(position: "9", computer: false)
            end
            @player.player_cards.where(pvp: true).find_by(name: @elite.name).update(position: "9", computer: false)
            @player2.decks.each do |name|
              @player2.player_cards.where(pvp: true).find_by(name: name).update(position: "9", computer: false)
            end
            @player2.player_cards.where(pvp: true).find_by(name: @elite2.name).update(position: "9", computer: false)
            @pvp.update(finish1: false)
            @pvp.update(finish2: false)
            broadcast_next
            start = rand(1..2).to_i
            @pvp.update(turn: start)
          else
            @pvp.update(finish2: true)
          end
          render json: {id: @pvp.id}
        end
      end

    def stop_pvp
      if Player.where(authentication_token: params[:token]).count == 1
        @player = Player.find_by(authentication_token: params[:token])
      end
        return if @player.in_pvp == 'true'
        @player.update(in_pvp: 'false')
        render json: {player: @player}
    end

    def find_pvp
        find_pvp_player
        @pvp = Pvp.select{|pvp| pvp.player1 == @player || pvp.player2 == @player}.first
        if !@pvp.nil?
          render json: @pvp 
        end
    end

    def find_number
        find_pvp_player
        
        if @pvp.player1 == @player
            @number = 1
            render json: @number
        end
        if @pvp.player2 == @player
            @number = 2
            render json: @number
        end
    end

    def quit_pvp
        find_pvp_player
        
        @player.player_cards.where(pvp: true).destroy_all
        @player.update(in_pvp: "false", pvp_power: false, pvp_power_point: 0)
        @player2.update(elite_points: @player2.elite_points + 1)
        @player2.update(in_pvp: "false", pvp_power: false, pvp_power_point: 0)
        @player2.player_cards.where(pvp: true).destroy_all
        @pvp.destroy
      end

    def get_pvp_score
        find_pvp_player
        
        @player_score = @player.player_cards.where(pvp: true).select {|card| card.position != "9" && card.computer == false}.count + @player2.player_cards.where(pvp: true).select {|card| card.position != "9" && card.computer == true}.count
        @opponent_score = @player2.player_cards.where(pvp: true).select {|card| card.position != "9" && card.computer == false}.count + @player.player_cards.where(pvp: true).select {|card| card.position != "9" && card.computer == true}.count
        @player_pvp_power_points = @player.pvp_power_point
        @player_pvp_power = @player.pvp_power
        @opponent_pvp_power_points = @player2.pvp_power_point
        @opponent_pvp_power = @player2.pvp_power
        render json: {player_score: @player_score, opponent_score: @opponent_score , player_pvp_power_points: @player_pvp_power_points, player_pvp_power: @player.pvp_power, opponent_pvp_power_points: @opponent_pvp_power_points, opponent_pvp_power: @opponent_pvp_power}
    end

    def win_pvp
      if Player.where(authentication_token: params[:token]).count == 1
        @player = Player.find_by(authentication_token: params[:token])
      end
      @pvp = Pvp.select{|pvp| pvp.player1_id == @player.id || pvp.player2_id == @player.id}.first
      if @pvp.player1 == @player
        @player2 = @pvp.player2
      end
      if @pvp.player2 == @player
        @player2 = @pvp.player1
      end 
        @message = ''
        if @player.player_cards.where(pvp: true, position: "9").count == 0 || @player2.player_cards.where(pvp: true, position: "9").count == 0
          if @pvp.finish1 == false && @pvp.turn == 3
            broadcast_win
            if (@player.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == false}.count + @player2.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == true}.count ) - (@player2.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == false}.count + @player.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == true}.count ) >= 2
              @message =  "You win!"
              if @pvp.player1 == @player
                  @pvp.update(player1_points: @pvp.player1_points += 1)
              end
              if @pvp.player2 == @player
                  @pvp.update(player2_points: @pvp.player2_points += 1)
              end
            elsif (@player2.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == false}.count + @player.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == true}.count )  - (@player.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == false}.count + @player2.player_cards.select {|card| card.pvp == true && card.position != "9" && card.computer == true}.count ) >= 2
              @message =  "You Lose!"
                if @pvp.player1 == @player2
                    @pvp.update(player1_points: @pvp.player1_points += 1)
                end
                if @pvp.player2 == @player2
                    @pvp.update(player2_points: @pvp.player2_points += 1)
                end
            else
              @message = "Draw!"
            end
          end
          @pvp.update(finish1: true)
        end
        render json: {message: @message}
      end

    private

    def find_pvp_player
      if Player.where(authentication_token: params[:token]).count == 1
        @player = Player.find_by(authentication_token: params[:token])
      end
      @pvp = Pvp.select{|pvp| pvp.player1_id == @player.id || pvp.player2_id == @player.id}.first
      if @pvp.player1 == @player
            @player2 = @pvp.player2
      end
      if @pvp.player2 == @player
        @player2 = @pvp.player1
      end 
    end

    def broadcast_next  
      ActionCable.server.broadcast("PvpsChannel", {id: @pvp.id, message: "next" })
    end

    def broadcast_win 
      ActionCable.server.broadcast("PvpsChannel", {id: @pvp.id, message: "win" })
    end

    def broadcast_pvp
      ActionCable.server.broadcast("PvpsChannel", {id: @player2.id, message: "pvp" })
  end
end
