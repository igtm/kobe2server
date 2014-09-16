Rails.application.routes.draw do

  get 'shops/list'
  get 'shops/near'
  match 'shops/near/:latitude/:longitude/:page',:to=>'shops#near',:via => [:get]
  match 'shops/list/:page',:to=>'shops#list',:via => [:get]
  
  get 'shops/variety'

  get 'database/update'

  get 'event/list'
  get 'event/umie'
  get 'event/mitsui'
  get 'event/sanda'

  match 'event/umie/:page',:to=>'event#umie',:via => [:get]
  match 'event/mitsui/:page',:to=>'event#mitsui',:via => [:get]
  match 'event/sanda/:page',:to=>'event#sanda',:via => [:get]
  match 'event/list/:page',:to=>'event#list',:via => [:get]
  # http://www.rubylife.jp/rails/controller/index6.html#section4
  match 'event/show/:id',:to=>'event#show',:via => [:get]
  
  
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
