Rails.application.routes.draw do
  resources :satellite_trackers, only: [:index]

  get '/', to: 'satellite_trackers#index', as: 'satellite_tracker'
end
