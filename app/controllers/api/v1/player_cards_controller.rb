class Api::V1::PlayerCardsController < ApplicationController
    before_action :set_board_position

    def update_position
        find_player
        @game = @player.game
        return if @player.player_cards.where(position: "9").count == 0
        if @game.turn == false
            update_computer_position
            render json: {message: "reload"}
        end
        @card = @player.player_cards.find(params[:card_id].to_i)
        @game.update(turn: false)
        @message = ""
        @cards_updated = []
            if @player.player_cards.where(position: params[:position]) == []
                @card.update(position: params[:position])
                @board_position[@card.position.to_i] = @card
            end
                result_player(@card)
            @game.update(turn: false)
            check_power
            render json: { message: @message, cards_updated: @cards_updated }
    end
    
    def update_computer_position
        find_player
        @game = @player.game
        sleep 1
        return if @player.player_cards.where(position: "9").count == 0
        if @game.turn == true
            render json: {message: "reload"}
        end
        @message = ""
        @cards_updated = []
        if @game.turn != true 
            if @player.player_cards.where(computer: true, position: "9").count > 0 && @player.player_cards.where(computer: false, position: "9").count > 0
                @computer_card = computer_strat
                result_computer(@computer_card)
            end
        end
        @game.update(turn: true)
        check_power
        render json: { message: @message, cards_updated: @cards_updated }
    end

    def check_power
        if @player.power_point >= 10 && @player.power == false
            @player.update(power: true)
        elsif @player.computer_power_point >= 10 && @player.computer_power == false
            @player.update(computer_power: true)
        end
    end

    def super_power
        find_player
        return if @player.player_cards.where(position: '9').count <= 1
        @cards = @player.player_cards
        @player.update(power: false, power_point: 0)
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
                @card = @cards.select{|card| card.position == "9" && card.computer == true }.sample
                logs
                @rand = rand(4)
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i - 1).to_s)
            end
            if @player.ability.last == "2"
                @card = @cards.select{|card| card.position == "9" && card.computer == true }.sample
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
                @card = @cards.select{|card| card.position == "9" && card.computer == true && card.hide == true }.sample
                if @card
                    @card.update(hide: false)
                end
            end
            if @player.ability.last == "2"
                @card = @cards.select{|card| card.position == "9" && card.computer == true && card.hide == true }.sample
                if @card
                    @card.update(hide: false)
                end
                if @player.computer_power_point >= 1
                    @player.update(computer_power: false, computer_power_point: @player.computer_power_point - 1)
                elsif @player.computer_power_point >= 10
                    @player.update(computer_power: false, computer_power_point: 9)
                end
            end
        end
        if @player.ability.include?("leadership")
            if @player.ability.last == "1"
                @card = @cards.select{|card| card.computer == true && card.position != '9' }.sample
                @card2 = @cards.select{|card| card.computer == true && card != @card }.sample
                if @card
                    logs
                    @rand = rand(4)
                    attributes = [:up, :right, :down, :left]
                    @card.update(attributes[@rand] => @card2[attributes[@rand]])
                end
            end
            if @player.ability.last == "2"
                @card = @cards.select{|card| card.computer == true && card.position != '9' }.sample
                @card2 = @cards.select{|card| card.computer == true && card != @card }.sample
                @card3 = @cards.select{|card| card.computer == true && card != @card }.sample
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

    def computer_super_power
        find_player
        return if @player.player_cards.where(position: '9').count <= 1
        @cards = @player.player_cards
        @player.update(computer_power: false, computer_power_point: 0)
        if @player.computer_ability.include?("fight")
            if @player.computer_ability.last == "1"
                @card = @cards.select{|card| card.position == "9" && card.computer == true }.sample
                logs
                @rand = rand(4)
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i + 1).to_s)
            end
        end
        if @player.computer_ability.include?("diplomacy")
            if @player.computer_ability.last == "1"
                @card = @cards.select{|card| card.position == "9" && card.computer == false }.sample
                logs
                @rand = rand(4)
                attributes = [:up, :right, :down, :left]
                @card.update(attributes[@rand] => (@card.send(attributes[@rand]).to_i - 1).to_s)
            end
        end
        if @player.ability.include?("espionage")
            if @player.ability.last == "1"
                @card = @cards.select{|card| card.position == "9" && card.computer == false && card.hide == true }.sample
                if @card
                    @card.update(hide: false)
                end
            end
        end
        computer_strat
    end

    def logs
        original_attributes = {
            id: @card.id,
            up: @card.up,
            right: @card.right,
            down: @card.down,
            left: @card.left}
        @player.game.update(logs: @player.game.logs.push(original_attributes))
    end

    def board_position
        render json: @board_position
    end

    def result_player(card)
        if card.position == "0"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.left.to_i + card.right.to_i == @computer_card2.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.up == card.down
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "1"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.left.to_i + card.right.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "2"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.up == card.down
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "3"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            if @computer_card1 && @computer_card2 &&  @computer_card1.down.to_i + card.up.to_i == @computer_card2.left.to_i + card.right.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "4"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            @computer_card4 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.down.to_i + card.up.to_i == @computer_card2.right.to_i + card.left.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.left.to_i + card.right.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card4 && @computer_card1.down.to_i + card.up.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.left.to_i + card.right.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card4 && @computer_card2.right.to_i + card.left.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card3 && @computer_card4 && @computer_card3.left.to_i + card.right.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card3.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.left == card.right
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card4 && @computer_card4.up == card.down
                @computer_card1.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.left == card.right
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card4 && @computer_card4.up == card.down
                @computer_card2.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card3 && @computer_card3.left == card.right && @computer_card4 && @computer_card4.up == card.down
                @computer_card3.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card3 && @computer_card3.left< card.right
                @computer_card3.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card4 && @computer_card4.up< card.down
                @computer_card4.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "5"
            @computer_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.down.to_i + card.up.to_i == @computer_card2.right.to_i + card.left.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "6"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.left.to_i + card.right.to_i == @computer_card2.down.to_i + card.up.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.down == card.up
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "7"
            @computer_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.left.to_i + card.right.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.down.to_i + card.up.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.down.to_i + card.up.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.down == card.up
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.down == card.up
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card3 && @computer_card3.down< card.up
                @computer_card3.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
        if card.position == "8"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card2 && @computer_card1.right.to_i + card.left.to_i == @computer_card2.down.to_i + card.up.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.down == card.up
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
                @player.update(power_point: @player.power_point + 3)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @player.update(power_point: @player.power_point + 1)
            end
        end
    end

    def result_computer(card)
        if card.position == "0"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.left.to_i + card.right.to_i == @player_card2.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.left == card.right && @player_card2 && @player_card2.up == card.down
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "1"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.right.to_i + card.left.to_i == @player_card2.left.to_i + card.right.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card3 && @player_card1.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "2"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.right.to_i + card.left.to_i == @player_card2.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.up == card.down
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "3"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @player_card1 && @player_card2 &&  @player_card1.down.to_i + card.up.to_i == @player_card2.left.to_i + card.right.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "4"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            @player_card4 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.down.to_i + card.up.to_i == @player_card2.right.to_i + card.left.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.left.to_i + card.right.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card4 && @player_card1.down.to_i + card.up.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card3 && @player_card2.right.to_i + card.left.to_i == @player_card3.left.to_i + card.right.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card4 && @player_card2.right.to_i + card.left.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card3 && @player_card4 && @player_card3.left.to_i + card.right.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card3.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card3.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.right == card.left
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.left == card.right
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card4 && @player_card4.up == card.down
                @player_card1.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card3 && @player_card3.left == card.right
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card4 && @player_card4.up == card.down
                @player_card2.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card3 && @player_card3.left == card.right && @player_card4 && @player_card4.up == card.down
                @player_card3.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card3.id)
                @cards_updated.push(@player_card4.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card3 && @player_card3.left< card.right
                @player_card3.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card4 && @player_card4.up< card.down
                @player_card4.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "5"
            @player_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.down.to_i + card.up.to_i == @player_card2.right.to_i + card.left.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card3 && @player_card2.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.right == card.left
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "6"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.left.to_i + card.right.to_i == @player_card2.down.to_i + card.up.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.left == card.right && @player_card2 && @player_card2.down == card.up
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "7"
            @player_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.right.to_i + card.left.to_i == @player_card2.left.to_i + card.right.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card3 && @player_card1.right.to_i + card.left.to_i == @player_card3.down.to_i + card.up.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.down.to_i + card.up.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card3 && @player_card3.down == card.up
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.down == card.up
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card3 && @player_card3.down< card.up
                @player_card3.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
        if card.position == "8"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card2 && @player_card1.right.to_i + card.left.to_i == @player_card2.down.to_i + card.up.to_i
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.down == card.up
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
                @player.update(computer_power_point: @player.computer_power_point + 3)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @player.update(computer_power_point: @player.computer_power_point + 1)
            end
        end
    end

    def player_combo
        sleep 1
        find_player
        card = @player.player_cards.find(params[:card_id].to_i)
        @message = ""
        if card.position == "0"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "1"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "2"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "3"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "4"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            @computer_card4 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card3 && @computer_card3.left< card.right
                @computer_card3.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card4 && @computer_card4.up< card.down
                @computer_card4.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "5"
            @computer_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first  
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "6"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "7"
            @computer_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first       
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card3 && @computer_card3.down< card.up
                @computer_card3.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        if card.position == "8"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @message = 'Combo!'
                @player.update(power_point: @player.power_point + 2)
            end
        end
        render json: { message: @message }
    end

    def computer_combo
        sleep 1
        find_player
        card = @player.player_cards.find(params[:card_id].to_i)
        @message = ""
        if card.position == "0"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "1"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "2"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "3"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "4"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            @player_card4 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card3 && @player_card3.left< card.right
                @player_card3.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card4 && @player_card4.up< card.down
                @player_card4.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "5"
            @player_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first  
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "6"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "7"
            @player_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first       
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card3 && @player_card3.down< card.up
                @player_card3.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        if card.position == "8"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @message = 'Combo!'
                @player.update(computer_power_point: @player.computer_power_point + 2)
            end
        end
        render json: { message: @message }
    end

    private

    def set_board_position
        find_player
        @board_position = [false,false,false,false,false,false,false,false,false]
        @player.player_cards.each do |card|
            if card.position != "9"
                @board_position[card.position.to_i] = card
            end
        end
        return @board_position
    end

    def computer_strat
        @random = {up: nil,right: nil, down: nil, left: nil}
        @player_cards_in_game = @player.player_cards.where(computer: false).where.not(position: "9")
        @computer_decks = @player.player_cards.where(computer: true, position: "9")
        if @player_cards_in_game.count >= 2
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card2
                @computer_decks.each do |card|
                    if @player_card1.left.to_i + card.right.to_i == @player_card2.up.to_i + card.down.to_i && @player.player_cards.where(position: "0") == []
                        card.update(position: "0")
                        return card
                    end
                end
            end
            if @player_card1 && @player_card2 
                @computer_decks.each do |card|
                    if @player_card1.left == card.right && @player_card2.up == card.down && @player.player_cards.where(position: "0") == []
                        card.update(position: "0")
                        return card
                    end
                end
            end
                @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
                @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.right.to_i + card.left.to_i == @player_card2.left.to_i + card.right.to_i && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end               
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2 
                    @computer_decks.each do |card|
                        if @player_card1.right == card.left && @player_card2.left == card.right && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.right == card.left && @player_card3.up == card.down && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.left == card.right && @player_card3.up == card.down && @player.player_cards.where(position: "1") == []
                            card.update(position: "1")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.right.to_i + card.left.to_i == @player_card2.up.to_i + card.down.to_i && @player.player_cards.where(position: "2") == []
                            card.update(position: "2")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2 
                    @computer_decks.each do |card|
                        if @player_card1.right == card.left && @player_card2.up == card.down && @player.player_cards.where(position: "2") == []
                            card.update(position: "2")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
                @player_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card2.left.to_i + card.right.to_i && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.down == card.up && @player_card2.left == card.right && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.down == card.up && @player_card3.up == card.down && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.left == card.right && @player_card3.up == card.down && @player.player_cards.where(position: "3") == []
                            card.update(position: "3")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
                @player_card3 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
                @player_card4 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card2.right.to_i + card.left.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card3.left.to_i + card.right.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card4.up.to_i + card.down.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.right.to_i + card.left.to_i == @player_card3.left.to_i + card.right.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card2.right.to_i + card.left.to_i == @player_card4.up.to_i + card.down.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card3 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card3.left.to_i + card.right.to_i == @player_card4.up.to_i + card.down.to_i && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.down == card.up && @player_card2.right == card.left && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.down == card.up && @player_card3.left == card.right && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card1.down == card.up && @player_card4 && @player_card4.up == card.down && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card2.right == card.left && @player_card3.left == card.right && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card2.right == card.left && @player_card4 && @player_card4.up == card.down && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                if @player_card3 && @player_card4
                    @computer_decks.each do |card|
                        if @player_card3.left == card.right && @player_card4 && @player_card4.up == card.down && @player.player_cards.where(position: "4") == []
                            card.update(position: "4")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
                @player_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card2.right.to_i + card.left.to_i && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card2.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.down == card.up && @player_card2.right == card.left && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card1.down == card.up && @player_card3.up == card.down && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card2.right == card.left && @player_card3 && @player_card3.up == card.down && @player.player_cards.where(position: "5") == []
                            card.update(position: "5")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.left.to_i + card.right.to_i == @player_card2.down.to_i + card.up.to_i && @player.player_cards.where(position: "6") == []
                            card.update(position: "6")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.left == card.right && @player_card2.down == card.up && @player.player_cards.where(position: "6") == []
                            card.update(position: "6")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
                @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.right.to_i + card.left.to_i == @player_card2.left.to_i + card.right.to_i && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card1.right.to_i + card.left.to_i == @player_card3.down.to_i + card.up.to_i && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card2.left.to_i + card.right.to_i == @player_card3.down.to_i + card.up.to_i && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.right == card.left && @player_card2.left == card.right && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card3
                    @computer_decks.each do |card|
                        if  @player_card1.right == card.left && @player_card3.down == card.up && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                if @player_card2 && @player_card3
                    @computer_decks.each do |card|
                        if   @player_card2.left == card.right && @player_card3.down == card.up && @player.player_cards.where(position: "7") == []
                            card.update(position: "7")
                            return card
                        end
                    end
                end
                @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
                @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if  @player_card1.right.to_i + card.left.to_i == @player_card2.down.to_i + card.up.to_i && @player.player_cards.where(position: "8") == []
                            card.update(position: "8")
                            return card
                        end
                    end
                end
                if @player_card1 && @player_card2
                    @computer_decks.each do |card|
                        if   @player_card1.right == card.left && @player_card2 && @player_card2.down == card.up && @player.player_cards.where(position: "8") == []
                            card.update(position: "8")
                            return card
                        end
                    end
                end
        end

        if @player.computer_power
           return computer_super_power
        end
        @up_card = @player.player_cards.where(computer: true, position: "9").order(up: :desc).first
        @player_up_cards = @player_cards_in_game.select{|card| card.down.to_i < @up_card.up.to_i}
        @player_up_cards.each do |card|
            if card.position.to_i >= 0 && card.position.to_i <= 5 && @player.player_cards.find_by(position: (card.position.to_i + 3).to_s) == nil
                @random[:up] = (card.position.to_i + 3).to_s
            end
        end
        @right_card = @player.player_cards.where(computer: true, position: "9").order(right: :desc).first
        @player_right_cards = @player_cards_in_game.select{|card| card.left.to_i < @right_card.right.to_i}
        @player_right_cards.each do |card|
            if card.position.to_i >= 1 && card.position.to_i <= 8 && @player.player_cards.find_by(position: (card.position.to_i - 1).to_s) == nil
                @random[:right] = (card.position.to_i - 1).to_s
            end
        end
        @down_card = @player.player_cards.where(computer: true, position: "9").order(down: :desc).first
        @player_down_cards = @player_cards_in_game.select{|card| card.up.to_i < @down_card.down.to_i}
        @player_down_cards.each do |card|
            if card.position.to_i >= 3 && card.position.to_i <= 8 && @player.player_cards.find_by(position: (card.position.to_i - 3).to_s) == nil
                @random[:down] = (card.position.to_i - 3).to_s
            end
        end
        @left_card = @player.player_cards.where(computer: true, position: "9").order(left: :desc).first
        @player_left_cards = @player_cards_in_game.select{|card| card.right.to_i < @left_card.left.to_i}
        @player_left_cards.each do |card|
            if card.position.to_i >= 0 && card.position.to_i <= 7 && @player.player_cards.find_by(position: (card.position.to_i + 1).to_s) == nil
                @random[:left] = (card.position.to_i + 1).to_s
            end
        end

        @random_key = @random.select { |key, value| !value.nil? }.keys.sample
        start = rand(2).to_i
        if !@random.values.all?(&:nil?) && start == 0
            if @random_key === :up
                @up_card.update(position: @random[:up])
                return @up_card
            end
            if @random_key === :right
                @right_card.update(position: @random[:right])
                return @right_card
            end
            if @random_key === :down
                @down_card.update(position: @random[:down])
                return @down_card
            end
            if @random_key === :left
                @left_card.update(position: @random[:left])
                return @left_card
            end
        else
            if @player.computer_power
                computer_super_power
            end
            @random_computer_card = @player.player_cards.where(computer: true, position: "9").sample
            @random_computer_card.update(position: @board_position.each_index.select { |i| @board_position[i] == false }.sample)
            return @random_computer_card
        end



    end

    def find_player
        if Player.where(authentication_token: params[:token]).count == 1
          @player = Player.find_by(authentication_token: params[:token])
        end
    end
end
