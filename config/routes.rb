Rails.application.routes.draw do
  resources :temporary_users
  resources :plants
  devise_for :users
  root to: 'admin_dashboard#dashboard'
  resources :employee_types
  resources :projects
  resources :client_companies
  resources :users, except: [:create]
  resources :plant_types
end
