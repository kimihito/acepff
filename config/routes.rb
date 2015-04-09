Rails.application.routes.draw do
  root 'notifications#index'
  post 'notifications' => 'notifications#receive'
end
