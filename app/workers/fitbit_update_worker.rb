class FitbitUpdateWorker
  include Sidekiq::Worker

  def perform(uid, collection_type, date)
    # Do something
  end
end
