Rails.application.routes.draw do
  resources :posts
  resources :tags, only: [:index, :create, :destroy] do
    collection do
      get 'tag_types', to: 'tags#index_tag_types'
      post 'tag_types', to: 'tags#create_tag_type'
      delete 'tag_types/:id', to: 'tags#destroy_tag_type', as: :destroy_tag_type
      put 'tag_types/:id', to: 'tags#update_tag_type', as: :update_tag_type
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
