class Api::V1::Merchants::SearchController < ApplicationController
  def index
    require "pry"; binding.pry
  end

  def show
    merchant = Merchant.search(search_params).first
    render json: MerchantSerializer.new(merchant)
  end

  private

  def search_params
    params.permit(:id, :name)
  end
end
