class Api::V1::SessionsController < ApplicationController
    def create
        player = Player.where(email: params[:email]).first

        if player&.valid_password?(params[:password])
            render json: player.as_json(only: [:email, :authentication_token]), status: :created
        else
            head(:unautorized)
        end
    end

    def logout
        player = Player.where(authentication_token: params[:token]).first
        player.update(authentication_token: nil)
    end
end
