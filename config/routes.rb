Rails.application.routes.draw do
  resources :time_sheet_cost_codes
  resources :plant_time_sheets
  resources :employee_time_sheets
  resources :budget_holders

  resources :projects do
    resources :foremen do
      collection do
        get :crew
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

  end

  resources :project_employees
  resources :project_companies do
    collection do
      post :import
      get :download_template
    end
  end
  resources :employees do
    collection do
      post :import
      get :download_template
    end
  end
  resources :temporary_users
  devise_for :users
  root to: 'admin_dashboard#dashboard'
  resources :client_companies
  resources :users
end
