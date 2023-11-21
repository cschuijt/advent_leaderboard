Rails.application.routes.draw do
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # The homepage should be a landing page for either new users
  # or a dashboard for existing users
  root 'pages#home'

  # Protection against unauthorized access in config/initializers/good_job.rb
  mount GoodJob::Engine => 'good_job'

  get '/years', to: 'years#index'

  # We do some implicit routing here
  # When adding other routes, put them above this one
  # to avoid this catch-all from taking the request instead.
  get '/:year', to: 'years#show' do
    get '/:day', to: 'days#show'
  end
end
