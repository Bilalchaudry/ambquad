Rails.application.routes.draw do
  resources :plants
  devise_for :users
  root to: 'admin_dashboard#dashboard'
  resources :employee_types
  resources :projects
  resources :companies
  resources :users
  resources :plant_types
end
