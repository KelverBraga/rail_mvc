class HomeController < ApplicationController
  def index
    @available_cars = Car.where(is_selling: true)
    @unavailable_cars = Car.where(is_selling: false)
    @all_cars = Car.all
  end
end