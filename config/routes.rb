Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :clients
  resources :ptypes
  resources :places
  resources :payments
  resources :bookings
  resources :statuses

  get '/places/ptype/:ptype', to: 'places#get_places_by_ptype', defaults: { format: :json }

  get '/payments/b/:id', to: 'payments#get_payments_by_booking_id', defaults: { format: :json }

  post '/bookings/agenda/monthly', to: 'bookings#get_bookings_by_day_and_ptype', defaults: { format: :json }

end
