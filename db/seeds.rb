user = Erp::User.first
warehouses = ["ADV", "TRAINING", "TN", "SG-HCM"]
owner = Erp::Contacts::Contact.first

# Warehouses
Erp::Warehouses::Warehouse.all.destroy_all
warehouses.each do |name|
  Erp::Warehouses::Warehouse.create(
    name: name,
    short_name: name,
    creator_id: user.id,
    contact_id: owner.id
  )
end