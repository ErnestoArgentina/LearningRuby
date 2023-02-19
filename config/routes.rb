Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "metrics#index"

  # get metrics
  get 'api/metrics'=>'metrics#getMetrics'

  # get metrics timeline hour
  get 'api/metrics/timeline'=>'metrics#timeline'

  # get metrics timeline day
  get 'api/metrics/timeline/day'=>'metrics#timelineDay'

  # get metrics timeline minutes
  get 'api/metrics/timeline/minute'=>'metrics#timelineMinute'

  #Resources routes
  resources :metrics
end
