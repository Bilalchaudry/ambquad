Rails.application.routes.draw do
  resources :temporary_users
  resources :plants
  devise_for :users, controllers: { confirmations: 'confirmations' }
  root to: 'admin_dashboard#dashboard'
  resources :employee_types
  resources :projects
  resources :client_companies
  resources :users
  resources :plant_types
  resources :cost_codes

  get '/:token/confirm_email/', :to => "users#confirm_email", as: 'confirm_email'

end
