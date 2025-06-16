Rails.application.routes.draw do
  root "dashboards#index"

  devise_for :users

  resources :dashboards, only: [:index] do
    collection do
      get :calendar
    end
  end

  resources :chores, only: [:index, :new, :create, :destroy, :show, :edit,:update] do
    resources :completion_logs, only: [:create]
  end

  resources :tier_lists do 
    member do
      get :edit_tiers      # ティアリスト作成専用画面
      patch :update_tiers  # D&D操作の保存処理など
    end
    collection do 
      post :ensure_editable_tier_list  # マイティアリストを作成して、編集画面にリダイレクト
    end
  end

  resources :tier_list_memberships, only: [:create, :destroy]

  resources :tier_lists do 
  get 'invite/:token', to: 'tier_lists#accept_invite', on: :collection, as: 'accept_invite'
  end

end
