Rails.application.routes.draw do
  resources :examples
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'examples#index'
end
