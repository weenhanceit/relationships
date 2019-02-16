Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "children/:id", to: "children#index", as: :children
  resources :families, except: %i[index destroy]
  resources :people
  resources :phones
end
