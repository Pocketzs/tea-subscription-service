require 'rails_helper'

RSpec.describe "Customer Subsciption API" do
  describe 'post /api/v1/customer_subscriptions' do
    it 'creates a customer_subscription record given a customer and a subscription' do
      customer = create(:customer)
      subscription = create(:subscription)
      expect(customer.subscriptions).to eq([])

      headers = {'CONTENT_TYPE' => 'application/json'}
      params = ({
        customer: customer,
        subscription: subscription
      })

      post "api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)
      
      expect(customer.subscriptions).to eq([subscription])
      expect(subscription.customers).to eq([customer])

      customer_subscription = CustomerSubscription.last
      expect(customer_subscription.customer_id).to eq(customer.id)
      expect(customer_subscription.subscription_id).to eq(subscription.id)
    end
  end
end