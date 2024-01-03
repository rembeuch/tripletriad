class Api::V1::PvpCardsController < ApplicationController
    before_action :set_pvp_board_position
    after_action :broadcast_message, only: [:check_power]

    def update_pvp_position
        find_player
        find_player2
        return if @player_cards.where(position: "9").count == 0
        if @pvp.turn == 1 && @pvp.player2 == @player
            return
        elsif @pvp.turn == 2 && @pvp.player1 == @player
            return
        end
        @card = @player_cards.find(params[:card_id].to_i)
        if @pvp.turn == 1 && @pvp.player1 == @player
            @pvp.update(turn: 2)
        elsif @pvp.turn == 2 && @pvp.player2 == @player
            @pvp.update(turn: 1)
        end
        @message = ""
        @cards_updated = []
        if @player_cards.where(position: params[:position]) == []
            @card.update(position: params[:position])
            @board_position[@card.position.to_i] = @card
        end
        result_pvp_player(@card)
        @cards_updated.uniq.each do |id|
            PlayerCard.find(id).update(computer: !PlayerCard.find(id).computer)
        end
        check_power
        render json: { message: @message, cards_updated: @cards_updated }
    end

    def check_power
        if @player.pvp_power_point >= 10 && @player.pvp_power == false
            @player.update(pvp_power: true)
        end
    end

    def pvp_super_power
        find_player
        find_player2
        return if @player_cards.where(position: '9').count <= 1
        @cards = @player_cards
        @player.update(pvp_power: false, pvp_power_point: 0)
        if @player.ability.include?("fight")
            if @player.ability.last == "1"
                @card = @cards.select{|card| card.position == "9" && card.computer == false }.sample
                logs
                @rand = rand(4)
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i + 1).to_s)
            end
            if @player.ability.last == "2"
                @card = @cards.select{|card| card.position == "9" && card.computer == false }.sample
                logs
                @rand = rand(4)
                loop do
                    @rand2 = rand(4)
                    break if @rand2 != @rand
                end
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i + 1).to_s)
                @card.update(attributes[@rand2] => (@card.send(attributes[@rand2]).to_i + 1).to_s)
            end
        end
        if @player.ability.include?("diplomacy")
            if @player.ability.last == "1"
                @card = @opponent_cards.select{|card| card.position == "9" && card.computer == false }.sample
                logs
                @rand = rand(4)
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i - 1).to_s)
            end
            if @player.ability.last == "2"
                @card = @opponent_cards.select{|card| card.position == "9" && card.computer == false }.sample
                logs
                @rand = rand(4)
                loop do
                    @rand2 = rand(4)
                    break if @rand2 != @rand
                end
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i - 1).to_s)
                @card.update(attributes[@rand2] => (@card.send(attributes[@rand2]).to_i - 1).to_s)
            end
        end
        if @player.ability.include?("espionage")
            if @player.ability.last == "1"
                @card = @opponent_cards.select{|card| card.position == "9" && card.computer == false && card.hide == true }.sample
                if @card
                    @card.update(hide: false)
                end
            end
            if @player.ability.last == "2"
                @card = @opponent_cards.select{|card| card.position == "9" && card.computer == false && card.hide == true }.sample
                if @card
                    @card.update(hide: false)
                end
                if @player2.pvp_power_point >= 1
                    @player2.update(pvp_power: false, pvp_power_point: @player2.pvp_power_point - 1)
                elsif @player2.pvp_power_point >= 10
                    @player2.update(pvp_power: false, pvp_power_point: 9)
                end
            end
        end
        if @player.ability.include?("leadership")
            if @player.ability.last == "1"
                @card = @opponent_cards.select{|card| card.computer == false && card.position != '9' }.sample
                @card2 = @opponent_cards.select{|card| card.computer == false && card != @card }.sample
                if @card
                    logs
                    @rand = rand(4)
                    attributes = [:up, :right, :down, :left]
                    @card.update(attributes[@rand] => @card2[attributes[@rand]])
                end
            end
            if @player.ability.last == "2"
                @card = @opponent_cards.select{|card| card.computer == false && card.position != '9' }.sample
                @card2 = @opponent_cards.select{|card| card.computer == false && card != @card }.sample
                @card3 = @opponent_cards.select{|card| card.computer == false && card != @card }.sample
                if @card
                    logs
                    @rand = rand(4)
                    loop do
                        @rand2 = rand(4)
                        break if @rand2 != @rand
                    end
                    attributes = [:up, :right, :down, :left]
                    @card.update(attributes[@rand] => @card2[attributes[@rand]])
                    @card.update(attributes[@rand2] => @card3[attributes[@rand2]])
                end
            end
        end
    end

    def logs
        original_attributes = {
            id: @card.id,
            up: @card.up,
            right: @card.right,
            down: @card.down,
            left: @card.left}
        @pvp.update(logs: @pvp.logs.push(original_attributes))
    end

    def pvp_board_position
        render json: @board_position
    end

    def result_pvp_player(card)
        if card.position == "0"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.left.to_i + card.right.to_i == @computer_card2.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.left < card.right && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.up < card.down && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "1"
            @computer_card1 = @opponent_cards.select{|card| card.position == "0" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "0" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "2" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "2" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.left.to_i + card.right.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down && !@cards_updated.include?(@computer_card3.id)
                @computer_card3.update(computer: !@computer_card3.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "2"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.up.to_i + card.down.to_i 
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.up< card.down && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "3"
            @computer_card1 = @opponent_cards.select{|card| card.position == "0" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "0" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "6" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 &&  @computer_card1.down.to_i + card.up.to_i == @computer_card2.left.to_i + card.right.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.left == card.right
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down && !@cards_updated.include?(@computer_card3.id)
                @computer_card3.update(computer: !@computer_card3.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "4"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            @computer_card4 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card4.nil?
                @computer_card4 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.down.to_i + card.up.to_i == @computer_card2.right.to_i + card.left.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.left.to_i + card.right.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card4 && @computer_card1.down.to_i + card.up.to_i == @computer_card4.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.left.to_i + card.right.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card4 && @computer_card2.right.to_i + card.left.to_i == @computer_card4.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card3 && @computer_card4 && @computer_card3.left.to_i + card.right.to_i == @computer_card4.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.left == card.right
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card4 && @computer_card4.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.left == card.right
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card4 && @computer_card4.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card3 && @computer_card3.left == card.right && @computer_card4 && @computer_card4.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.right< card.left && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card3 && @computer_card3.left< card.right && !@cards_updated.include?(@computer_card3.id)
                @computer_card3.update(computer: !@computer_card3.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card4 && @computer_card4.up< card.down && !@cards_updated.include?(@computer_card4.id)
                @computer_card4.update(computer: !@computer_card4.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "5"
            @computer_card1 = @opponent_cards.select{|card| card.position == "2" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "2" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "8" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "8" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.down.to_i + card.up.to_i == @computer_card2.right.to_i + card.left.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.right< card.left && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down && !@cards_updated.include?(@computer_card3.id)
                @computer_card3.update(computer: !@computer_card3.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "6"
            @computer_card1 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.left.to_i + card.right.to_i == @computer_card2.down.to_i + card.up.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.down == card.up
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.left < card.right && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.down< card.up && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "7"
            @computer_card1 = @opponent_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "6" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "8" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "8" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.left.to_i + card.right.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.down.to_i + card.up.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.down.to_i + card.up.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.down == card.up
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.down == card.up
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card3 && @computer_card3.down< card.up && !@cards_updated.include?(@computer_card3.id)
                @computer_card3.update(computer: !@computer_card3.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
        if card.position == "8"
            @computer_card1 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.down.to_i + card.up.to_i
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.down == card.up
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(pvp_power_point: @player.pvp_power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left && !@cards_updated.include?(@computer_card1.id)
                @computer_card1.update(computer: !@computer_card1.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
            if @computer_card2 && @computer_card2.down< card.up && !@cards_updated.include?(@computer_card2.id)
                @computer_card2.update(computer: !@computer_card2.computer)
                @player.update(pvp_power_point: @player.pvp_power_point + 1)
            end
        end
    end

    def pvp_player_combo
        sleep 1
        find_player
        find_player2
        card = @all_cards.select {|card| card.id == params[:card_id].to_i}.first
        @message = ""
        if card.position == "0"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "1"
            @computer_card1 = @opponent_cards.select{|card| card.position == "0" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "0" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "2" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "2" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: !@computer_card3.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "2"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "3"
            @computer_card1 = @opponent_cards.select{|card| card.position == "0" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "0" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "6" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: !@computer_card3.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "4"
            @computer_card1 = @opponent_cards.select{|card| card.position == "1" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "1" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            @computer_card4 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card4.nil?
                @computer_card4 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card3 && @computer_card3.left< card.right
                @computer_card3.update(computer: !@computer_card3.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card4 && @computer_card4.up< card.down
                @computer_card4.update(computer: !@computer_card4.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "5"
            @computer_card1 = @opponent_cards.select{|card| card.position == "2" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "2" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "8" && card.computer == false}.first  
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "8" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: !@computer_card3.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "6"
            @computer_card1 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "3" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "7"
            @computer_card1 = @opponent_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "6" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "8" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "8" && card.computer == true}.first
            end
            @computer_card3 = @opponent_cards.select{|card| card.position == "4" && card.computer == false}.first 
            if @computer_card3.nil?
                @computer_card3 = @player_cards.select{|card| card.position == "4" && card.computer == true}.first
            end      
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card3 && @computer_card3.down< card.up
                @computer_card3.update(computer: !@computer_card3.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        if card.position == "8"
            @computer_card1 = @opponent_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @computer_card1.nil?
                @computer_card1 = @player_cards.select{|card| card.position == "7" && card.computer == true}.first
            end
            @computer_card2 = @opponent_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @computer_card2.nil?
                @computer_card2 = @player_cards.select{|card| card.position == "5" && card.computer == true}.first
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: !@computer_card1.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: !@computer_card2.computer)
                @message = 'Combo!'
                @player.update(pvp_power_point: @player.pvp_power_point + 2)
            end
        end
        render json: { message: @message }
    end

    private

    def set_pvp_board_position
        find_player
        find_player2
        @board_position = [false,false,false,false,false,false,false,false,false]
        @player_cards.each do |card|
            if card.position != "9"
                @board_position[card.position.to_i] = card
            end
        end
        @opponent_cards.each do |card|
            if card.position != "9"
                @board_position[card.position.to_i] = card
            end
        end
        return @board_position
    end

    def find_player
        if Player.where(authentication_token: params[:token]).count == 1
          @player = Player.find_by(authentication_token: params[:token])
          @player_cards = @player.player_cards.where(pvp: true)
        end
    end

    def find_player2
        @pvp = Pvp.select{|pvp| pvp.player1 == @player || pvp.player2 == @player}.first
        if @pvp.player1 == @player
            @player2 = @pvp.player2
            @opponent_cards = @player2.player_cards.where(pvp: true)
        end
        if @pvp.player2 == @player
            @player2 = @pvp.player1
            @opponent_cards = @player2.player_cards.where(pvp: true)
        end
        @all_cards = @player_cards + @opponent_cards
    end

    def broadcast_message
        ActionCable.server.broadcast("PvpsChannel", @pvp.id)
    end
end