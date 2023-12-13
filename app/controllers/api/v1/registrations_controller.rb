class Api::V1::RegistrationsController < ApplicationController
  
    def create
        @player = Player.new(player_params)
        @player.wallet_address = "--" + @player.name
    
        if @player.save
          @elite = Elite.new(up: 1, right: 1, down: 1, left: 1, rank: 'E', fight: rand(20), diplomacy: rand(20), espionage: rand(20), leadership: rand(20))
          @elite.in_deck = true if @player.elites.empty?
          @elite.player_id = @player.id
          @elite.name = "#{Faker::Creature::Animal.name} #{Faker::FunnyName.unique.name.split.first}"
          if rand(100) < 2
            @elite.potential = true
          end
          if @elite.fight == 20
            @elite.update(up: 2)
          end
          if @elite.diplomacy == 20
            @elite.update(right: 2)
          end
          if @elite.espionage == 20
            @elite.update(down: 2)
          end
          if @elite.leadership == 20
            @elite.update(left: 2)
          end
          if @elite.fight < 10 && @elite.diplomacy < 10 && @elite.espionage < 10 && @elite.leadership < 10
            @rand = rand(4)
            attributes = [:fight, :diplomacy, :espionage, :leadership]
            @elite.update(attributes[@rand] => 10)
          end
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
  