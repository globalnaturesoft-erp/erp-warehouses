Erp::Ability.class_eval do
  def warehouses_ability(user)
    
    can :creatable, Erp::Warehouses::Warehouse do |warehouse|
      if Erp::Core.available?("ortho_k")
        user.get_permission(:inventory, :products, :warehouses, :create) == 'yes'
      else
        true
      end
    end

    can :updatable, Erp::Warehouses::Warehouse do |warehouse|
      if Erp::Core.available?("ortho_k")
        user.get_permission(:inventory, :products, :warehouses, :update) == 'yes'
      else
        true
      end
    end

    can :archive, Erp::Warehouses::Warehouse do |warehouse|
      if Erp::Core.available?("ortho_k")
        !warehouse.archived? and user.get_permission(:inventory, :products, :warehouses, :archive) == 'yes'
      else
        !warehouse.archived?
      end
    end

    can :unarchive, Erp::Warehouses::Warehouse do |warehouse|
      if Erp::Core.available?("ortho_k")
        warehouse.archived? and user.get_permission(:inventory, :products, :warehouses, :unarchive) == 'yes'
      else
        warehouse.archived?
      end
    end
    
  end
end
