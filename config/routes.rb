Rails.application.routes.draw do
  root "dashboards#index"

  devise_for :users

  resource :dashboard, only: [:index]

  resources :chores

  resources :tier_lists do
    member do
      get :edit_tiers      # ティアリスト作成専用画面
      patch :update_tiers  # D&D操作の保存処理など
    end
  end

end
