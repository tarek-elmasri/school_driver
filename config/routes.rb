Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
        post "users/new" => "users#new"
        post "users" => "users#create"
        post 'authentications/new'
        post 'authentications/create'
        post 'authentications/refresh'
      end
    end



end
