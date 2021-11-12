Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
        scope :users do
          post "new" => "users#new"
          post "/" => "users#create"
        end

        scope :auth do
          post 'new' => "authentications#new"
          post '/' => "authentications#create"
          post 'refresh' => "authentications#refresh"
        end
      end
    end



end
