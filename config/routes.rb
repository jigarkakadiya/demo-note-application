Rails.application.routes.draw do
  get 'application/dashboard'
  get 'notes/change_importance/:id/:status', to: "notes#change_importance", as: :change_importance
  post 'notes/search_note', to: "notes#search_note", as: :search_note
  get 'application/change_autosave/:status', to: "application#change_autosave", as: :change_autosave
  get 'notes/load_data', to: "notes#load_data", as: :load_data
  get 'notes/invitation_email/:id', to: "notes#invitation_email", as: :invitation_email
  post 'notes/check_email'
  devise_for :users, controllers: { confirmations: 'confirmations' }
  resources :notes do
    resources :comments
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#dashboard"
end
