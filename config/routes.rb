MSub::Application.routes.draw do
  
  resources :categories, :only => [ :index ] do
    get 'list',                :on => :collection
  end

  resources :products, :only => [ :index ] do
    get 'list',                :on => :collection
  end

  get "welcome/index"

  root :to => "welcome#index"

end
