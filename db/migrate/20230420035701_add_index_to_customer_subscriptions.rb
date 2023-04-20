class AddIndexToCustomerSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_index :customer_subscriptions, [:customer_id, :subscription_id], unique: true
  end
end
