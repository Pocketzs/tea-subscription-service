class Subscription < ApplicationRecord
  has_many :customer_subscriptions
  has_many :customers, through: :customer_subscriptions

  enum frequency: [:monthly, :yearly]
end
