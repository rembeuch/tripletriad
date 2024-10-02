class Api::V1::RegistrationsController < ApplicationController
  
    def create
        @message = nil
        @player = Player.new(player_params)
        @player.wallet_address = "--" + @player.name
        @player.zones.push("A1")
        if @player.save
          @message = "Confirmation Email send"
          render json: { player: @player, token: @player.authentication_token, message: @message }, status: :created
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
  