class Api::V1::PlayerCardsController < ApplicationController
    before_action :set_board_position

    def update_position
        @player = Player.find_by(wallet_address: params[:address])
        return if @player.player_cards.where(position: "9").count == 0
        @card = @player.player_cards.find(params[:card_id].to_i)
        @message = ""
        @cards_updated = []
            if @player.player_cards.where(position: params[:position]) == []
                @card.update(position: params[:position])
                @board_position[@card.position.to_i] = @card
            end
            if @player.player_cards.select{|card| card.position != "9" && card != @card} != []
                result_player(@card)
            end
            render json: { message: @message, cards_updated: @cards_updated }
    end
    
    def update_computer_position
        @player = Player.find_by(wallet_address: params[:address])
        return if @player.player_cards.where(position: "9").count == 0
        @message = ""
        @cards_updated = []
        if @player.player_cards.where(computer: true, position: "9").count > 0 && @player.player_cards.where(computer: false, position: "9").count > 0
            @computer_card = computer_strat
            result_computer(@computer_card)
        end
        render json: { message: @message, cards_updated: @cards_updated }
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
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.up == card.down
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
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
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
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
            end
            if @computer_card1 && @computer_card1.right == card.left.to_i && @computer_card2.to_i && @computer_card2.up.to_i == card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
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
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
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
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.left.to_i + card.right.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card4 && @computer_card1.down.to_i + card.up.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.left.to_i + card.right.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card4 && @computer_card2.right.to_i + card.left.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card3 && @computer_card4 && @computer_card3.left.to_i + card.right.to_i == @computer_card4.up.to_i + card.down.to_i
                @computer_card3.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.left == card.right
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card4 && @computer_card4.up == card.down
                @computer_card1.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.left == card.right
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card4 && @computer_card4.up == card.down
                @computer_card2.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card3 && @computer_card3.left == card.right && @computer_card4 && @computer_card4.up == card.down
                @computer_card3.update(computer: false)
                @computer_card4.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card3.id)
                @cards_updated.push(@computer_card4.id)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
            end
            if @computer_card3 && @computer_card3.left< card.right
                @computer_card3.update(computer: false)
            end
            if @computer_card4 && @computer_card4.up< card.down
                @computer_card4.update(computer: false)
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
            end
            if @computer_card1 && @computer_card3 && @computer_card1.down.to_i + card.up.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.right.to_i + card.left.to_i == @computer_card3.up.to_i + card.down.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card2 && @computer_card2.right == card.left
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.down == card.up && @computer_card3 && @computer_card3.up == card.down
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card2.right == card.left && @computer_card3 && @computer_card3.up == card.down
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
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
            end
            if @computer_card1 && @computer_card1.left == card.right && @computer_card2 && @computer_card2.down == card.up
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
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
            end
            if @computer_card1 && @computer_card3 && @computer_card1.right.to_i + card.left.to_i == @computer_card3.down.to_i + card.up.to_i
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card3 && @computer_card2.left.to_i + card.right.to_i == @computer_card3.down.to_i + card.up.to_i
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Plus!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.left == card.right
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card3 && @computer_card3.down == card.up
                @computer_card1.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card2 && @computer_card2.left == card.right && @computer_card3 && @computer_card3.down == card.up
                @computer_card2.update(computer: false)
                @computer_card3.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card2.id)
                @cards_updated.push(@computer_card3.id)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
            end
            if @computer_card3 && @computer_card3.down< card.up
                @computer_card3.update(computer: false)
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
            end
            if @computer_card1 && @computer_card1.right == card.left && @computer_card2 && @computer_card2.down == card.up
                @computer_card1.update(computer: false)
                @computer_card2.update(computer: false)
                @message = "Same!"
                @cards_updated.push(@computer_card1.id)
                @cards_updated.push(@computer_card2.id)
            end
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
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
            end
            if @player_card1 && @player_card1.left == card.right && @player_card2 && @player_card2.up == card.down
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
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
            end
            if @player_card1 && @player_card3 && @player_card1.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
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
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.up == card.down
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
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
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
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
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.left.to_i + card.right.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card4 && @player_card1.down.to_i + card.up.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card2 && @player_card3 && @player_card2.right.to_i + card.left.to_i == @player_card3.left.to_i + card.right.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card4 && @player_card2.right.to_i + card.left.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card3 && @player_card4 && @player_card3.left.to_i + card.right.to_i == @player_card4.up.to_i + card.down.to_i
                @player_card3.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card3.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.right == card.left
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.left == card.right
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card4 && @player_card4.up == card.down
                @player_card1.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card3 && @player_card3.left == card.right
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card4 && @player_card4.up == card.down
                @player_card2.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card3 && @player_card3.left == card.right && @player_card4 && @player_card4.up == card.down
                @player_card3.update(computer: true)
                @player_card4.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card3.id)
                @cards_updated.push(@player_card4.id)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
            end
            if @player_card3 && @player_card3.left< card.right
                @player_card3.update(computer: true)
            end
            if @player_card4 && @player_card4.up< card.down
                @player_card4.update(computer: true)
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
            end
            if @player_card1 && @player_card3 && @player_card1.down.to_i + card.up.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card3 && @player_card2.right.to_i + card.left.to_i == @player_card3.up.to_i + card.down.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card2 && @player_card2.right == card.left
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.down == card.up && @player_card3 && @player_card3.up == card.down
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card2.right == card.left && @player_card3 && @player_card3.up == card.down
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
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
            end
            if @player_card1 && @player_card1.left == card.right && @player_card2 && @player_card2.down == card.up
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
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
            end
            if @player_card1 && @player_card3 && @player_card1.right.to_i + card.left.to_i == @player_card3.down.to_i + card.up.to_i
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card3 && @player_card2.left.to_i + card.right.to_i == @player_card3.down.to_i + card.up.to_i
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Plus!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.left == card.right
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.right == card.left && @player_card3 && @player_card3.down == card.up
                @player_card1.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card2 && @player_card2.left == card.right && @player_card3 && @player_card3.down == card.up
                @player_card2.update(computer: true)
                @player_card3.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card2.id)
                @cards_updated.push(@player_card3.id)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
            end
            if @player_card3 && @player_card3.down< card.up
                @player_card3.update(computer: true)
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
            end
            if @player_card1 && @player_card1.right == card.left && @player_card2 && @player_card2.down == card.up
                @player_card1.update(computer: true)
                @player_card2.update(computer: true)
                @message = "Same!"
                @cards_updated.push(@player_card1.id)
                @cards_updated.push(@player_card2.id)
            end
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
            end
        end
    end

    def player_combo
        sleep 1
        @player = Player.find_by(wallet_address: params[:address])
        card = @player.player_cards.find(params[:card_id].to_i)
        @message = ""
        if card.position == "0"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "1"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "2"
            @computer_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.up< card.down
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "3"
            @computer_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
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
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card3 && @computer_card3.left< card.right
                @computer_card3.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card4 && @computer_card4.up< card.down
                @computer_card4.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "5"
            @computer_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first  
            if @computer_card1 && @computer_card1.down < card.up
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.right< card.left
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card3 && @computer_card3.up< card.down
                @computer_card3.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "6"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == true}.first
            if @computer_card1 && @computer_card1.left < card.right
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "7"
            @computer_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == true}.first
            @computer_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == true}.first       
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.left< card.right
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card3 && @computer_card3.down< card.up
                @computer_card3.update(computer: false)
                @message = 'Combo!'
            end
        end
        if card.position == "8"
            @computer_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == true}.first
            @computer_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == true}.first
            if @computer_card1 && @computer_card1.right < card.left
                @computer_card1.update(computer: false)
                @message = 'Combo!'
            end
            if @computer_card2 && @computer_card2.down< card.up
                @computer_card2.update(computer: false)
                @message = 'Combo!'
            end
        end
        render json: { message: @message }
    end

    def computer_combo
        sleep 1
        @player = Player.find_by(wallet_address: params[:address])
        card = @player.player_cards.find(params[:card_id].to_i)
        @message = ""
        if card.position == "0"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "1"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "2"
            @player_card1 = @player.player_cards.select{|card| card.position == "1" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.up< card.down
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "3"
            @player_card1 = @player.player_cards.select{|card| card.position == "0" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
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
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card3 && @player_card3.left< card.right
                @player_card3.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card4 && @player_card4.up< card.down
                @player_card4.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "5"
            @player_card1 = @player.player_cards.select{|card| card.position == "2" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first  
            if @player_card1 && @player_card1.down < card.up
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.right< card.left
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card3 && @player_card3.up< card.down
                @player_card3.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "6"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "3" && card.computer == false}.first
            if @player_card1 && @player_card1.left < card.right
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "7"
            @player_card1 = @player.player_cards.select{|card| card.position == "6" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "8" && card.computer == false}.first
            @player_card3 = @player.player_cards.select{|card| card.position == "4" && card.computer == false}.first       
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.left< card.right
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card3 && @player_card3.down< card.up
                @player_card3.update(computer: true)
                @message = 'Combo!'
            end
        end
        if card.position == "8"
            @player_card1 = @player.player_cards.select{|card| card.position == "7" && card.computer == false}.first
            @player_card2 = @player.player_cards.select{|card| card.position == "5" && card.computer == false}.first
            if @player_card1 && @player_card1.right < card.left
                @player_card1.update(computer: true)
                @message = 'Combo!'
            end
            if @player_card2 && @player_card2.down< card.up
                @player_card2.update(computer: true)
                @message = 'Combo!'
            end
        end
        render json: { message: @message }
    end

    private

    def set_board_position
        @player = Player.find_by(wallet_address: params[:address])
        @board_position = [false,false,false,false,false,false,false,false,false]
        @player.player_cards.each do |card|
            if card.position != "9"
                @board_position[card.position.to_i] = card
            end
        end
        return @board_position
    end

    def computer_strat
        @random_computer_card = @player.player_cards.where(computer: true, position: "9").sample
        @random_computer_card.update(position: @board_position.each_index.select { |i| @board_position[i] == false }.sample)
        return @random_computer_card
    end
end
