Rails.application.routes.draw do
  get 'application/dashboard'
  get 'notes/change_importance/:id/:status', to: "notes#change_importance", as: :change_importance
  post 'notes/search_note', to: "notes#search_note", as: :search_note
  get 'application/change_autosave/:status', to: "application#change_autosave", as: :change_autosave
  get 'notes/load_data', to: "notes#load_data", as: :load_data
  get 'shares/shared_notes_with_me', to: "shares#shared_notes_with_me", as: :shared_notes_with_me
  get 'shared/shared_notes_by_me', to: "shares#shared_notes_by_me", as: :shared_notes_by_me
  get 'shared/ask_for_permission/:id/:owner/:note/:email', to: "shares#ask_for_permission", as: :ask_for_permission
  get 'shared/change_note_permission/:id', to: "shares#change_note_permission", as: :change_note_permission
  get 'events/calendar_events/:calendar_id', to: "events#calendar_events", as: :calendar_events, calendar_id: /[^\/]+/
  devise_for :users, controllers: { confirmations: 'confirmations', omniauth_callbacks: 'omniauth_callbacks' }
  resources :notes do
    resources :comments
  end
  resources :shares,:events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#dashboard"
end
