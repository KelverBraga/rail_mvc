class CarsController < ApplicationController
  def index
    @all_cars = Car.all
    @available_cars = Car.where(is_selling: true)
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @all_cars = Car.all
    @available_cars = Car.where(is_selling: true)

    fipe_price = ::FipePriceFinder.new(model: @car.model, year: @car.year).call
    comparison_message = nil

    if fipe_price && @car.price.present?
      diff = @car.price.to_f - fipe_price
      percent = fipe_price.positive? ? ((diff / fipe_price) * 100).round(1) : 0
      suggested_price = (fipe_price * 0.97).round(2)

      comparison_message =
        if diff > 0
          "O preço informado está #{percent.abs}% ACIMA da FIPE (R$ #{format('%.2f', fipe_price)}). "\
          "Para tornar a oferta mais atrativa, considere um valor em torno de R$ #{format('%.2f', suggested_price)}."
        elsif diff < 0
          "O preço informado está #{percent.abs}% ABAIXO da FIPE (R$ #{format('%.2f', fipe_price)}). "\
          "Um valor de referência de mercado é próximo de R$ #{format('%.2f', fipe_price)}."
        else
          "O preço informado está alinhado com a FIPE (R$ #{format('%.2f', fipe_price)})."
        end
    elsif fipe_price.nil?
      comparison_message = "O preço de referência não foi estimado porque este modelo/ano não existe na tabela de dados. O veículo foi cadastrado mesmo assim."
    end

    if @car.save
      notice_message = "Carro cadastrado com sucesso!"
      notice_message = "#{notice_message} #{comparison_message}" if comparison_message
      redirect_to price_history_car_path(@car), notice: notice_message
    else
      render "home/index", status: :unprocessable_entity
    end
  end

  def price_history
    @car = Car.find(params[:id])
    history = ::FipePriceHistory.new(model: @car.model).call
    @history_years = history.map { |h| h[:year_model] }
    @history_prices = history.map { |h| h[:avg_price_brl] }
  end

  def update
    @car = Car.find(params[:id])
    if @car.update(car_params)
      redirect_to store_path, notice: "Preço atualizado com sucesso."
    else
      redirect_to store_path, alert: @car.errors.full_messages.to_sentence
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to store_path, notice: "Carro removido da loja."
  end

  private

  def car_params
    params.require(:car).permit(:model, :year, :color, :electric, :is_selling, :price)
  end
end