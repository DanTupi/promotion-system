class ProductCategoriesController < ApplicationController

    def index
        @product_categories = ProductCategory.all
    end

    def new
        @product_category = ProductCategory.new
    end

    def show
        @product_category = ProductCategory.find(params[:id])
    end

    def create
        @product_category = ProductCategory.new(product_category_params)
        if @product_category.save
            redirect_to @product_category
        else
            render :new
        end
    end

    def edit
        @product_category = ProductCategory.find(params[:id])
    end

    def update
        @product_category = ProductCategory.find(params[:id])
        if @product_category.update(product_category_params)
            flash[:notice] = 'Categoria editada com sucesso'
            redirect_to @product_category
        else
            render :edit
        end
    end

    def destroy
        @product_category = ProductCategory.find(params[:id])
        @product_category.destroy
        redirect_to product_categories_path
    end


    private

    def product_category_params
        params.require(:product_category).permit(:name, :code) 
    end
end