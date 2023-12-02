class Api::V1::ElitesController < ApplicationController
    def index
        find_player
        @elites = @player.elites
        render json: @elites
    end

    def create
        find_player
        @elite = Elite.new(up: 1, right: 1, down: 1, left: 1, rank: 'E')
        @elite.in_deck = true if @player.elites.empty?
        @elite.player_id = @player.id
        @elite.name = "#{Faker::Creature::Animal.name} #{Faker::FunnyName.unique.name.split.first}"
        if @elite.save
            render json: @player.elites
        else
            render json: @elite.errors, status: :unprocessable_entity
        end
    end

    def find_player
        if Player.where(authentication_token: params[:token]).count == 1
          @player = Player.find_by(authentication_token: params[:token])
        elsif Player.where(wallet_address: params[:address]).count == 1
          @player = Player.find_by(wallet_address: params[:address])
        end
      end
      
end
