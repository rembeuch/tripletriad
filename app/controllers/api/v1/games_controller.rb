class Api::V1::GamesController < ApplicationController
    def create
      @player = Player.find_by(wallet_address: params[:address])
      return if @player.game != nil
        @game = Game.new
        @game.player = @player
        if @game.save && @player.in_game == false && @player.decks.size == 5
          @player.update(in_game: true)
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
          render json: @game.errors, status: :unprocessable_entity
        end
      end

      def quit_game
        @player = Player.find_by(wallet_address: params[:address])
        @player.game.destroy
        @player.player_cards.destroy_all
        @player.update(in_game: false)
        render json: @player
      end
      
end
