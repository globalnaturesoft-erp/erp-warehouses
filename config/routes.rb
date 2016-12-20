Erp::Warehouses::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/warehouses" do
      resources :warehouses do
        collection do
          post 'list'
					get 'dataselect'
					put 'archive'
					put 'unarchive'
					delete 'delete_all'
					put 'archive_all'
					put 'unarchive_all'
        end
      end
    end
  end
end