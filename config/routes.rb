MarketPlaceApi::Application.routes.draw do

  #Aou definition
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do

  end

end
