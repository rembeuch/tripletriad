Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  devise_for :players, controllers: { confirmations: 'api/v1/confirmations', passwords: 'api/v1/passwords' }
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create]
      resources :sessions, only: [:create]
      post :logout, to:'sessions#logout'


      resources :players
      get :find_player, to: 'players#find_player'
      get :find_game, to: 'players#find_game'
      get :deck, to: 'players#deck'
      get :deck_in_game, to: 'players#deck_in_game'
      get :computer_deck, to: 'players#computer_deck'
      get :deck_in_pvp, to: 'players#deck_in_pvp'
      get :opponent_deck, to: 'players#opponent_deck'
      get :connect_wallet, to: 'players#connect_wallet'

      post :add_card, to:'players#add_card'
      post :remove_card, to:'players#remove_card'
      post :select_zone, to:'players#select_zone'
      

      post :quit_game, to:'games#quit_game'
      post :next_game, to:'games#next_game'
      post :reward, to:'games#reward'

      get :get_score, to: 'games#get_score'
      get :win, to: 'games#win'

      post :stop_pvp, to:'pvps#stop_pvp'
      post :next_pvp_game, to:'pvps#next_pvp_game'
      post :quit_pvp, to:'pvps#quit_pvp'


      get :find_pvp, to: 'pvps#find_pvp'
      get :find_number, to: 'pvps#find_number'
      get :get_pvp_score, to: 'pvps#get_pvp_score'
      get :win_pvp, to: 'pvps#win_pvp'


      patch :update_position, to: 'player_cards#update_position'
      patch :player_combo, to: 'player_cards#player_combo'
      patch :update_computer_position, to: 'player_cards#update_computer_position'
      patch :computer_combo, to: 'player_cards#computer_combo'

      post :super_power, to: 'player_cards#super_power'

      get :board_position, to: 'player_cards#board_position'

      get :pvp_board_position, to: 'pvp_cards#pvp_board_position'
      patch :update_pvp_position, to: 'pvp_cards#update_pvp_position'
      patch :pvp_player_combo, to: 'pvp_cards#pvp_player_combo'
      post :pvp_super_power, to: 'pvp_cards#pvp_super_power'


      post :ability, to: 'elites#ability'
      post :increment_elite, to: 'elites#increment_elite'
      post :nft_elite, to: 'elites#nft_elite'

      post :increment_card, to: 'cards#increment_card'
      post :sell_card, to: 'cards#sell_card'
      post :awake_card, to: 'cards#awake_card'
      post :sell_market, to: 'cards#sell_market'
      post :buy_market, to: 'cards#buy_market'
      post :rank_cards, to: 'cards#rank_cards'
      get :find_monsters, to: 'cards#find_monsters'
      get :find_zone_monsters, to: 'cards#find_zone_monsters'


      get :find_pnj, to: 'pnjs#find_pnj'
      get :find_zone_pnj, to: 'pnjs#find_zone_pnj'
      get :find_all_pnjs, to: 'pnjs#find_all_pnjs'
      get :find_pnj_objectives, to: 'pnjs#find_pnj_objectives'
      post :check_objective, to: 'pnjs#check_objective'
      get :display_menu_dialogue, to: 'pnjs#display_menu_dialogue'
      get :display_pnj_dialogue, to: 'pnjs#display_pnj_dialogue'

      

      resources :games
      resources :pvps
      resources :cards
      resources :elites

    end
  end
end
