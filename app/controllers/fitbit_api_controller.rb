class FitbitApiController < ApplicationController

  before_filter :authenticate_user!

  def data_request
    client = current_user.fitbit_client
    output = client.activities_on_date('2015-12-12')
    render json: output
  end
end
