class Api::V1::PlayersController < ApplicationController
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
  def create
    @player = Player.new(player_params)
    if @player.save
      render json: @player, status: :created
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  end

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
    @player = Player.find_by(wallet_address: params[:address])
    render json: @player
  end

  def find_game
    @player = Player.find_by(wallet_address: params[:address])
    @game = @player.game
    render json: @game if @game
  end

  def deck
    @player = Player.find_by(wallet_address: params[:address])
    @player_cards = []
    @player.decks.each do |id|
      @player_cards.push(Card.find(id.to_i))
    end
    render json: @player_cards
  end

  def add_card
    @player = Player.find_by(wallet_address: params[:address])
    if @player.in_game && @player.decks.size == 5
      render json: @player.errors, status: :unprocessable_entity
    elsif !@player.decks.include?(params[:card_id])
      @player_deck = @player.decks.push(params[:card_id])
      @player.update(decks: @player_deck)
    end
    deck 
  end

  def remove_card
    @player = Player.find_by(wallet_address: params[:address])
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
    @player = Player.find_by(wallet_address: params[:address])
    @player_deck_in_game = PlayerCard.where(player: @player, position: "9", computer: false)
    render json: @player_deck_in_game
  end

  def computer_deck
    @player = Player.find_by(wallet_address: params[:address])
    @computer_deck = PlayerCard.where(player: @player, position: "9", computer: true)
    render json: @computer_deck  
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :wallet_address)
    end
end
