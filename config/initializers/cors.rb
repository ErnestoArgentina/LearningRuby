# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#     allow do
#       origins 'http://127.0.0.1:3001'
#       resource '*', headers: :any, methods: [:get, :post]
#     end
#   end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :any, headers: :any
    end
  end