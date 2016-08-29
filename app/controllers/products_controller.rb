class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @products = Product.all #給_index.html.erb用
    @product = Product.new(product_params)

    if @product.save
      render "sucess"
    else
      render :new
    end
  end

  private
  def product_params
    params.require(:product).permit(:title, :price)
  end
end
