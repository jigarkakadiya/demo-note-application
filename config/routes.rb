# frozen_string_literal: true

Rails.application.routes.draw do
  get 'application/dashboard'

  get 'notes/change_importance/:id/:status',
      to: 'notes#change_importance',
      as: :change_importance

  get 'application/change_autosave/:status',
      to: 'application#change_autosave',
      as: :change_autosave

  get 'events/:id/edit/:calendar_id',
      to: 'events#edit',
      as: :edit_event,
      calendar_id: %r{[^/]+}

  get 'events/:calendar_id',
      to: 'events#show',
      calendar_id: %r{[^/]+}

  delete 'events/:id/:calendar_id',
         to: 'events#destroy',
         as: :destroy_event,
         calendar_id: %r{[^/]+}

  devise_for :users,
             controllers: {
               omniauth_callbacks: 'omniauth_callbacks'
             }

  resources :notes, except: [:show] do
    collection do
      post :search_note
      get :load_data
    end
    resources :comments, except: [:show]
  end

  resources :shares, only: [:new, :create, :index] do
    collection do
      get :shared_notes_with_me
      get :shared_notes_by_me
    end
    member do
      get :change_note_permission
      get :ask_for_permission
    end
  end

  resources :events do
    collection do
      get :message
      get :calendar_permission
    end
  end
  # For details on the DSL available within this file,
  # see http://guides.rubyonrails.org/routing.html
  root 'application#dashboard'
end
