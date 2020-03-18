Rails.application.routes.draw do
  resources :project_companies
  resources :project_employees
  resources :other_managers
  resources :foremen
  resources :employees
  resources :temporary_users
  resources :plants
  devise_for :users
  root to: 'admin_dashboard#dashboard'
  resources :employee_types
  resources :projects
  resources :client_companies
  resources :users
  resources :plant_types
end
