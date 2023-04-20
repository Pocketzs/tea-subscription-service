class Api::V1::CustomerSubscriptionsController < ApplicationController
  def create
    customer_subscription = CustomerSubscription.create!(customer_subscription_params)
    render json: CustomerSubscriptionSerializer.new(customer_subscription), status: :created
  end

  def update
    customer_subscription = CustomerSubscription.find(params[:id])
    customer_subscription.update(customer_subscription_params)
    render json: CustomerSubscriptionSerializer.new(customer_subscription), status: :ok
  end

  private

  def customer_subscription_params
    params.require(:customer_subscription).permit(:customer_id, :subscription_id, :status)
  end
end