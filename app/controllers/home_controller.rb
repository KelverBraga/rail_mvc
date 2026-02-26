class HomeController < ApplicationController
  def index
    @car = Car.new
  end

  def store
    @cars = Car.order(created_at: :desc)
  end
end