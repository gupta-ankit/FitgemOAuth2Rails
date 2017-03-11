class SubscriptionsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:index]
  before_action :authenticate_user!, only: [:list, :add]


  def index
    if request.post?
      # in future add security feature to prevent hackers from posting fake requests
      # https://dev.fitbit.com/docs/subscriptions/#security
      updates = params['_json']
      for update in updates
        process_update(update)
      end
      render nothing: true, status: 204
    else
      if params[:verify] == ENV['FITBIT_SUBSCRIPTION_VERIFICATION_CODE']
        render :nothing => true, :status => 204
      else
        render :nothing => true, :status => 404
      end
    end
  end

  def add
    client = current_user.fitbit_client
    @res1 = client.create_subscription(type: 'activities', subscription_id: '001')
    @res2 = client.create_subscription(type: 'body', subscription_id: '002')
    @res3 = client.create_subscription(type: 'foods', subscription_id: '003')
  end

  def list
    client = current_user.fitbit_client
    @subs1 = client.subscriptions(type: 'activities')
    @subs2 = client.subscriptions(type: 'body')
    @subs3 = client.subscriptions(type: 'foods')
  end

  private
  def process_update(opts)
    # {"collectionType"=>"activities", "date"=>"2017-03-11", "ownerId"=>"39TFNX", "ownerType"=>"user", "subscriptionId"=>"001"}
    puts "========================"
    puts opts
    puts opts.class
    collection_type = opts["collectionType"]
    date = opts["date"]
    uid = opts["ownerId"]
    idty = Identity.where(uid: uid).first

    if idty && collection_type == 'activities'
      user = idty.user
      steps_fd = FitbitDatum.where(user_id: user.id, date: date, resource_type: 'activities/steps_data').first
      daily_activity_summary_fd = FitbitDatum.where(user_id: user.id, date: date, resource_type: 'activities/daily_activity_summary').first

      new_daily_activity_summary = user.fitbit_client.activity_time_series(resource: 'calories', start_date: date, period: '1d')
      new_steps_data = user.fitbit_client.activity_time_series(resource: 'steps', start_date: date, period: '1d')

      if steps_fd
        steps_fd.content = new_steps_data.to_json
        steps_fd.save
      else
        FitbitDatum.create(date: date, resource_type: 'activities/steps_data', user_id: user.id)
      end

      if daily_activity_summary_fd
        daily_activity_summary_fd.content = new_daily_activity_summary.to_json
        daily_activity_summary_fd.save
      else
        FitbitDatum.create(date: date, resource_type: 'activities/calories', user_id: user.id)
      end
    end

    if idty && collection_type == 'body'
      user = idty.user
      weight_fd = FitbitDatum.where(user_id: user.id, date: date, resource_type: 'weight').first
      new_weight_data = user.fitbit_client.weight_logs(start_date: date)
      if weight_fd
        weight_fd.content = new_weight_data.to_json
        weight_fd.save
      else
        FitbitDatum.create(date: date, resource_type: 'weight', user_id: user.id)
      end
    end
  end

end
