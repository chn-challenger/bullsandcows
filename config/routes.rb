Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  root to: "games#homepage"
  get 'games/index' => 'games#index'
  post 'games/challenge' => 'games#challenge'
  post 'games/accept_challenge' => 'games#accept_challenge'
  get 'games/secret' => 'games#secret'
  resource :games

end
