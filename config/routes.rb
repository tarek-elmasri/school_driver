Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    namespace :api do
      namespace :v1 do
        scope :users do
          post "new" => "users#new"
          post "/" => "users#create"
          get 'me' => "users#me"
        end

        scope :auth do
          post 'new' => "authentications#new"
          post '/' => "authentications#create"
          post 'refresh' => "authentications#refresh"
        end

        scope :parents do
          patch '/:id' => "parents#update"
          scope :requests do
            post "/" => "drive_requests#create"
          end
        end

        scope :schools do
          get '/' => "schools#index"
        end

        scope :children do
          post '/' => "children#create"
        end

        
      end
    end



end
