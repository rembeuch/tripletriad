class Api::V1::ElitesController < ApplicationController
    def index
        @player = Player.find_by(wallet_address: params[:address])
        @elites = @player.elites
        render json: @elites
    end

    def create
        @player = Player.find_by(wallet_address: params[:address])
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
end
