Rails.application.routes.draw do
  devise_for :admin_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'admin_dashboard#dashboard'
  resources :employee_types
  resources :projects
  resources :companies
  resources :users
end
