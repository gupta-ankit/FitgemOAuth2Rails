class FitbitApiController < ApplicationController

  before_filter :authenticate_user!

  def data_request
    client = current_user.fitbit_client
    fdatum = FitbitDatum.where(user_id: current_user.id, date: params[:date], resource_type: params[:resource]).first
    if fdatum
      output = JSON.parse(fdatum.content)
    else
      case params[:resource]
      when 'daily_activity_summary'; output = client.activity_time_series(resource: 'calories', start_date: params[:date], period: '1d')
      when 'sleep'; output = client.sleep_logs(params[:date])
      when 'activities/steps'; output = client.activity_time_series(resource: 'steps', start_date: params[:date], period: '1d')
      when 'weight'; output = client.weight_logs(start_date: params[:date])
      end
      FitbitDatum.create(user_id: current_user.id, date: params[:date], content: output.to_json, resource_type: params[:resource])
    end
    # store the output in FitbitData
    render json: output
  end

  def get_call
    client = current_user.fitbit_client
    get_url = construct_get_url(params[:resource_uri], params[:get_params] || {})
    puts get_url
    render json: client.get_call( get_url )
    # render json: client.activity_list('2017-01-01', 'asc', 10)
  end

  private
  def construct_get_url(url, parameters)
    param_str = parameters.map{|k,v| "#{k}=#{v}"}.join("&")
    param_str = "?#{param_str}" if param_str != ""
    "#{url}#{param_str}"
  end
end
