Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :application

  get "/", to: "application#get_lists"
  post "/", to: "application#new_list"
  put "/:list_id", to: "application#edit_list"
  delete "/:list_id", to: "application#delete_list"

  get "/:list_id", to: "application#get_list"
  post "/:list_id", to: "application#add_list_item"
  put "/:list_id/:list_item_id", to: "application#edit_list_item"
  delete "/:list_id/:list_item_id", to: "application#delete_list_item"



end
