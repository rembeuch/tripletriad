Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :players
      get :find, to: 'players#find'
      get :find_game, to: 'players#find_game'
      get :deck, to: 'players#deck'
      post :add_card, to:'players#add_card'
      post :remove_card, to:'players#remove_card'
      get :deck_in_game, to: 'players#deck_in_game'
      get :computer_deck, to: 'players#computer_deck'

      post :quit_game, to:'games#quit_game'

      
      patch :update_position, to: 'player_cards#update_position'
      patch :update_computer_position, to: 'player_cards#update_computer_position'

      get :board_position, to: 'player_cards#board_position'

      resources :games
      resources :cards

    end
  end
end
