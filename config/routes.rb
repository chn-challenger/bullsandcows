Rails.application.routes.draw do
  get 'users/index'

  devise_for :users, :controllers => { registrations: 'registrations' }  
  root to: "users#index"
end
