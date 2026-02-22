class CarsController < ApplicationController
  def index
    @available_cars = Car.where(is_selling: true)
  end
end