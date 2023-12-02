class Api::V1::RegistrationsController < ApplicationController
  
    def create
        @player = Player.new(player_params)
        @player.wallet_address = "--" + @player.name
    
        if @player.save
          @elite = Elite.new(up: 1, right: 1, down: 1, left: 1, rank: 'E')
          @elite.in_deck = true if @player.elites.empty?
          @elite.player_id = @player.id
          @elite.name = "#{Faker::Creature::Animal.name} #{Faker::FunnyName.unique.name.split.first}"
          @elite.save
          render json: { player: @player, token: @player.authentication_token }, status: :created
        else
          render json: @player.errors, status: :unprocessable_entity
        end
      end
    
  
    private
  
    def player_params
      params.require(:player).permit(:email, :password, :password_confirmation, :name, :wallet_address)
    end
  end
  