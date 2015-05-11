class AddHasRegisteredToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :hasRegistered, :boolean
  end
end
