Rails.application.routes.draw do
  root "meetup_events#index"
  get "meetup_events/list"
  get "meetup_events/join"
  post "meetup_events/list", :as => :meetup_events_search

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
