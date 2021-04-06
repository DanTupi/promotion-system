class Api::V1::PromotionsController < Api::V1::ApiController
  before_action :set_promotion, only: %i[show  destroy]

  def index
    render json: Promotion.all
  end

  def show
    render json:  @promotion.as_json
  end

  def create
    @promotion = Promotion.create(promotion_params)

    if @promotion.save
      render json: @promotion, status: 201
    else
      render json: @promotion.errors, status: 406
    end
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