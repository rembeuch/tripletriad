class Api::V1::GamesController < ApplicationController
    def create
      find_player
      return if @player.game != nil
        @game = Game.new
        @game.player = @player
        @game.rounds = params[:rounds]
        if @game.save && @player.in_game == false && (@player.decks.size + @player.elites.where(in_deck: true).size) == 5
          @player.update(in_game: true)
          @elite = @player.elites.where(in_deck: true).first
          PlayerCard.create(up: @elite.up, down: @elite.down, right: @elite.right, left: @elite.left, position: "9", computer: false, player: @player, name: @elite.name )
          @player.decks.each do |id|
            @deck_card = Card.find(id.to_i)
            PlayerCard.create(up: @deck_card.up, down: @deck_card.down, right: @deck_card.right, left: @deck_card.left, position: "9", computer: false, player: @player, name: @deck_card.id )
          end
          5.times do
            @computer_card = Card.all.sample
            PlayerCard.create(up: @computer_card.up, down: @computer_card.down, right: @computer_card.right, left: @computer_card.left, position: "9", computer: true, player: @player, name: @computer_card.id )
          end
          @player.update(computer_ability: @player.ability)
          start = rand(2).to_i
          if start == 0
            @random_computer_card = @player.player_cards.where(computer: true, position: "9").sample
            @random_computer_card.update(position: rand(9).to_s)
          end
          @game.update(turn: true)
          render json: @game, status: :created
        else
          @game.destroy
          render json: @game.errors, status: :unprocessable_entity
        end
      end

      def next_game
        find_player
        @elite = @player.elites.where(in_deck: true).first
        @game = @player.game
        if @game.rounds <= @game.player_points || @game.rounds <= @game.computer_points
        @game.destroy
        @player.player_cards.destroy_all
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0)
        render json: {id: "0"}
        else
          if @game.logs != []
            @game.logs.each do |attributes|
              @card_modified = @player.player_cards.where(id: attributes['id'])
              @card_modified.update(attributes)
            end
            @game.update(logs: [])
          end
          @player.decks.each do |name|
            @player.player_cards.find_by(name: name).update(position: "9", computer: false)
          end
          @player.player_cards.find_by(name: @elite.name).update(position: "9", computer: false)
          @player.player_cards.select {|card| card.position != "9"}.each do |card|
            card.update(computer: true, position: "9")
          end
          start = rand(2).to_i
          if start == 0
            @random_computer_card = @player.player_cards.where(computer: true, position: "9").sample
            @random_computer_card.update(position: rand(9).to_s)
          end
          @game.update(turn: true)
          render json: {id: @game.id}
        end
      end

      def quit_game
        find_player
        @game = @player.game
        @game.destroy
        @player.player_cards.destroy_all
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0)
      end

      def get_score
        find_player
        @player_score = @player.player_cards.select {|card| card.position != "9" && card.computer == false}.count
        @computer_score = @player.player_cards.select {|card| card.position != "9" && card.computer == true}.count
        @player_power_points = @player.power_point
        @player_power = @player.power
        @player_computer_power_point = @player.computer_power_point
        @player_computer_power = @player.computer_power
        render json: {player_score: @player_score, computer_score: @computer_score , player_power_points: @player_power_points, player_power: @player.power, player_computer_power_points: @player_computer_power_point, player_computer_power: @player.computer_power}
      end

      def win
        find_player
        @game = @player.game
        @message = ''
        if @player.player_cards.where(position: "9").count <= 1 
          if @player.player_cards.select {|card| card.position != "9" && card.computer == false}.count - @player.player_cards.select {|card| card.position != "9" && card.computer == true}.count >= 2
           @message =  "You win!"
           @game.update(player_points: @game.player_points += 1)
          elsif @player.player_cards.select {|card| card.position != "9" && card.computer == true}.count - @player.player_cards.select {|card| card.position != "9" && card.computer == false}.count >= 2
           @message =  "You Lose!"
           @game.update(computer_points: @game.computer_points += 1)
          else
           @message = "Draw!"
          end
        end
        render json: {message: @message}
      end

      def find_player
        if Player.where(authentication_token: params[:token]).count == 1
          @player = Player.find_by(authentication_token: params[:token])
        elsif Player.where(wallet_address: params[:address]).count == 1
          @player = Player.find_by(wallet_address: params[:address])
        end
    end
end
