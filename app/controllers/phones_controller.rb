class PhonesController < ApplicationController
  def index
    @phones = Phone.all.order(:number)
  end

  def show
    @phone = Phone.find(params[:id])
  end

  def edit
    @phone = Phone.find(params[:id])
  end

  def update
    # pp(params)
    @phone = Phone.find(params[:id])
    if @phone.update(phone_params)
      redirect_to phone_path(@phone)
    else
      render :edit
    end
  end

  private

  def phone_params
    params
      .require(:phone)
      .permit(:phone_type,
              :number,
              :id,
              person_attributes: [
                :id,
                :name
              ])
  end
end
