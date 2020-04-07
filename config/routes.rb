Rails.application.routes.draw do
  resources :time_sheet_cost_codes
  resources :plant_time_sheets
  get 'timesheet/index'
  resources :budget_holders

  resources :projects do

    resources :employee_time_sheets

    resources :foremen do
      collection do
        get :crew
        get :project_foreman_list
      end
    end

    resources :plants do
      collection do
        post :import
        get :download_template
      end
    end

    resources :employee_types do
      collection do
        post :import
        get :download_template
      end
    end

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

    resources :other_managers

    resources :budget_holders

    resources :project_employees

    resources :project_companies do
      collection do
        post :import
        get :download_template
      end
    end

  end

  resources :employees do
    collection do
      post :import
      get :download_template
    end
  end
  resources :temporary_users
  resources :plants
  devise_for :users, :controllers => {:sessions => "sessions"}
  root to: 'admin_dashboard#dashboard'
  resources :client_companies
  resources :users
  resources :plant_types
  resources :cost_codes

  get '/:token/confirm_email/', :to => "users#confirm_email", as: 'confirm_email'

end
