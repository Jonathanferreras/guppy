class Device < ApplicationRecord
  validates :name, presence: true
  validates :uuid, presence: true, uniqueness: true

  def update_online_status(status)
    update(online: status)
  end

  def update_last_seen
    update(last_seen: Time.current)
  end
end
