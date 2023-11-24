Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # The homepage should be a landing page for either new users
  # or a dashboard for existing users
  root 'pages#home'

  # Callback for logging in with 42 will create a session,
  # logging out will destroy one
  get '/auth/marvin/callback', to: 'sessions#create'
  get '/auth/failure',         to: 'sessions#failure'
  delete '/logout',            to: 'sessions#destroy'

  # Protection against unauthorized access in config/initializers/good_job.rb
  mount GoodJob::Engine => 'good_job'

  # No need to do this the resourceful way, there is only
  # one user you will ever need to edit, update or destroy
  get    '/users', to: 'users#edit',    as: 'edit_user'
  patch  '/users', to: 'users#update',  as: 'update_user'
  delete '/users', to: 'users#destroy', as: 'destroy_user'

  # We do some implicit routing here
  # When adding other routes, put them above this one
  # to avoid this catch-all from taking the request instead.
  get '/:year',      to: 'years#show', as: 'year'
  get '/:year/:day', to: 'days#show',  as: 'year_day'
end
