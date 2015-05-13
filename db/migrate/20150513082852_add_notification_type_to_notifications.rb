class AddNotificationTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :type_of_notification, :boolean
  end
end
