require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  get 'main/welcome'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "main#welcome"

  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1 do
      get 'titles/api/v1/TeamMembers'
      post '/login', to: 'authentication#login'
      post '/register', to: 'users#create'
      get '/users/my', to: 'authentication#show'
      post '/password/forgot', to: 'authentication#forgot'
      post '/password/reset', to: 'authentication#reset'

      resources :users, param: :user_id do
        collection do
          put :password
        end
      end
      resources :titles, param: :title_id do
        collection do
          get :own_titles
        end
      end
      resources :team_members, param: :team_member_id do
        collection do
          get :own_team_members
          get :histories
        end
      end
      resources :team_member_notes, param: :team_member_note_id do
      end
      resources :teams, param: :team_id do
        collection do
          get :own_teams
        end
      end
      resources :companies, param: :company_id do
        collection do
          get :own_companies
        end
      end
      resources :important_links, param: :important_link_id do
        collection do
          get :own_important_links
        end
      end
      resources :company_requests, param: :company_request_id do
      end
      resources :jobs, param: :job_id do
        collection do
          get :own_jobs
        end
      end
      resources :job_interviewers, param: :job_interviewer_id
      resources :applicants, param: :applicant_id do
        collection do
          get :own_applicants
        end
      end
      resources :applicant_offers, param: :applicant_offer_id
      resources :applicant_notes, param: :applicant_note_id
      resources :storage, param: :storage_id
      resources :contents, param: :content_id do
        collection do
          get :query_contents
        end
      end
    end
  end

  
  post '/*a', to: 'application#not_found'
  scope format: true, constraints: { format: /jpg|png|gif|PNG|pdf|PDF/ } do
    get '/*anything', to: 'application#not_found', constraints: lambda { |request| !request.path_parameters[:anything].start_with?('rails/') }
  end
end
