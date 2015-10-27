Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: "games#homepage"
  get 'games/index' => 'games#index'
  post 'games/challenge' => 'games#challenge'
  post 'games/accept_challenge' => 'games#accept_challenge'
  get 'games/set_secret' => 'games#set_secret'
  post 'games/save_secret' => 'games#save_secret'
  post 'games/guess' => 'games#guess'
  resource :games

end
