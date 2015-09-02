Rails.application.routes.draw do
  root 'tops#show'
  post 'post' => 'tops#post'
end
