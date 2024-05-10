class Api::V1::GamesController < ApplicationController
    def create
      find_player
      return if @player.game != nil
        @game = Game.new
        @game.player = @player
        @player.update(s_zone: false)
        @game.rounds = rand(1..5)
        if @game.save && @player.in_game == false && (@player.decks.size + @player.elites.where(in_deck: true).size) == 5
          @player.update(in_game: true)
          @elite = @player.elites.where(in_deck: true).first
          PlayerCard.create(up: @elite.up, down: @elite.down, right: @elite.right, left: @elite.left, position: "9", computer: false, player: @player, name: @elite.name )
          @player.decks.each do |id|
            @deck_card = Card.find(id.to_i)
            PlayerCard.create(up: @deck_card.up, down: @deck_card.down, right: @deck_card.right, left: @deck_card.left, position: "9", computer: false, player: @player, name: @deck_card.id )
          end
          @monsters = []
          if @player.zones.include?("boss" + @player.zone_position)
              @monster = Monster.select{|monster| monster.zones.include?(@player.zone_position)}.sample
              @monsters.push(@monster)
              PlayerCard.create(up: @monster.up, down: @monster.down, right: @monster.right, left: @monster.left, position: "9", computer: true, player: @player, name: @monster.name )
              @game.update(rounds: @monster.rank * 10, boss: true)
              @player.update(b_zone: false)
            4.times do
              @monsters.push(@monster)
              PlayerCard.create(up: (@monster.up - rand(0..@monster.up - 1)), down: (@monster.down - rand(0..@monster.down - 1)), right: (@monster.right - rand(0..@monster.right - 1)), left: (@monster.left - rand(0..@monster.left - 1)), position: "9", computer: true, player: @player, name: @monster.name )
            end
            @player.update(zones: @player.zones.delete_if{|z| z.include?("boss")})
          else
            5.times do
              @monster = Monster.select{|monster| monster.zones.include?(@player.zone_position)}.sample
              @monsters.push(@monster)
              PlayerCard.create(up: @monster.up, down: @monster.down, right: @monster.right, left: @monster.left, position: "9", computer: true, player: @player, name: @monster.name )
            end
          end
          @game.update(monsters: @monsters)
          @computer_max_power = @monsters.map{|monster| monster.rank}.max.to_s
          @computer_ability = ["fight", "diplomacy", "espionage", "leadership"].sample + @computer_max_power
          @player.update(computer_ability: @computer_ability)
          start = rand(2).to_i
          if start == 0
            @random_computer_card = @player.player_cards.where(pvp: false, computer: true, position: "9").sample
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
        @player.update(b_zone: false)
        @elite = @player.elites.where(in_deck: true).first
        @game = @player.game
        if @game.rounds <= @game.computer_points
        @player.update(energy: (@player.energy + (@game.player_points * 10)))
        @game.destroy
        @player.player_cards.where(pvp: false).destroy_all
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0, zone_position: "A1", s_zone: false, b_zone: false)
        render json: {id: "0"}
        elsif @game.rounds <= @game.player_points
          current_position = @player.zone_position
          letter = params[:zone_message][0]
          if params[:zone_message].size == 1
            @player.update(zones: @player.zones.delete_if{|z| z.include?("boss")})
          end
          number = current_position[1..].to_i
          number += 1
          @player.update(zone_position: "#{letter}#{number}")
          if !@player.zones.include?(@player.zone_position)
            @player.update(zones: @player.zones.push(@player.zone_position))
            @player.update(zones: @player.zones.sort_by { |element| element[-1].to_i })
            @player.elite_points += 1
            @player.save
          end
          @player.update(energy: (@player.energy + (@game.player_points * 10)))
          @game.destroy
          @player.player_cards.where(pvp: false).destroy_all
          @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0)
          render json: {id: "0"}
        else
          if @game.logs != []
            @game.logs.each do |attributes|
              @card_modified = @player.player_cards.where(pvp: false, id: attributes['id'])
              @card_modified.update(attributes)
            end
            @game.update(logs: [])
          end
          @player.decks.each do |name|
            @player.player_cards.where(pvp: false).find_by(name: name).update(position: "9", computer: false)
          end
          @player.player_cards.where(pvp: false).find_by(name: @elite.name).update(position: "9", computer: false)
          @player.player_cards.select {|card| card.pvp == false && card.position != "9"}.each do |card|
            card.update(computer: true, position: "9")
          end
          start = rand(2).to_i
          if start == 0
            @random_computer_card = @player.player_cards.where(pvp: false, computer: true, position: "9").sample
            @random_computer_card.update(position: rand(9).to_s)
          end
          @game.update(turn: true)
          render json: {id: @game.id}
        end
      end

      def reward 
        find_player
        @game = @player.game
        @monster = Monster.find(params[:id].to_i)
        number = @player.zone_position[1..].to_i
        number += 1
        if @monster.rules.include?("boss")
          @player.update(s_zone: true)
        end
        @reward_message = ""
        if @game.monsters.size == 5
          @game.update(monsters: [@monster])
          if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.zones.include?(@player.zone_position)}.count == Monster.select{|m| m.zones.include?(@player.zone_position)}.count
            start = rand(2).to_i
            if start == 0
              @player.update(b_zone: true)
              start = rand(2).to_i
              if start == 0
                if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.rules.include?("boss")} != [] && number < @player.zones.last[1..].to_i && @player.zones.include?("B#{number}")
                  @player.update(zones: @player.zones.unshift("bossB#{number}"))
                end
              end 
            end
          end
          start = rand(2).to_i
          if start == 0
            if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.rules.include?("boss")} != [] && number < @player.zones.last[1..].to_i && @player.zones.include?("A#{number}")
              @player.update(zones: @player.zones.unshift("bossA#{number}"))
            end
          end 
          if !@player.monsters.include?(@monster.name)
            @player.monsters.push(@monster.name)
            @player.monsters.sort_by { |monster| monster.delete("#").to_i }
            @player.elite_points += 1
            @reward_message = "New Monster: #{@monster.name} + 1 Elite Point!"
            @player.save
          end
          @card = @player.cards.find_by(name: @monster.name)
          if @card
            @card.update(copy: @card.copy + 1)
          else
            Card.create(up: @monster.up, down: @monster.down, right: @monster.right, left: @monster.left, player: @player, name: @monster.name, rank: @monster.rank, image: @monster.image, up_points: 0, right_points: 0, down_points: 0, left_points: 0 )
          end
        end
        if !@player.zones.include?("A#{number}")
          @zone_message = "A#{number} New Zone + 1 Elite Point!"
        else
          @zone_message = "A#{number}"
        end
        if @player.b_zone
          @b_zone_message = ""
          if !@player.zones.include?("B#{number}")
              @b_zone_message = "B#{number} New Zone + 1 Elite Point!"
            else
              @b_zone_message = "B#{number}"
            end
          end
        if @player.s_zone
          @s_zone_message = "Safe Zone"
        end
        if number == 5 || number == 10
          @player.update(zones: @player.zones.delete_if{|z| z.include?("bossB")})
          @player.update(zones: @player.zones.unshift("bossA#{number}"))
          @zone_message = ""
        end
        render json: {message: @reward_message, zone_message: @zone_message, b_zone_message: @b_zone_message, s_zone_message: @s_zone_message}
      end

      def quit_game
        find_player
        @game = @player.game
        if @game 
          @game.destroy
        end
        @player.player_cards.where(pvp: false).destroy_all
        @player.update(zones: @player.zones.delete_if{|z| z.include?("boss")})
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0, zone_position: "A1", s_zone: false, b_zone: false)
      end

      def get_score
        find_player
        @game = @player.game
        @player_score = @player.player_cards.where(pvp: false).select {|card| card.pvp == false && card.position != "9" && card.computer == false}.count
        @computer_score = @player.player_cards.where(pvp: false).select {|card| card.pvp == false && card.position != "9" && card.computer == true}.count
        @player_power_points = @player.power_point
        @player_power = @player.power
        @player_computer_power_point = @player.computer_power_point
        @player_computer_power = @player.computer_power
        if @game.boss
          @boss_life = @game.rounds - @game.player_points
        end
        render json: {player_score: @player_score, computer_score: @computer_score , player_power_points: @player_power_points, player_power: @player.power, player_computer_power_points: @player_computer_power_point, player_computer_power: @player.computer_power, boss_life: @boss_life}
      end

      def win
        find_player
        @game = @player.game
        @message = ''
        if @game.boss == true 
          if @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == true}.count - @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == false}.count >= 2 && @player.player_cards.where(pvp: false, position: "9").count <= 1
            @message =  "You Lose!"
            @game.update(computer_points: @game.rounds)
          elsif @game.player_points < @game.rounds && @player.player_cards.where(pvp: false, position: "9").count <= 1
            @message =  "Continue!"
          elsif @game.player_points >= @game.rounds
            @message =  "You win!"
          end
        elsif @player.player_cards.where(pvp: false, position: "9").count <= 1 
          if @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == false}.count - @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == true}.count >= 2
           @message =  "You win!"
           @game.update(player_points: @game.player_points += 1)
            if @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == false}.count - @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == true}.count == 9
              @player.update(energy: (@player.energy + 50))
              @player.elite_points += 1
              @player.s_zone = true
              @player.save
              @message =  "Perfect! +1 Elite Point / +50 energy"
            end
          elsif @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == true}.count - @player.player_cards.select {|card| card.pvp == false && card.position != "9" && card.computer == false}.count >= 2
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
