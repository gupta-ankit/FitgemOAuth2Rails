class FitbitApiController < ApplicationController

  before_filter :authenticate_user!

  def data_request
    client = current_user.fitbit_client
    case params[:resource]
    when "activities"; output = client.activities_on_date(params[:date])
    when "sleep"; output = client.sleep_on_date(params[:date])
    when "activities/steps"; output = client.steps_on_date(params[:date])
    end
    render json: output
  end
end
