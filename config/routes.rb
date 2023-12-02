Rails.application.routes.draw do
  devise_for :players
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create]
      resources :sessions, only: [:create]
      post :logout, to:'sessions#logout'


      resources :players
      get :find, to: 'players#find'
      get :find_game, to: 'players#find_game'
      get :deck, to: 'players#deck'
      post :add_card, to:'players#add_card'
      post :remove_card, to:'players#remove_card'
      get :deck_in_game, to: 'players#deck_in_game'
      get :computer_deck, to: 'players#computer_deck'
      get :connect_wallet, to: 'players#connect_wallet'

      post :quit_game, to:'games#quit_game'
      post :next_game, to:'games#next_game'

      get :get_score, to: 'games#get_score'
      get :win, to: 'games#win'

      
      patch :update_position, to: 'player_cards#update_position'
      patch :player_combo, to: 'player_cards#player_combo'
      patch :update_computer_position, to: 'player_cards#update_computer_position'
      patch :computer_combo, to: 'player_cards#computer_combo'

      get :board_position, to: 'player_cards#board_position'

      resources :games
      resources :cards
      resources :elites

    end
  end
end
