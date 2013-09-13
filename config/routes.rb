Rubequ::Application.routes.draw do
  root :to => 'root#index'
  get '/connected', :controller => "root", :action => "connected"
  get '/current_song', :controller => "songs", :action => "current_song"
  get '/songs_in_queue', :controller => "songs", :action => "songs_in_queue"

  get '/play', :controller => "songs", :action => "play"
  get '/pause', :controller => "songs", :action => "pause"
  get '/next', :controller => "songs", :action => "next"

  post '/volume/:volume', :controller => "root", :action => "update_volume"
  get '/volume', :controller => "root", :action => "volume"
  get '/volume_live' => 'root#volume_live'

  resources :songs do
    get '/lyrics', :action => "lyrics"
    get '/add_to_queue', :action => "add_to_queue"
    resources :comments
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
