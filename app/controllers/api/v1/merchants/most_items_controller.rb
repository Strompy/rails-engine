class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    merchants = Merchant.most_items_sold(most_items_params)
    render json: MerchantSerializer.new(merchants)
  end

  private

  def most_items_params
    params.permit(:quantity)
  end
end
