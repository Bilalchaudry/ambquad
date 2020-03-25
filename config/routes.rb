Rails.application.routes.draw do
  resources :budget_holders

  resources :project_companies do
    collection do
      post :import
      get :download_template
    end
  end

  resources :project_employees
  resources :other_managers
  resources :foremen

  resources :employees do
    collection do
      post :import
      get :download_template
    end
  end

  resources :temporary_users
  resources :plants do
    collection do
      post :import
      get :download_template
    end
  end

  devise_for :users
  root to: 'admin_dashboard#dashboard'

  resources :employee_types do
    collection do
      post :import
      get :download_template
    end
  end

  resources :projects
  resources :client_companies
  resources :users

  resources :plant_types do
    collection do
      post :import
      get :download_template
    end
  end

  resources :cost_codes do
    collection do
      post :import
      get :download_template
    end
  end
end
