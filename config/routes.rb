Photogallery::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations", :passwords => "passwords"}
  root 'welcomes#index'
  
  resources :users, only: [:show] do
    resources :categories, only: [:index, :new, :create, :edit, :update, :show] do
      collection do
        get 'edit_categories'
        post 'edit_categories', action: 'which_category_to_edit'
      end
      collection do
        get 'delete_categories'
        post 'delete_categories', action: 'which_category_to_delete'
      end
      collection do
        delete 'destroy', as: 'delete_category'
        get 'confirm_category_delete'
        post 'confirm_category_delete', action: 'confirm_category_delete'
      end
    end
    resources :pictures, only: [:new, :create, :edit, :update, :show] do
      collection do
        get 'edit_pictures'
        post 'edit_pictures', action: 'which_picture_to_edit'
      end
      collection do
        get 'delete_pictures'
        post 'delete_pictures', action: 'which_picture_to_delete'
      end
      collection do
        delete 'destroy', as: 'delete_picture'
      end
    end
    resources :cat_pictures, only: [] do
      collection do
        get 'select_cat_picture'
        post 'assign_cat_picture', action: 'assign_cat_picture'
      end
    end
    resources :bios, only: [:index]
  end
 get 'about' => 'static#about'

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
