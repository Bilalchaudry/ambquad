Rails.application.routes.draw do

  resources :history

  get 'timesheet/index'
  # resources :budget_holders
  # resources :plants

  resources :projects do
    resources :plant_time_sheets
    resources :employee_time_sheets
    resources :time_sheet_cost_codes
    resources :crews do
      collection do
        get '/:id/plants_list', to: 'crews#plants_list'
        get '/:id/employees_list', to: 'crews#employees_list'
      end
    end

    resources :foremen do
      collection do
        get :crew
        get :project_foreman_list
        post :import
        get :download_template
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
        get :select_cost_codes
        post :assign_cost_codes
        post :import
        get :download_template
      end
    end

    resources :other_managers do
      collection do
        post :import
        get :download_template
      end
    end


    resources :budget_holders do
      collection do
        post :import
        get :download_template
      end
    end

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

    resources :plants


  end

  resources :temporary_users
  devise_for :users, :controllers => {:sessions => "sessions", confirmations: 'confirmations' }

  # devise_for :users, controllers: {
  #     sessions: 'users/sessions',
  #     passwords: 'users/passwords',
  #     confirmations: 'users/confirmations'
  # }

  root to: 'admin_dashboard#dashboard'
  resources :client_companies
  resources :users

  get '/:token/confirm_email/', :to => "users#confirm_email", as: 'confirm_email'

end
