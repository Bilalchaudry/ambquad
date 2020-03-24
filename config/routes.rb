Rails.application.routes.draw do
  resources :budget_holders
  resources :project_companies
  resources :project_employees
  resources :other_managers
  resources :foremen

  resources :employees do
    collection do
      post :import
    end
  end

  resources :temporary_users
  resources :plants
  devise_for :users
  root to: 'admin_dashboard#dashboard'

  # devise_for :users
  # root to: 'admin_dashboard#dashboard'

  resources :employee_types
  resources :projects
  resources :client_companies
  resources :users
  resources :plant_types
  resources :cost_codes do
    collection do
      post :import
    end
  end
end
