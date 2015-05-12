class Device < ActiveRecord::Base
  validates :email, presence: true
  validates :device_id, presence: true
  validates :email, uniqueness: true
  validates :device_id, uniqueness: true
end
