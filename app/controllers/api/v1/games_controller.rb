class Api::V1::GamesController < ApplicationController
    def create
      @player = Player.find_by(wallet_address: params[:address])
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
          start = rand(2).to_i
          if start == 0
            @random_computer_card = @player.player_cards.where(computer: true, position: "9").sample
            @random_computer_card.update(position: rand(9).to_s)
          end
          render json: @game, status: :created
        else
          @game.destroy
          render json: @game.errors, status: :unprocessable_entity
        end
      end

      def next_game
        @player = Player.find_by(wallet_address: params[:address])
        @elite = @player.elites.where(in_deck: true).first
        @game = @player.game
        if @game.rounds <= @game.player_points || @game.rounds <= @game.computer_points
        @game.destroy
        @player.player_cards.destroy_all
        @player.update(in_game: false)
        render json: {id: "0"}
        else
          @player.decks.each do |name|
            @player.player_cards.find_by(name: name).update(position: "9", computer: false)
          end
          @player.player_cards.find_by(name: @elite.name).update(position: "9", computer: false)
          @player.player_cards.select {|card| card.position != "9"}.each do |card|
            card.update(computer: true, position: "9")
          end
          render json: {id: @game.id}
        end
      end

      def quit_game
        @player = Player.find_by(wallet_address: params[:address])
        @game = @player.game
        @game.destroy
        @player.player_cards.destroy_all
        @player.update(in_game: false)
      end

      def get_score
        @player = Player.find_by(wallet_address: params[:address])
        @player_score = @player.player_cards.select {|card| card.position != "9" && card.computer == false}.count
        @computer_score = @player.player_cards.select {|card| card.position != "9" && card.computer == true}.count
        render json: {player_score: @player_score, computer_score: @computer_score }
      end

      def win
        @player = Player.find_by(wallet_address: params[:address])
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
      
end
