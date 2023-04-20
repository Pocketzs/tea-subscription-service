class CustomerSubscription < ApplicationRecord
  belongs_to :subscription
  belongs_to :customer
  enum status: [:active, :canceled]

  validates :customer_id, uniqueness: { scope: :subscription_id, message: "A customer may be subscribed to a subscription only once" }
end