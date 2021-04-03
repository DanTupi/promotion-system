class PromotionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create
                                              generate_coupons]  
  before_action :set_promotion, only: %i[show generate_coupons
                                        edit update destroy]

  def index
    @promotions = Promotion.all 
  end

  def show
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @promotion.update(promotion_params)
      redirect_to @promotion, notice: t('.success') 
    else
      render :edit 
    end
  end

  def destroy
    @promotion.destroy
    redirect_to promotions_path
  end

  def generate_coupons
    @promotion.generate_coupons! 
    redirect_to @promotion, notice: t('.success') 
  end
  
  def search
    @promotions = Promotion.search(params[:query])
    render :index
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])      
  end

  def promotion_params
    params
      .require(:promotion)
      .permit(:name, :description, :code, :discount_rate,
              :coupon_quantity, :expiration_date)
  end
end
