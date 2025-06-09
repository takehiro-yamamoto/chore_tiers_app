Rails.application.routes.draw do
  root "dashboards#index"

  devise_for :users

  resources :dashboards, only: [:index] do
    collection do
      get :calendar
    end
  end

  resources :chores, only: [:new, :create, :destroy, :show, :edit,:update] do
    resources :completions, only: [:create]
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

end
