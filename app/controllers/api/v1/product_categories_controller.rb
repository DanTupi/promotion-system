class Api::V1::ProductCategoriesController < Api::V1::ApiController
  before_action :set_product_category, only: %i[show  destroy]

  def index
    render json: ProductCategory.all
  end

  def show
    render json:  @product_category.as_json
  end

  def create
    @product_category = ProductCategory.create(product_category_params)
    if @product_category.save
      render json: @product_category, status: 201
    else
      render json: @product_category.errors, status: 406
    end
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])      
  end

  def product_category_params
    params.require(:product_category).permit(:name, :code) 
  end
end