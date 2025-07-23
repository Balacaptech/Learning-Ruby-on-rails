module Api
  class CarsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      if params[:user_id]
        cars = Car.where(user_id: params[:user_id])
      else
        cars = Car.all
      end

      render json: cars
    end

    def show
      @car = Car.find_by(id: params[:id])
      if @car
        render json: @car
      else
        render json: { error: "Car not found" }, status: :not_found
      end
    end

    def create 
      car = Car.new(car_params)
      if car.save
        render json: { message: "Car created successfully", car: car }, status: :created
      else
        render json: { errors: car.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      car = Car.find(params[:id])
      if car.update(car_params)
        render json: { message: "Car updated successfully", car: car }, status: :ok
      else
        render json: { errors: car.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      car = Car.find(params[:id])
      if car.destroy
        render json: { message: "Car deleted successfully" }, status: :ok
      else
        render json: { errors: car.errors.full_messages }, status: :unprocessable_entity
      end
    end
    

    private

    def car_params
      params.permit(:name, :brand, :model, :user_id)
    end
  end
end
