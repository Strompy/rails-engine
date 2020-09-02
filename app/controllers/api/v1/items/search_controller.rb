class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.search(search_params)
    render json: ItemSerializer.new(items)
  end

  def show
    merchant = Item.search(search_params).first
    render json: ItemSerializer.new(merchant)
  end

  def search_params
    params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)
  end

end
