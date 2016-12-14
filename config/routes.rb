Rails.application.routes.draw do
  root "meetup_events#index"
  get "meetup_events/list"
  get "meetup_events/join", :to => 'meetup_events#join', :as => :join_event
  get "meetup_events/join_callback"
  post "meetup_events/search"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
