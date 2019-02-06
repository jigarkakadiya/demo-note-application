Rails.application.routes.draw do
  get 'application/dashboard'
  post 'notes/search_note', to: "notes#search_note", as: :search_note
  devise_for :users, controllers: { confirmations: 'confirmations' }
  resources :notes do
    resources :comments
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#dashboard"
end
