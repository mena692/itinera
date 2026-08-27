class TripsController < ApplicationController
  before_action :authenticate_user!

  def new
    @trip = Trip.new
  end
  

end
