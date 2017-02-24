Erp::Warehouses::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/warehouses" do
      resources :warehouses do
        collection do
          post 'list'
					get 'dataselect'
					put 'archive'
					put 'archive_all'
					put 'unarchive'
					put 'unarchive_all'
					delete 'delete_all'
        end
      end
    end
  end
end