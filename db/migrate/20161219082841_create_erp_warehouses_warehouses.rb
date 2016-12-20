class CreateErpWarehousesWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_warehouses_warehouses do |t|
      t.string :name
      t.string :short_name
      t.references :creator, index: true, references: :erp_users
      t.references :contact, index: true, references: :erp_contacts_contacts
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
