# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  if Rails.env == "development"
    allow do
      origins 'http://localhost:3000'

      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head], credentials: true
    end
  elsif Rails.env == "production" 
    allow do
      origins 'mywebsite domain'

      resource '*',
        headers: :any, # TODO: add spescific headers
        methods: [:get, :post, :put, :patch, :delete, :options, :head], credentials: true
    end
  end
end
