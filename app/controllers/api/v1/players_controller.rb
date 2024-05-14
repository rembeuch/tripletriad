class Api::V1::PlayersController < ApplicationController
  require 'faker'
  before_action :set_player, only: %i[ show update destroy ]
  before_action :find_player, only: [:opponent_deck]
  # GET /players
  def index
    @players = Player.all

    render json: @players
  end

  # GET /players/1
  def show
    render json: @player
  end

  # POST /players
  

  # PATCH/PUT /players/1
  def update
    if @player.update(player_params)
      render json: @player
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

  # DELETE /players/1
  def destroy
    @player.destroy!
  end

  def find
    if Player.where(authentication_token: params[:token]).count == 1
      @player = Player.find_by(authentication_token: params[:token])
      render json: @player
    elsif Player.where(wallet_address: params[:address]).count == 1
      @player = Player.find_by(wallet_address: params[:address])
      render json: @player
    end
  end

  def find_game
    @player = Player.find(params[:id])
    @game = @player.game
    if !@game.nil?
      render json: @game 
    end
  end

  def deck
    @player = Player.find(params[:id])
    @player_cards = []
    @player.decks.each do |name|
      @player_cards.push(Card.find_by(name: name, player: @player))
    end
    if @message
      render json: {message: @message, id: params[:card_id]}
    else
      render json: @player_cards
    end
  end

  def add_card
    @message = nil
    @player = Player.find(params[:id])
    @card = Card.find(params[:card_id])
    if @player.decks.include?(@card.name)
      @message = "Already in your team!"
    elsif @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait'
      @message = "You can't, you are in game!"
    elsif @player.zone_position != "A1"
      @message = "Only in A1 level!"
    elsif @player.decks.size >= 4
      @message = "team Full!"
    else
      @player_deck = @player.decks.push(@card.name)
      @player.update(decks: @player_deck)
    end
    deck 
  end

  def remove_card
    @player = Player.find(params[:id])
    @card = Card.find(params[:card_id])
    @message = nil
    if @player.in_game || @player.in_pvp == 'true' || @player.in_pvp == 'wait' 
      @message = "You can't, you are in game!"
    elsif @player.zone_position != "A1"
      @message = "Only in A1 level!"
    elsif @player.decks.include?(@card.name)
      @player.decks.delete(@card.name)
      @player.update(decks: @player.decks)
    end
    deck 
  end

  def deck_in_game
    find_player
    @player_deck_in_game = PlayerCard.where(player: @player, position: "9", computer: false, pvp: false)
    render json: @player_deck_in_game
  end

  def computer_deck
    find_player
    @computer_deck = PlayerCard.where(player: @player, position: "9", computer: true, pvp: false)
    render json: @computer_deck  
  end

  def deck_in_pvp
    find_player
    @player_deck_in_game = PlayerCard.where(player: @player, position: "9", computer: false, pvp: true)
    render json: @player_deck_in_game
  end

  def opponent_deck
    find_player
    @pvp = Pvp.select{|pvp| pvp.player1 == @player || pvp.player2 == @player}.first
    if @pvp.player1 == @player
      @opponent_deck = PlayerCard.where(player: @pvp.player2, position: "9", pvp: true)
      render json: @opponent_deck
    end
    if @pvp.player2 == @player
      @opponent_deck = PlayerCard.where(player: @pvp.player1, position: "9", pvp: true)
      render json: @opponent_deck
    end 
  end

  def find_player
    if Player.where(authentication_token: params[:token]).count == 1
      @player = Player.find_by(authentication_token: params[:token])
    end
  end

  def connect_wallet
    @message = ""
    if Player.where(authentication_token: params[:token]).count == 1
      @player = Player.find_by(authentication_token: params[:token])
    end
    if @player.wallet_address.size < 23 && Player.where(wallet_address: params[:address]).count == 0
      if @player.wallet_address == "undefined" || @player.wallet_address.first(2) == "--"
        @player.update(wallet_address: params[:address])
      end
    end
  end

  def select_zone
    find_player
    @player.update(zone_position: params[:zone])
    if !@player.zones.include?(params[:zone])
      @player.update(zones: @player.zones.push(params[:zone]))
    end
    render json: @player
  end

  private
    
    def set_player
      @player = Player.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :wallet_address)
    end
end
