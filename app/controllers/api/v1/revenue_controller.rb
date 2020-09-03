class Api::V1::RevenueController < ApplicationController
  def show
    revenue = Invoice.revenue_between_dates(date_params)
    render json: "{\"data\":{\"id\":\"null\",\"attributes\":{\"revenue\":#{revenue}}}}"
  end

  private

  def date_params
    params.permit(:start, :end)
  end
end
