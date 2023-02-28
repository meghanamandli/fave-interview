Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root 'home#index'

  # resources :employees do
  #   post :import, on: :collection
  # end

  get '/show_payslip', to: 'payslip#show_payslip'
  post '/create_payslip', to: 'payslip#create_payslip'
end
