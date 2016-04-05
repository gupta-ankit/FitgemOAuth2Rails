class FitbitApiController < ApplicationController

  before_filter :authenticate_user!

  def data_request
    client = current_user.fitbit_client
    case params[:resource]
    when 'daily_activity_summary'; output = client.activity_time_series(resource: 'calories', start_date: params[:date], period: '1d')
    when 'sleep'; output = client.sleep_logs(params[:date])
    when 'activities/steps'; output = client.activity_time_series(resource: 'steps', start_date: params[:date], period: '1d')
    when 'weight'; output = client.weight_logs(start_date: params[:date])
    end
    render json: output
  end
end
