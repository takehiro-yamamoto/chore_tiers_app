# config valid for current version and patch releases of Capistrano
# capistranoのバージョンを記載。固定のバージョンを利用し続け、バージョン変更によるトラブルを防止する
lock "~> 3.19.2"

# Capistranoのログの表示に利用する
set :application, 'chore_tiers_app'

# どのリポジトリからアプリをpullするかを指定する
set :repo_url, 'git@github.com:takehiro-yamamoto/chore_tiers_app.git'
set :branch, 'main'

# バージョンが変わっても共通で参照するディレクトリを指定
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '3.2.0'

# どの公開鍵を利用してデプロイするか
set :ssh_options, auth_methods: ['publickey'],
                                  keys: ['~/.ssh/chore-key-pair.pem']
set :deploy_to, "/var/www/#{fetch(:application)}"

# プロセス番号を記載したファイルの場所
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }

# Unicornの設定ファイルの場所
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
set :keep_releases, 5

# デプロイ処理が終わった後、Unicornを再起動するための記述
after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

# Nokogiri/glibc互換性問題の対策としてforce_ruby_platformを設定 (↓ここから追加)
  desc 'Set force_ruby_platform to true for Bundler'
  task :set_force_ruby_platform do
    on roles(:app) do
      within release_path do
        execute :bundle, :config, :set, :force_ruby_platform, :true
      end
    end
  end
  # bundle:installの前に上記のタスクを実行
  before 'bundler:install', 'deploy:set_force_ruby_platform'
  #(↑ここまで追加)
end