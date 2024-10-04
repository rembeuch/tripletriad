# frozen_string_literal: true

class Api::V1::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |resource|
      if resource.errors.empty?
        if @player.elites.empty? && @player.cards.empty? && @player.pnjs.empty?
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
          Pnj.create(player: @player, dialogue: DialoguesManager::CASE_DIALOGUES[:A0][:case_1])
          Pnj.create(player: @player, zone: 'A1', dialogue: DialoguesManager::CASE_DIALOGUES[:A1][:case_1])
        end
      end
    end
  end

  def after_confirmation_path_for(resource_name, resource)
    'http://localhost:3001'
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
