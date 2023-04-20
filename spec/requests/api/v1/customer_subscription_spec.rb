require 'rails_helper'

RSpec.describe "Customer Subsciption API" do
  describe 'post /api/v1/customer_subscriptions' do
    it 'creates a customer_subscription record given a customer and a subscription' do
      customer = create(:customer)
      subscription = create(:subscription)

      headers = {'CONTENT_TYPE' => 'application/json'}
      params = ({
        customer_id: customer.id,
        subscription_id: subscription.id
      })

      post "/api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)
      customer = Customer.last
      subscription = Subscription.last
      expect(customer.subscriptions).to eq([subscription])
      expect(subscription.customers).to eq([customer])

      customer_subscription = CustomerSubscription.last
      expect(customer_subscription.customer_id).to eq(customer.id)
      expect(customer_subscription.subscription_id).to eq(subscription.id)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:created)
      expect(json).to have_key(:data)
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)

      expect(json[:data][:id]).to eq("#{customer_subscription.id}")
      expect(json[:data][:type]).to eq('customer_subscription')
      expect(json[:data][:attributes]).to have_key(:customer_id)
      expect(json[:data][:attributes]).to have_key(:subscription_id)
      expect(json[:data][:attributes][:customer_id]).to eq(customer.id)
      expect(json[:data][:attributes][:subscription_id]).to eq(subscription.id)
    end

    it 'returns an error response if customer or subscription does not exist' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      params = ({
        customer_id: 123,
        subscription_id: 123
      })

      post "/api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)

      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("Validation failed: Subscription must exist, Customer must exist")
    end

    it 'returns an error response if customer or subscription id are invalid' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      params = ({
        customer_id: "asdfassdf",
        subscription_id: "asdfasd"
      })

      post "/api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)

      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("Validation failed: Subscription must exist, Customer must exist")
    end

    it 'returns an error response if customer or subscription id are not given' do
      headers = {'CONTENT_TYPE' => 'application/json'}
      
      post "/api/v1/customer_subscriptions", headers: headers

      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("param is missing or the value is empty: customer_subscription")
    end

    it 'returns an error if a customer is already subscribed' do
      customer = create(:customer)
      subscription = create(:subscription)

      headers = {'CONTENT_TYPE' => 'application/json'}
      params = ({
        customer_id: customer.id,
        subscription_id: subscription.id
      })

      post "/api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)
      post "/api/v1/customer_subscriptions", headers: headers, params: JSON.generate(params)

      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("Validation failed: Customer A customer may be subscribed to a subscription only once")
    end
  end

  describe 'PATCH /api/v1/customer_subscriptions' do
    it 'can change a customer subscription status from active to canceled' do
      customer = create(:customer)
      subscription = create(:subscription)
      customer.subscriptions << subscription
      customer = Customer.last
      subscription = Subscription.last
      cs = CustomerSubscription.last

      expect(cs.status).to eq("active")

      headers = {"CONTENT_TYPE" => "application/json"}
      params = {
        status: "canceled"
      }
      patch "/api/v1/customer_subscriptions/#{cs.id}", headers: headers, params: JSON.generate(params)

      cs = CustomerSubscription.last
      expect(cs.customer_id).to eq(customer.id)
      expect(cs.subscription_id).to eq(subscription.id)
      expect(cs.status).to eq("canceled")

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:attributes][:status]).to eq("canceled")
    end

    it 'returns an error for invalid customer_subscription id' do
      headers = {"CONTENT_TYPE" => "application/json"}
      params = {
        status: "canceled"
      }
      patch "/api/v1/customer_subscriptions/12", headers: headers, params: JSON.generate(params)
      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("Couldn't find CustomerSubscription with 'id'=12")
    end

    it 'returns an error for invalid status type' do
      customer = create(:customer)
      subscription = create(:subscription)
      customer.subscriptions << subscription
      cs = CustomerSubscription.last

      headers = {"CONTENT_TYPE" => "application/json"}
      params = {
        status: "foo"
      }

      patch "/api/v1/customer_subscriptions/#{cs.id}", headers: headers, params: JSON.generate(params)

      error = JSON.parse(response.body, symbolize_names: true)
      expect(response).to have_http_status(:bad_request)
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error).to have_key(:message)
      expect(error).to have_key(:errors)
      expect(error[:errors][0][:detail]).to eq("'foo' is not a valid status")
    end
  end
end