class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    merchants = Merchant.find_most_revenue(revenue_params)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def revenue_params
    params.permit(:quantity)
  end
end
