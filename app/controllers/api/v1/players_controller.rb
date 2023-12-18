class Api::V1::PlayersController < ApplicationController
  require 'faker'
  before_action :set_player, only: %i[ show update destroy ]

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
    find_player
    @game = @player.game
    if !@game.nil?
      render json: @game 
    end
  end

  def deck
    find_player
    @player_cards = []
    @player.decks.each do |id|
      @player_cards.push(Card.find(id.to_i))
    end
    if @message
      render json: {message: @message, id: params[:card_id]}
    else
      render json: @player_cards
    end
  end

  def add_card
    @message = nil
    find_player
    if @player.decks.include?(params[:card_id])
      @message = "Already in your team!"
    elsif @player.in_game
      @message = "You can't, you are in game!"
    elsif @player.decks.size >= 4
      @message = "team Full!"
    else
      @player_deck = @player.decks.push(params[:card_id])
      @player.update(decks: @player_deck)
    end
    deck 
  end

  def remove_card
    find_player
    if @player.in_game
      render json: @player.errors, status: :unprocessable_entity
    elsif @player.decks.include?(params[:card_id])
      @player.decks.delete(params[:card_id])
      @player_deck = @player.decks
      @player.update(decks: @player_deck)
    end
    deck 
  end

  def deck_in_game
    find_player
    @player_deck_in_game = PlayerCard.where(player: @player, position: "9", computer: false)
    render json: @player_deck_in_game
  end

  def computer_deck
    find_player
    @computer_deck = PlayerCard.where(player: @player, position: "9", computer: true)
    render json: @computer_deck  
  end

  

  def find_player
    if Player.where(authentication_token: params[:token]).count == 1
      @player = Player.find_by(authentication_token: params[:token])
    elsif Player.where(wallet_address: params[:address]).count == 1
      @player = Player.find_by(wallet_address: params[:address])
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

  private
    
    def set_player
      @player = Player.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :wallet_address)
    end
end
