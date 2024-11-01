class Api::V1::GamesController < ApplicationController
    def create
      find_player
      return if @player.game != nil
      @game = Game.new
        @game.player = @player
        @game.rounds = rand(1..5)
        if @game.save && @player.in_game == false && (@player.decks.size + @player.elites.where(in_deck: true).size) == 5
          @player.update(s_zone: false, s_monsters: [])
          @player.update(in_game: true)
          find_zone_pnj
          @zone_pnj.update(try: @zone_pnj.try + 1, dialogue: DialoguesManager::CASE_DIALOGUES[@zone_pnj.zone.to_sym][:in_fight])
          if @player.zone_position == "A1"
            find_pnj
            @pnj.update(try: @pnj.try + 1, dialogue: DialoguesManager::CASE_DIALOGUES[:A0][:in_fight])
          end
          if @player.zone_position == "A1" && @player.power_condition == @player.ability && @player.decks.include?(@player.monster_condition)
            @player.update(bonus: true)
          end
          @elite = @player.elites.where(in_deck: true).first
          PlayerCard.create(up: @elite.up, down: @elite.down, right: @elite.right, left: @elite.left, position: "9", computer: false, player: @player, name: @elite.name )
          @player.decks.each do |name|
            @deck_card = Card.find_by(name: name, player: @player)
            PlayerCard.create(up: @deck_card.up, down: @deck_card.down, right: @deck_card.right, left: @deck_card.left, position: "9", computer: false, player: @player, name: @deck_card.name )
          end
          @monsters = []
          if @player.zones.include?("boss" + @player.zone_position)
              @monster = Monster.select{|monster| monster.zones.include?(@player.zone_position)}.sample
              @monsters.push(@monster)
              PlayerCard.create(up: @monster.up, down: @monster.down, right: @monster.right, left: @monster.left, position: "9", computer: true, player: @player, name: @monster.name )
              @game.update(rounds: @monster.rank * 10, boss: true)
              find_pnj
              @pnj.update(boss: @pnj.boss + 1, dialogue: Api::V1::PnjsController::case_dialogues(@pnj, "boss"))
              @zone_pnj.update(boss: @zone_pnj.boss + 1, dialogue: Api::V1::PnjsController::case_dialogues(@zone_pnj, "boss"))
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
          @game_monsters = @monsters.map{|m| m.id}
          @game.update(monsters: @game_monsters)
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
        find_pnj
        find_zone_pnj
        @player.update(b_zone: false)
        @elite = @player.elites.where(in_deck: true).first
        @game = @player.game
        if @game.rounds <= @game.computer_points
        @player.update(energy: (@player.energy + (@game.player_points * 10)))
        @pnj.update(defeat: @pnj.defeat + 1, dialogue: Api::V1::PnjsController::case_dialogues(@pnj, "defeat"))
        @zone_pnj.update(defeat: @zone_pnj.defeat + 1, dialogue: Api::V1::PnjsController::case_dialogues(@zone_pnj, "defeat"))
        @game.destroy
        @player.player_cards.where(pvp: false).destroy_all
        if @player.monsters.size >= 5
          @monster_condition = @player.monsters.sample
          @power_condition = ["fight", 'diplomacy', 'espionage', 'leadership'].sample + rand(1..@elite.send([:up, :right, :down, :left].max_by { |column| @elite.send(column) }).to_i).to_s
          @player.update(monster_condition: @monster_condition, power_condition: @power_condition, bonus: false)
        end
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0, zone_position: "A1", s_zone: false, b_zone: false)
        if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.zones.include?(@player.zone_position)}.count == Monster.select{|m| m.zones.include?(@player.zone_position)}.count
          start = rand(2).to_i
          if start == 0
            @player.update(zone_position: "B1")
            if !@player.zones.include?(@player.zone_position)
              @player.update(zones: @player.zones.push(@player.zone_position))
              @player.update(zones: @player.zones.sort_by { |element| element[-1].to_i })
              @player.elite_points += 1
              @player.save
              @new_pnj = Pnj.new(player: @player, zone: @player.zone_position, dialogue: DialoguesManager::CASE_DIALOGUES[@player.zone_position.to_sym][:welcome], zone_image: ZoneImagesManager::CASE_IMAGES[@player.zone_position.to_sym])
              if @new_pnj.save
                PnjObjectivesManager.create_objectives(@new_pnj)
              end
            end
            start = rand(2).to_i
            if start == 0
              if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.rules.include?("boss")} != [] && 1 < @player.zones.last[1..].to_i && @player.zones.include?("B1")
                @player.update(zones: @player.zones.unshift("bossB1"))
              end
            end 
          end
        end
        render json: {id: "0"}
        elsif @game.rounds <= @game.player_points
          current_position = @player.zone_position
          letter = params[:zone_message][0]
          if params[:zone_message].size == 1
            @player.update(zones: @player.zones.delete_if{|z| z.include?("boss")})
          end
          number = current_position[1..].to_i
          number += 1
          find_pnj
          @pnj.update(victory: @pnj.victory + 1, dialogue: Api::V1::PnjsController::case_dialogues(@pnj, "victory"))
          @zone_pnj.update(victory: @zone_pnj.victory + 1, dialogue: Api::V1::PnjsController::case_dialogues(@zone_pnj, "victory"))
          if @player.s_zone 
            @s_monsters = Monster.select{|m| m.zones.include?(@player.zone_position) && m.rules == "[]"}.sample(4).map{|m|  m.name}
            if @s_monsters == []
              4.times do
                random = rand(1..current_position[1..].to_i - 1)
                @s_monsters.push(Monster.select{|m| m.zones.include?("#{letter}#{random}") && m.rules == "[]"}.first.name)
              end
            end
            @player.update(s_monsters: @s_monsters)
          end
          @player.update(zone_position: "#{letter}#{number}")
          if !@player.zones.include?(@player.zone_position)
            @player.update(zones: @player.zones.push(@player.zone_position))
            @player.update(zones: @player.zones.sort_by { |element| element[-1].to_i })
            @player.elite_points += 1
            @player.save
            @new_pnj = Pnj.new(player: @player, zone: @player.zone_position, dialogue: DialoguesManager::CASE_DIALOGUES[@player.zone_position.to_sym][:welcome], zone_image: ZoneImagesManager::CASE_IMAGES[@player.zone_position.to_sym])
            if @new_pnj.save
              PnjObjectivesManager.create_objectives(@new_pnj)
            end
          end
          @player.update(energy: (@player.energy + (@game.player_points * 10)))
          if @player.bonus
            @player.update(energy: (@player.energy + 20))
          end
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
        @monster = Monster.find(@game.monsters[params[:monster_index].to_i])
        number = @player.zone_position[1..].to_i
        number += 1
        if @monster.rules.include?("boss")
          @player.update(s_zone: true)
        end
        @reward_message = ""
        if @game.monsters.size == 5
          @game.update(monsters: [@monster.id])
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
            @reward_message = "New Monster: #{@monster.name} + 1 Diamond 💎!"
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
          @zone_message = "A#{number} New Zone + 1 Diamond 💎!"
        else
          @zone_message = "A#{number}"
        end
        if @player.b_zone
          @b_zone_message = ""
          if !@player.zones.include?("B#{number}")
              @b_zone_message = "B#{number} New Zone + 1 Diamond 💎!"
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
        render json: {message: @reward_message, zone_message: @zone_message, b_zone_message: @b_zone_message, s_zone_message: @s_zone_message, monster: @monster}
      end

      def quit_game
        find_player
        @game = @player.game
        if @game 
          @game.destroy
        end
        @player.player_cards.where(pvp: false).destroy_all
        @player.update(zones: @player.zones.delete_if{|z| z.include?("boss")})
        if @player.monsters.size >= 5
          @elite = @player.elites.where(in_deck: true).first
          @monster_condition = @player.monsters.sample
          @power_condition = ["fight", 'diplomacy', 'espionage', 'leadership'].sample + rand(1..@elite.send([:up, :right, :down, :left].max_by { |column| @elite.send(column) }).to_i).to_s
          @player.update(monster_condition: @monster_condition, power_condition: @power_condition, bonus: false)
        end
        find_pnj
        find_zone_pnj
        @pnj.update(defeat: @pnj.defeat + 1, dialogue: Api::V1::PnjsController::case_dialogues(@pnj, "defeat"))
        @zone_pnj.update(defeat: @zone_pnj.defeat + 1, dialogue: Api::V1::PnjsController::case_dialogues(@zone_pnj, "defeat"))
        @player.update(in_game: false, power: false, power_point: 0, computer_power: false, computer_power_point: 0, zone_position: "A1", s_zone: false, b_zone: false, s_monsters: [])
        if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.zones.include?(@player.zone_position)}.count == Monster.select{|m| m.zones.include?(@player.zone_position)}.count
          start = rand(2).to_i
          if start == 0
            @player.update(zone_position: "B1")
            if !@player.zones.include?(@player.zone_position)
              @player.update(zones: @player.zones.push(@player.zone_position))
              @player.update(zones: @player.zones.sort_by { |element| element[-1].to_i })
              @player.elite_points += 1
              @player.save
              @new_pnj = Pnj.new(player: @player, zone: @player.zone_position, dialogue: DialoguesManager::CASE_DIALOGUES[@player.zone_position.to_sym][:welcome], zone_image: ZoneImagesManager::CASE_IMAGES[@player.zone_position.to_sym])
              if @new_pnj.save
                PnjObjectivesManager.create_objectives(@new_pnj)
              end
            end
            start = rand(2).to_i
            if start == 0
              if @player.monsters.map{|m| Monster.find_by(name: m)}.select{|m| m.rules.include?("boss")} != [] && 1 < @player.zones.last[1..].to_i && @player.zones.include?("B1")
                @player.update(zones: @player.zones.unshift("bossB1"))
              end
            end 
          end
        end
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
              find_pnj
              find_zone_pnj
              @pnj.update(perfect: @pnj.perfect + 1)
              @zone_pnj.update(perfect: @zone_pnj.perfect + 1)
              @message =  "Perfect! +1 Diamond 💎 / +50 Cardinum ⚡"
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
      @player = Player.find(params[:id])
    end

    def find_pnj
      @pnj = @player.pnjs.where(zone: nil).first
    end

    def find_zone_pnj
      @zone_pnj = @player.pnjs.where(zone: @player.zone_position).first
    end
end
