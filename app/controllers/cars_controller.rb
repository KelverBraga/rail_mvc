class CarsController < ApplicationController
  def index
    @all_cars = Car.all
    @available_cars = Car.where(is_selling: true)
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      # Redireciona de volta para a raiz (Home) em vez de /cars
      redirect_to root_path, notice: "Carro cadastrado com sucesso!"
    else
      @all_cars = Car.all
      @available_cars = Car.where(is_selling: true)
      # Renderiza a view da home novamente se houver erro
      render "home/index", status: :unprocessable_entity
    end
  end

  private

  def car_params
    params.require(:car).permit(:model, :year, :color, :electric, :is_selling, :price)
  end
end