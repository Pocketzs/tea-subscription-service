require 'rails_helper'

RSpec.describe "Get All Customer's subscriptions" do
  describe 'GET /api/v1/customers/:id/subscriptions' do
    it 'returns an array of all of one customers subscriptions' do
      customer = create(:customer)
      subscription = create(:subscription)
      customer.subscriptions << subscription

      get "/api/v1/customers/#{customer.id}/subscriptions"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Array)
      json[:data].each do |sub|
        expect(sub).to have_key(:id)
        expect(sub).to have_key(:type)
        expect(sub).to have_key(:attributes)
        expect(sub[:id]).to be_a(String)
        expect(sub[:type]).to eq("subscription")
        expect(sub[:attributes]).to have_key(:title)
        expect(sub[:attributes]).to have_key(:price)
        expect(sub[:attributes]).to have_key(:frequency)
        expect(sub[:attributes][:title]).to be_a(String)
        expect(sub[:attributes][:frequency]).to be_a(String)
        expect(sub[:attributes][:price]).to be_a(Integer)
      end
    end
  end
end