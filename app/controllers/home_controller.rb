class HomeController < ApplicationController
  def index
    @queries = [:activity_list, :steps]
  end
end
