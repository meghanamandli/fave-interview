Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root 'home#index'

  # resources :employees do
  #   post :import, on: :collection
  # end

  get '/payslips', to: 'payslips#index'
  post '/payslip', to: 'payslip#get_payslip_information'
  get '/payslips/multiple', to: 'payslips#show_multiple'
end
