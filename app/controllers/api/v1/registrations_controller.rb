class Api::V1::RegistrationsController < ApplicationController
  
    def create
        @message = nil
        @player = Player.new(player_params)
        @player.wallet_address = "--" + @player.name
        @player.zones.push("A1")
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
          @power = [:fight, :diplomacy, :espionage, :leadership].max_by { |column| @elite.send(column) }.to_s + "1"
          @player.update(ability: @power)
          Monster.first(4).each do |monster|
            Card.create(up: monster.up, down: monster.down, right: monster.right, left: monster.left, player: @player, name: monster.name, rank: monster.rank, up_points: 0, right_points: 0, down_points: 0, left_points: 0 )
          end
          render json: { player: @player, token: @player.authentication_token }, status: :created
        else
          if Player.find_by(email: @player.email) != nil
            @message = "Email already use"
          end
          if Player.find_by(name: @player.name) != nil
            @message = "Name already use"
          end
            render json: {message: @message}
        end
      end
    
  
    private
  
    def player_params
      params.require(:player).permit(:email, :password, :password_confirmation, :name, :wallet_address)
    end
  end
  