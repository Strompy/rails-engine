class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.search(search_params)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.search(search_params).first
    render json: MerchantSerializer.new(merchant)
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
