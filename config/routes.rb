Rails.application.routes.draw do
  post 'notifications' => 'notifications#receive'
end
