Rails.application.routes.draw do
  resources :uploaded_images, :only => [:new, :create, :show, :destroy] 
  root to: 'uploaded_images#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
