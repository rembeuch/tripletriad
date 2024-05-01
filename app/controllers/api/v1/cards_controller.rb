class Api::V1::CardsController < ApplicationController
    def index
      find_player
      @cards = @player.cards.sort_by { |card| card.name.delete("#").to_i }
      render json: @cards
    end

    def show
      find_player
      @monster = Card.find(params[:id])
      if @monster.player == @player
        render json: {monster: @monster}
      end
    end

    def increment_card
        find_player
        return if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait'
        @card = Card.find(params[:id])
        attributes = [:up_points, :right_points, :down_points, :left_points]
        if @card.player == @player && @card.copy > 0 && @player.energy >= (@card.send(attributes[params[:stat].to_i]) * 100)
            @card.update(copy: @card.copy - 1)
            @player.update(energy: @player.energy - (@card.send(attributes[params[:stat].to_i]) * 100))
            @card.update(attributes[params[:stat].to_i] => (@card.send(attributes[params[:stat].to_i]) + 1))
            if @card.send(attributes[params[:stat].to_i]) == 30
                modified_attributes = attributes.map { |attribute| attribute.to_s.chomp('_points').to_sym }
                @card.update(modified_attributes[params[:stat].to_i] => (@card.send(modified_attributes[params[:stat].to_i]).to_i + 1).to_s)
                @player.update(elite_points: @player.elite_points + 1)
            end
            render json: {monster: @card}
        else 
            render json: {monster: @card}
        end
    end

    private

    def find_player
        if Player.where(authentication_token: params[:token]).count == 1
          @player = Player.find_by(authentication_token: params[:token])
        end
      end
end
