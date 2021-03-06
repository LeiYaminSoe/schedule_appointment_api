Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/schedule_appointment/book_appointment' => 'schedule_appointment#book_appointment'
      get '/schedule_appointment/display_appointment' => 'schedule_appointment#display_appointment'
    end
  end
  get '*unmatched_route', to: 'application#not_found'
  get '/404', to: 'application#not_found'
  get '/422', to: 'application#unprocessable'
  get '/500', to: 'application#internal_server_error'
end
